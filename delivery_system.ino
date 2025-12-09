#define TRIG 9
#define ECHO 8
#define LED 13
#define BUZZER 12

bool isConfirmed = false; // 확인 버튼 눌렸는지 여부
unsigned long lastCheckTime = 0;

void setup() {
  Serial.begin(9600); // USB 시리얼 통신 시작
  pinMode(TRIG, OUTPUT);
  pinMode(ECHO, INPUT);
  pinMode(LED, OUTPUT);
  pinMode(BUZZER, OUTPUT);
}

void loop() {
  // 1. 프로세싱에서 보낸 명령 확인 (데이터가 들어왔는지 체크)
  if (Serial.available() > 0) {
    char command = Serial.read();
    if (command == 'C') { // 'C'라는 글자가 오면 확인 버튼 눌린 것으로 처리
      isConfirmed = true;
    }
  }

  // 2. 초음파 거리 측정
  long duration, distance;
  digitalWrite(TRIG, LOW);
  delayMicroseconds(2);
  digitalWrite(TRIG, HIGH);
  delayMicroseconds(10);
  digitalWrite(TRIG, LOW);

  duration = pulseIn(ECHO, HIGH);
  distance = duration * 17 / 1000;

  // 3. 프로세싱으로 거리 값 전송 (중요: println 사용)
  // 너무 빨리 보내면 프로세싱이 버벅일 수 있으므로 약간의 텀을 둠
  if (millis() - lastCheckTime > 100) {
    Serial.println(distance); 
    lastCheckTime = millis();
  }

  // 4. LED 및 부저 제어 로직
  if (distance <= 10) {
    // [택배 도착]
    if (isConfirmed == false) {
      // 확인 전: 알림 켜기
      digitalWrite(LED, HIGH);
      // 부저 소리 (삑- 삑- 거리게 하려면 tone 사용, 여기선 단순 ON)
      tone(BUZZER, 1000); 
    } else {
      // 확인 완료: 알림 끄기
      digitalWrite(LED, LOW);
      noTone(BUZZER);
    }
  } else {
    // [택배 없음] (물건 치움)
    digitalWrite(LED, LOW);
    noTone(BUZZER);
    isConfirmed = false; // 다음 택배를 위해 상태 초기화
  }
  
  delay(50); // 전체 루프 안정화
}