import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DayBar extends StatelessWidget {
  final String msgDate;
  final bool isDateChanged;

  const DayBar({
    super.key,
    required this.msgDate,
    required this.isDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (isDateChanged) {
      return Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 100.h,
        child: Text(
          msgDate,
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
