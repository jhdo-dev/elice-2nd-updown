const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendPushNotification = functions.region("asia-northeast3").https.onCall(async (data, context) => {
    // 클라이언트로부터 받은 데이터
    const {token, title, body} = data;

    // 푸시 알림 메시지 구성-이거를 잘 적어야 한다.
    const message = {
        notification: {
            title: title,
            body: body,
        },
        token: token,
    };

    try {
        // 푸시 알림 전송
        const response = await admin.messaging().send(message);
        console.log("Successfully sent message:", response);
        return {success: true, message: "Notification sent successfully"};
    } catch (error) {
        console.log("Error sending message:", error);
        throw new functions.https.HttpsError("internal", "Error sending push notification");
    }
});

//fcm 토큰을 유저정보에 저장을 해놔야 한다.
//앱을 설치하고 킬때 기기고유의 토큰값을 기기에 저장해놔야
//유저 정보에도 저장되어있는것을 토큰으로 보낼거니깐 - inter을 여기서
//소스 붙여서

//상대방 토큰을 어떻게 받아서 보낼지..
//인덱스에 있는 서버에 있는 함수라서 그것을 바로 호출함.
// fcm 공부 열심히 하자..! 중급자...
// 구현만 해줘..제발

//10- 반발짝은 가더라...
//어떤식으로 동작하는지 -> 꼬리질문해서 대강 잡아보자,
// 전체적인걸 파악해라.
// 개념공부를 하고나서 하는 방향으로