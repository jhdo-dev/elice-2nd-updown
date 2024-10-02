import 'package:alarm_front/config/colors.dart';
import 'package:alarm_front/config/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.isMe,
    required this.myTurn,
    required this.message,
  });

  final bool isMe;
  final bool myTurn;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMe
          ? EdgeInsets.fromLTRB(100.w, 5.w, 0.w, 5.w)
          : EdgeInsets.fromLTRB(0.w, 5.w, 100.w, 5.w),
      child: Container(
        decoration: BoxDecoration(
          // 연속된 말풍선 색깔 설정
          color: isMe
              ? AppColors.sendMsgBurbleColor
              : AppColors.receiveMsgBurbleColor,
          borderRadius: myTurn
              ? BorderRadius.all(Radius.circular(15.r))
              : BorderRadius.only(
                  bottomRight: Radius.circular(15.r),
                  bottomLeft: Radius.circular(15.r),
                  topRight: isMe ? Radius.circular(0.r) : Radius.circular(15.r),
                  topLeft: isMe ? Radius.circular(15.r) : Radius.circular(0.r),
                ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        margin:
            isMe ? EdgeInsets.only(right: 14.w) : EdgeInsets.only(left: 14.w),
        child: Text(
          message,
          style: TextStyles.largeText,
        ),
      ),
    );
  }
}
