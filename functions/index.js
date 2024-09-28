const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// FCM 알림 전송 함수
exports.sendNotification = functions.https.onCall((data, context) => {
  const message = {
    notification: {
      title: data.title || '알림 제목',
      body: data.body || '알림 내용'
    },
    topic: data.topic || 'all_users' // 또는 특정 토픽이나 토큰
  };

  return admin.messaging().send(message)
    .then((response) => {
      console.log('Successfully sent message:', response);
      return {success: true};
    })
    .catch((error) => {
      console.log('Error sending message:', error);
      return {success: false};
    });
});

// 첫 번째 HTTP 함수 - 텍스트 반환
exports.helloFunction = functions.https.onRequest((req, res) => {
  res.send('Hello from Firebase!');
});

// 두 번째 HTTP 함수 - HTML 반환
exports.helloHtmlFunction = functions.https.onRequest((request, response) => {
  functions.logger.info('Hello World!');

  const htmlString = `
  <!DOCTYPE html>
  <html lang="en">
    <head>
      <meta charset="utf-8" />
      <title>Change Title</title>
    </head>
    <body>
      <div>test</div>
      <div>test</div>
      <div>test</div>
    </body>
  </html>
  `;

  // HTML 응답을 반환
  response.setHeader('Content-Type', 'text/html');
  response.status(200).send(htmlString);
});