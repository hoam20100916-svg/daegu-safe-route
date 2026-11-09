# 대구 안심길 (Flutter 시연용 프로젝트)

## 현재 들어 있는 기능
- OpenStreetMap 기반 대구 중심부 지도
- 시연용 빠른 경로 / 안심 요소 경로 두 가지 표시
- 경찰·소방·CCTV·가로등 예시 마커 표시/숨김
- 경로 선택 및 전체 경로 보기
- Android APK로 빌드할 수 있는 Flutter 소스

## 중요한 한계
이 버전은 **시연용 UI 프로토타입**입니다.
- 경로 선은 실제 보행자 도로망을 따라 계산한 결과가 아닙니다.
- 시설 마커는 실제 시설 위치가 아닌 예시 좌표입니다.
- 표시된 시간도 임의의 예시이며 실제 예상 시간이 아닙니다.
- 안전 점수나 실제 안전성 판단은 제공하지 않습니다.

실제 서비스로 바꾸려면 대구시/공공데이터의 최신 시설 좌표와 보행자 경로 API를 연결하고, 데이터의 갱신일·누락 범위·이용 조건을 검증해야 합니다.

## 설치 준비 (Windows 11)
1. Flutter SDK 설치: https://docs.flutter.dev/get-started/install/windows
2. Android Studio 설치: https://developer.android.com/studio
3. Android Studio의 SDK Manager에서 Android SDK와 Command-line Tools 설치
4. PowerShell에서 아래 명령 실행:

```powershell
flutter doctor
flutter create daegu_safe_route_demo
```

5. 생성된 프로젝트에 이 ZIP의 `lib` 폴더와 `pubspec.yaml`을 덮어씁니다.
6. 의존성 설치 및 실행:

```powershell
cd daegu_safe_route_demo
flutter pub get
flutter run
```

## APK 만들기
휴대폰에 설치할 APK:

```powershell
flutter build apk --release
```

생성 위치:
`build\app\outputs\flutter-apk\app-release.apk`

USB로 연결한 안드로이드 기기에 설치하려면:

```powershell
flutter install
```

## 지도 타일 관련
지도는 OpenStreetMap 공개 타일 서버를 사용합니다. 대량 트래픽의 상용 서비스 용도로 무단 사용하지 말고 OpenStreetMap 타일 이용 정책을 확인하세요. 실제 배포 단계에서는 적절한 타일 제공자 또는 자체 타일 서비스를 검토하세요.

## 다음 개발 단계
1. 지도 탭으로 출발지/목적지 지정
2. 실제 보행자 경로 API 연결
3. 대구 CCTV·가로등·경찰·소방시설 데이터 연결
4. 도로 구간 단위의 설명 가능한 시설 커버리지 지표 설계
5. 데이터 출처·갱신일·불확실성 표시


## APK를 Flutter/Android Studio 설치 없이 만드는 방법 (GitHub Actions)
1. GitHub에서 새 Repository를 만듭니다.
2. 이 ZIP의 `pubspec.yaml`, `lib` 폴더, `.github` 폴더를 저장소 최상위에 업로드합니다.
3. 저장소의 **Actions** 탭에서 `Build Android APK`를 선택합니다.
4. **Run workflow**를 누르고 빌드가 끝날 때까지 기다립니다.
5. 성공한 실행 항목을 열고 아래 **Artifacts**에서 `daegu-safe-route-apk`를 다운로드합니다.
6. ZIP 압축을 풀고 `app-release.apk`를 Android 휴대폰으로 옮겨 설치합니다.

이 방식은 GitHub 계정과 인터넷이 필요하며, Android Studio/Flutter를 PC에 설치하지 않고 클라우드에서 빌드합니다.
