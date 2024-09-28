const functions = require('firebase-functions');

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
