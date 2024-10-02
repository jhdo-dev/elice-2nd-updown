import 'package:alarm_front/config/colors.dart';
import 'package:alarm_front/presentation/pages/room_chat/room_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'drawer_tile.dart';

class ChatDrawer extends StatelessWidget {
  ChatDrawer({
    super.key,
    required this.widget,
    required this.playerList,
    required this.focusNode,
  });

  final RoomChatPage widget;
  final List<String> playerList;
  final FocusNode focusNode;

// 무지성 중복제거; 동일닉네임도 제거해버림;
  late Set<String> playerSet = playerList.toSet();

  void deduplication() {
    print('playerList: $playerList');
    print('set: $playerSet');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundColor,
      child: Focus(
        focusNode: focusNode,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 40.h),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Text(
                        '[ ${widget.subjectName} ]',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.roomName,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
                height: 40,
                color: AppColors.focusColor,
              ),
              Text(
                '현재 대화상대',
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: playerSet.length,
                    itemBuilder: (context, index) {
                      deduplication();
                      return drawerTile(player: playerSet.elementAt(index));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
