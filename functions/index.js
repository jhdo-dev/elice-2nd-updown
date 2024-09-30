const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendNotificationToTopic = functions.https.onCall(async (data, context) => {
  console.log('Function called with data:', JSON.stringify(data));

  try {
    // title 필드 검증 및 기본값 설정
    let title = data.title;
    if (!title || typeof title !== 'string' || title.trim() === '') {
      console.warn('Invalid or missing title, using default');
      title = '새로운 알림';
    } else {
      title = title.trim();
    }

    // body 필드 검증
    if (!data.body || typeof data.body !== 'string' || data.body.trim() === '') {
      console.error('Invalid body:', data.body);
      throw new functions.https.HttpsError('invalid-argument', 'The body field is required and must be a non-empty string.');
    }

    // topic 필드 검증
    if (!data.topic || typeof data.topic !== 'string' || data.topic.trim() === '') {
      console.error('Invalid topic:', data.topic);
      throw new functions.https.HttpsError('invalid-argument', 'The topic field is required and must be a non-empty string.');
    }

    const message = {
      notification: {
        title: title,
        body: data.body.trim(),
      },
      topic: data.topic.trim(),
    };

    console.log('Sending message to topic:', message.topic);
    console.log('Message content:', message.notification);

    const response = await admin.messaging().send(message);
    console.log('Successfully sent message:', response);

    return {
      success: true,
      messageId: response,
      details: `Notification sent to topic ${data.topic}`
    };

  } catch (error) {
    console.error('Error sending message:', error);
    console.error('Error details:', JSON.stringify(error));
    throw new functions.https.HttpsError('internal', `Error sending notification: ${error.message}`);
  }
});