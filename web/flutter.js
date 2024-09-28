// Flutter 웹을 실행하기 위한 기본 스크립트
if ('serviceWorker' in navigator) {
  window.addEventListener('load', function () {
    navigator.serviceWorker.register('flutter_service_worker.js');
  });
}
