
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.name,
    required this.message,
    required this.time,
  });
  final String name;
 final Widget message;
  final String time;

  @override
  Widget build(BuildContext context) {
    bool isMe = 
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
