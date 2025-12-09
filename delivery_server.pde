import processing.serial.*;
import processing.net.*; 

Serial myPort;
Server myServer; 

String data = "";
int distance = 0;
boolean isArrived = false;

// UI 디자인 색상 변수
int cBackground = #2D3436; // 다크 그레이 (배경)
int cCard = #636E72;       // 카드 배경
int cSuccess = #00B894;    // 민트색 (도착)
int cWarning = #D63031;    // 빨간색 (대기)
int cText = #DFE6E9;       // 밝은 회색 (텍스트)
int cBtnNormal = #0984E3;  // 파란색 (버튼)
int cBtnHover = #74B9FF;   // 밝은 파란색 (버튼 호버)

// 버튼 위치 변수
int btnX, btnY, btnW, btnH;

// 폰트 변수
PFont mainFont;

void setup() {
  size(400, 500); // 화면 길이를 조금 늘림
  smooth();       // 도형을 부드럽게 처리
  
  // 1. 폰트 설정 (기본 SansSerif 폰트 사용)
  mainFont = createFont("SansSerif", 20, true);
  textFont(mainFont);
  
  // 2. 버튼 위치 초기화 (화면 하단)
  btnW = 240;
  btnH = 60;
  btnX = width/2 - btnW/2;
  btnY = height - 100;
  
  // 3. 아두이노 연결
  printArray(Serial.list());
  if (Serial.list().length > 0) {
    try {
      // [주의] 본인의 포트 번호 인덱스로 수정하세요 ([0] 또는 [1])
      myPort = new Serial(this, Serial.list()[0], 9600);
      myPort.bufferUntil('\n');
    } catch (Exception e) {
      println("Serial Connection Error: " + e);
    }
  }
  
  // 4. 서버 시작
  myServer = new Server(this, 8080);
}

void draw() {
  background(cBackground);

  // [UI] 상단 타이틀
  textAlign(CENTER, CENTER);
  fill(cText);
  textSize(24);
  text("Smart Delivery System", width/2, 40);
  
  // [UI] 메인 원형 게이지 (거리 표시)
  drawGauge();

  // [UI] 상태 메시지
  textSize(18);
  if (distance <= 10) {
    isArrived = true;
    fill(cSuccess);
    text("Package Arrived!", width/2, 280);
  } else {
    isArrived = false;
    fill(cWarning);
    text("Waiting for Package...", width/2, 280);
  }

  // [UI] 확인 버튼 그리기
  drawButton();
  
  // [서버] 클라이언트(앱) 요청 처리 로직 (기존과 동일)
  handleServerRequests();
}

// 원형 게이지 그리기 함수
void drawGauge() {
  float centerX = width/2;
  float centerY = 170;
  float radius = 180;
  
  // 바깥 테두리
  noFill();
  strokeWeight(15);
  stroke(cCard); 
  ellipse(centerX, centerY, radius, radius);
  
  // 상태에 따른 색상 테두리
  if (distance <= 10) stroke(cSuccess);
  else stroke(cWarning);
  
  // 호(Arc) 그리기 - 조금 더 멋지게
  // -90도(12시 방향)에서 시작
  float endAngle = map(constrain(distance, 0, 50), 0, 50, TWO_PI - PI/2, -PI/2);
  // 거리가 가까울수록 원이 꽉 차게 보이도록 반대로 매핑하거나, 
  // 단순하게 색상 링만 표시 (여기서는 전체 링 표시)
  ellipse(centerX, centerY, radius, radius);
  
  // 중앙 거리 텍스트
  noStroke();
  fill(cText);
  textSize(60);
  text(distance, centerX, centerY - 10);
  
  textSize(20);
  fill(150);
  text("cm", centerX, centerY + 35);
}

// 버튼 그리기 함수
void drawButton() {
  // 택배가 왔을 때만 버튼 활성화
  if (isArrived) {
    // 마우스 호버 효과 (마우스가 버튼 위에 있으면 밝게)
    if (mouseX > btnX && mouseX < btnX + btnW && mouseY > btnY && mouseY < btnY + btnH) {
      fill(cBtnHover);
      cursor(HAND); // 마우스 커서 모양 변경
    } else {
      fill(cBtnNormal);
      cursor(ARROW);
    }
  } else {
    // 비활성화 상태
    fill(cCard); 
    cursor(ARROW);
  }
  
  noStroke();
  rect(btnX, btnY, btnW, btnH, 30); // 둥근 모서리 (반경 30)
  
  // 버튼 텍스트
  fill(255);
  textSize(20);
  if (isArrived) text("CONFIRM RECEIPT", width/2, btnY + btnH/2 - 3);
  else text("NO PACKAGE", width/2, btnY + btnH/2 - 3);
}

// 서버 요청 처리 분리
void handleServerRequests() {
  Client thisClient = myServer.available();
  if (thisClient != null) {
    String request = thisClient.readString();
    if (request != null) {
      if (request.indexOf("GET /status") != -1) {
        thisClient.write("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n" + distance);
      }
      else if (request.indexOf("GET /confirm") != -1) {
        sendConfirmToArduino();
        thisClient.write("HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nConfirmed");
      }
      thisClient.stop();
    }
  }
}

// 아두이노 데이터 수신
void serialEvent(Serial myPort) {
  try {
    data = myPort.readStringUntil('\n');
    if (data != null) {
      data = trim(data);
      if (data.length() > 0) distance = int(data);
    }
  } catch(Exception e) { }
}

// 마우스 클릭 이벤트
void mousePressed() {
  // 버튼 영역 클릭 확인
  if (mouseX > btnX && mouseX < btnX + btnW && 
      mouseY > btnY && mouseY < btnY + btnH) {
    if (isArrived) sendConfirmToArduino();
  }
}

void sendConfirmToArduino() {
  if (myPort != null) {
    myPort.write('C');
    println("Sent: Confirm Signal");
  }
}
