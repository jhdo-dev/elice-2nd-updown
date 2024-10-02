import 'package:flutter/material.dart';

import 'day_bar.dart';
import 'display_name.dart';
import 'message_bubble.dart';

class MessageWidget extends StatelessWidget {
  final String myPlayerId;
  final String playerId;
  final String message;
  final bool myTurn;
  final String displayName; // displayName 추가
  final String msgDate;
  final String msgTime;
  final bool isDateChanged;

  // 말풍선이 사용자(me) 또는 상대방 두가지 상태를 가짐
  late final bool isMe = myPlayerId == playerId;

  MessageWidget(this.myPlayerId, this.playerId, this.message, this.myTurn,
      {super.key,
      required this.displayName,
      required this.msgDate,
      required this.msgTime,
      required this.isDateChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // 날짜바
        DayBar(msgDate: msgDate, isDateChanged: isDateChanged),
        // displayName 스타일
        DisplayName(displayName: displayName, msgTime: msgTime, myTurn: myTurn),
        // 말풍선 스타일
        MessageBubble(isMe: isMe, myTurn: myTurn, message: message),
      ],
    );
  }
}
