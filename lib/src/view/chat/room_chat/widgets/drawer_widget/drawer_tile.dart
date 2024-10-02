import 'package:alarm_front/config/colors.dart';
import 'package:alarm_front/config/text_styles.dart';
import 'package:flutter/material.dart';

class drawerTile extends StatelessWidget {
  const drawerTile({
    super.key,
    required this.player,
  });

  final String player;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: AppColors.cardColor,
          leading: SizedBox(),
          title: Text(
            player,
            style: TextStyles.mediumText,
          ),
        ),
        SizedBox(height: 2),
      ],
    );
  }
}
