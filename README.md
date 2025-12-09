<div align="center">

<!-- 프로젝트 로고 혹은 타이틀 영역 -->

<h1>📦 Smart Delivery Notification System</h1>
<h3>🔔 아두이노 & 앱 인벤터 기반 스마트 택배 알림 시스템</h3>

<!-- 프로젝트 소개 -->

<p>
<b>Arduino, Processing, and MIT App Inventor based IoT Project</b>




현관 앞 택배 도착을 실시간으로 감지하고




원격으로 알림을 제어하는 <b>스마트 홈 IoT 시스템</b>입니다.
</p>

</div>

<!-- 1. 개요 섹션 -->

📖 프로젝트 개요 (Overview)

<p align="justify">
이 프로젝트는 고가의 Wi-Fi 모듈(ESP8266 등) 없이, <b>PC를 중계 서버(Bridge)로 활용</b>하여 아두이노와 스마트폰 간의 양방향 통신을 구현한 경제적인 IoT 시스템입니다. 초음파 센서가 문 앞의 물체를 감지하면 스마트폰 앱으로 "택배 도착" 알림을 보내고, 사용자는 앱의 버튼을 통해 원격으로 아두이노의 알림(LED/부저)을 제어할 수 있습니다.
</p>

<!-- 2. 주요 기능 섹션 (테이블 레이아웃 사용) -->

💡 주요 기능 (Key Features)

<div align="center">

<table>
<tr>
<td align="center" width="25%"><b>📡 실시간 감지</b></td>
<td align="center" width="25%"><b>🔔 시청각 알림</b></td>
<td align="center" width="25%"><b>📱 모바일 모니터링</b></td>
<td align="center" width="25%"><b>🎛️ 원격 제어</b></td>
</tr>
<tr>
<td align="center">초음파 센서를 통해
10cm 이내의



물체(택배) 감지</td>
<td align="center">물체 감지 시



LED 점등 및
부저 울림</td>
<td align="center">앱을 통해



실시간 거리 확인
및 도착 여부 파악</td>
<td align="center">앱의 버튼으로



아두이노의 알림을
원격으로 해제</td>
</tr>
</table>

</div>

<!-- 3. 아키텍처 섹션 -->

⚙️ 시스템 아키텍처 (System Architecture)

<div align="center">
<!-- 시스템 구성 요소 설명 (HTML 테이블 적용) -->

<table>
<tr>
<th align="center" width="30%">Component</th>
<th align="center" width="70%">Role & Connection Flow</th>
</tr>
<tr>
<td align="center"><b>1. Arduino</b></td>
<td>
• <b>역할:</b> 센서 데이터 수집 및 액추에이터(LED, 부저) 제어




• <b>연결:</b> 초음파 센서로 거리 측정 → USB 시리얼로 PC 전송
</td>
</tr>
<tr>
<td align="center"><b>2. Processing (PC)</b></td>
<td>
• <b>역할:</b> 아두이노와 스마트폰 사이의 <b>중계 서버(Bridge)</b>




• <b>연결:</b> 아두이노 데이터를 HTTP 웹 서버로 변환하여 Wi-Fi 송출
</td>
</tr>
<tr>
<td align="center"><b>3. App Inventor</b></td>
<td>
• <b>역할:</b> 사용자 인터페이스(UI) 제공 및 원격 제어




• <b>연결:</b> 1초마다 서버(PC)에 접속하여 상태 확인 (Polling 방식)
</td>
</tr>
</table>

</div>

<!-- 4. 하드웨어 구성 (HTML 테이블 적용) -->

🛠 하드웨어 구성 (Hardware Requirements)

<div align="center">

<table>
<tr>
<th align="center">부품명 (Component)</th>
<th align="center">개수 (Qty)</th>
<th align="left">비고 (Note)</th>
</tr>
<tr>
<td align="center"><b>Arduino Uno</b></td>
<td align="center">1</td>
<td align="left">메인 컨트롤러</td>
</tr>
<tr>
<td align="center"><b>HC-SR04</b> (초음파 센서)</td>
<td align="center">1</td>
<td align="left">Trig(9), Echo(8) 연결</td>
</tr>
<tr>
<td align="center"><b>LED</b></td>
<td align="center">1</td>
<td align="left">Pin 13 연결</td>
</tr>
<tr>
<td align="center"><b>Piezo Buzzer</b></td>
<td align="center">1</td>
<td align="left">Pin 12 연결</td>
</tr>
<tr>
<td align="center"><b>PC / Laptop</b></td>
<td align="center">1</td>
<td align="left">Processing 서버 구동용 (Wi-Fi 필수)</td>
</tr>
<tr>
<td align="center"><b>Android Smartphone</b></td>
<td align="center">1</td>
<td align="left">PC와 동일 Wi-Fi 연결 필수</td>
</tr>
</table>

</div>

<!-- 5. 소프트웨어 설정 (아코디언 UI 사용 - details 태그) -->

💻 소프트웨어 및 환경 설정 (Setup Guide)

<details>
<summary><b>1. Arduino 설정 (클릭하여 펼치기)</b></summary>




<ul>
<li><code>delivery_system.ino</code> 파일을 아두이노에 업로드합니다.</li>
<li><b>Pin Map:</b>
<ul>
<li><code>Trig</code>: 9</li>
<li><code>Echo</code>: 8</li>
<li><code>LED</code>: 13</li>
<li><code>Buzzer</code>: 12</li>
</ul>
</li>
</ul>

</details>

<details>
<summary><b>2. Processing 서버 설정 (클릭하여 펼치기)</b></summary>




<ul>
<li>Processing IDE를 설치하고 <code>delivery_server.pde</code>를 실행합니다.</li>
<li><b>주의사항:</b>
<ul>
<li>코드 내 <code>Serial.list()[0]</code>의 포트 번호가 아두이노와 일치하는지 확인하세요.</li>
<li>실행 시 방화벽 경고가 뜨면 <b>"액세스 허용"</b>을 클릭해야 합니다.</li>
<li>실행 후 콘솔이나 <code>ipconfig</code> 명령어로 <b>PC의 IP 주소</b>를 확인해 두세요.</li>
</ul>
</li>
</ul>

</details>

<details>
<summary><b>3. MIT App Inventor 설정 (클릭하여 펼치기)</b></summary>




<ul>
<li><code>smart_delivery.aia</code> 파일을 <a href="https://www.google.com/search?q=http://ai2.appinventor.mit.edu/">MIT App Inventor</a> 사이트에 import 합니다.</li>
<li><b>앱 설정:</b>
<ul>
<li>App Inventor에서 Web을 클릭한 후 IP를 수정해주세요.</li>
<li>또한 Blocks 탭에 url을 본인 IP로 수정해주세요.</li>
<li>예시: <code>192.168.0.10:8080</code></li>
</ul>
</li>
</ul>

</details>

<!-- 6. 사용 방법 -->

🚀 사용 방법 (How to use)

서버 시작: 아두이노를 PC에 연결하고 Processing 스케치를 실행합니다.

Wi-Fi 연결: 스마트폰을 PC와 동일한 Wi-Fi에 연결합니다.

앱 연결: 앱을 실행하고 IP 주소를 설정한 뒤 **"연결 설정"**을 누릅니다.

택배 감지: 초음파 센서 앞 10cm 이내에 물건을 둡니다.

Arduino: LED 켜짐, 부저 울림 🚨

App: 화면이 초록색으로 변하고 "택배 도착" 알림 표시 🟩

수령 확인: 앱에서 "수령 확인" 버튼을 누릅니다.

Arduino: LED/부저 꺼짐 🔕

App: "확인 완료" 팝업 및 버튼 비활성화 ✅

<!-- 7. 트러블슈팅 (아코디언 UI) -->

🔧 트러블슈팅 (FAQ)

<details>
<summary><b>Q. 앱에서 거리 값이 변하지 않아요.</b></summary>
<div markdown="1">
<blockquote>
<ul>
<li>PC와 스마트폰이 <b>반드시 같은 Wi-Fi 공유기</b>에 연결되어 있어야 합니다.</li>
<li>PC의 <b>방화벽 설정</b>에서 Java(Processing)의 통신을 차단하고 있는지 확인하세요.</li>
</ul>
</blockquote>
</div>
</details>

<details>
<summary><b>Q. 아두이노 포트 에러가 발생해요.</b></summary>
<div markdown="1">
<blockquote>
<ul>
<li>Processing 코드에서 <code>Serial.list()[0]</code> 부분을 <code>[1]</code>이나 <code>[2]</code>로 변경해 보세요.</li>
<li>아두이노 IDE의 시리얼 모니터가 켜져 있다면 끄고 다시 실행하세요 (포트 충돌 방지).</li>
</ul>
</blockquote>
</div>
</details>

<details>
<summary><b>Q. 버튼이 눌리지 않아요.</b></summary>
<div markdown="1">
<blockquote>
<ul>
<li>택배가 감지되지 않은 <b>대기 상태(빨간 화면)</b>에서는 오작동 방지를 위해 버튼이 비활성화됩니다.</li>
</ul>
</blockquote>
</div>
</details>

<div align="center">
<hr>
<h3>👤 Author</h3>
<p>
<b>Name:</b> [본인 이름 또는 닉네임] &nbsp;|&nbsp; <b>Contact:</b> [이메일 주소]
</p>





<i>This project was created for educational purposes.</i>
</div>
