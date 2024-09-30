const { onCall } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const admin = require("firebase-admin");

// 글로벌 옵션 설정 (지역 설정)
setGlobalOptions({ region: "asia-northeast3" });

// Firebase Admin SDK 초기화
admin.initializeApp();

// 방 생성 시 호출되는 Firebase Functions
exports.createRoom = onCall(async (data, context) => {
    const { roomId, roomName, token } = data;

    // 여기서 방 생성 로직을 처리할 수 있음 (필요한 경우 Firestore 등에 저장)

    // 푸시 알림 메시지 구성
    const message = {
        notification: {
            title: "새로운 방이 생성되었습니다!",
            body: `${roomName} 방이 생성되었습니다. 지금 참여해보세요!`
        },
        token: token  // FCM 토큰
    };

    try {
        // 푸시 알림 전송
        const response = await admin.messaging().send(message);
        console.log('Successfully sent message:', response);
        return { success: true, message: "Notification sent successfully" };
    } catch (error) {
        console.log('Error sending message:', error);
        throw new Error('Error sending push notification');
    }
});