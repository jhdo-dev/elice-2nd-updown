import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:up_down/src/model/message.dart';
import 'package:up_down/src/provider/message_repository_provider.dart';

class MessageBubble extends ConsumerWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.myId,
  });
  final Message message;
  final String myId;

  String _formatDateTime(DateTime dateTime) {
    // 12시간제를 위한 시간 계산
    int hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour == 0
            ? 12
            : dateTime.hour;
    String period = dateTime.hour >= 12 ? 'PM' : 'AM';
    String minute = dateTime.minute.toString().padLeft(2, '0');

    // 월, 일 형식
    String date = '${dateTime.month}/${dateTime.day}';

    return '$date $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMe = message.userId == myId;

    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: isMe
              ? const EdgeInsets.fromLTRB(100, 5, 0, 5)
              : const EdgeInsets.fromLTRB(0, 5, 100, 5),
          child: Container(
            decoration: BoxDecoration(
              // 연속된 말풍선 색깔 설정
              color: isMe
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.only(
                bottomRight: const Radius.circular(15),
                bottomLeft: const Radius.circular(15),
                topRight:
                    isMe ? const Radius.circular(0) : const Radius.circular(15),
                topLeft:
                    isMe ? const Radius.circular(15) : const Radius.circular(0),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            margin: isMe
                ? const EdgeInsets.only(right: 14)
                : const EdgeInsets.only(left: 14),
            child: message.message.startsWith('http') // 메시지가 URL이면 이미지로 렌더링
                //이미지 크기 세팅
                ? Image.network(message.message)
                : Text(message.message), // 텍스트 메시지,
          ),
        ),
      ],
    );
  }
}
