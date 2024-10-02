import 'package:alarm_front/config/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DisplayName extends StatelessWidget {
  const DisplayName({
    super.key,
    required this.displayName,
    required this.msgTime,
    required this.myTurn,
  });

  final String displayName;
  final String msgTime;
  final bool myTurn;

  @override
  Widget build(BuildContext context) {
    if (!myTurn) {
      return Container(
        margin: EdgeInsets.only(top: 10.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              displayName,
              style: TextStyles.largeText,
            ),
            SizedBox(width: 12.w),
            Text(
              msgTime,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
