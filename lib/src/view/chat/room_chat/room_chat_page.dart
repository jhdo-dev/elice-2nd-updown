import 'package:alarm_front/config/colors.dart';
import 'package:alarm_front/config/constants.dart';
import 'package:alarm_front/config/text_styles.dart';
import 'package:alarm_front/presentation/bloc/user/user_bloc.dart';
import 'package:alarm_front/presentation/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'widgets/drawer_widget/chat_drawer.dart';
import 'widgets/message_widget/message_widget.dart';

class RoomChatPage extends StatefulWidget {
  const RoomChatPage({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.subjectName,
  });

  final String roomId;
  final String roomName;
  final String subjectName;

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  late IO.Socket socket;
  TextEditingController _controller = TextEditingController();

  late final String myPlayerId;
  late final String displayName; // 사용자의 displayName

  List<String> messages = [];
  List<String> playerId = [];
  List<String> displayNames = []; // displayNames 리스트 추가

  List<bool> myTurn = [];

  List<String> msgDate = [];
  List<String> msgTime = [];

  List<String> playerList = [];

  List<bool> isDateChanged = [];

  @override
  void initState() {
    super.initState();

    final userBloc = context.read<UserBloc>();

    if (userBloc.state is GetUserSuccess) {
      final user = (userBloc.state as GetUserSuccess).user;
      myPlayerId = user.uuid!;

      // !!!닉네임 설정안하면 오류생김!!!
      displayName = user.displayName!;

      connectToServer(); // 서버 연결
    }
  }

  void connectToServer() async {
    socket = IO.io(Constants.chatUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.connect();

    socket.on('connect', (_) {
      print('=================connected: ${socket.id}');
      // 서버에 방 참여 이벤트 전송, playerId만 포함
      socket.emit('join', {
        'roomId': widget.roomId,
        'playerId': myPlayerId,
      });

      socket.emit('getUserList', widget.roomId);
    });

    // 클라이언트에서 받은 userList 데이터를 처리하는 부분
    socket.on('userList', (data) {
      setState(() {
        print('Received userList data: $data');

        // data['userList']가 List인지 확인하고, 아닌 경우 로그를 출력합니다.
        if (data['userList'] is List) {
          print('playerList updated: $playerList');
          playerList = List<String>.from(data['userList']);
        } else {
          print('userList 데이터가 비정상적입니다: ${data['userList']}');
        }
      });
    });

    // 서버로부터 이전 메시지 기록을 받을 때
    socket.on('previousMessages', (data) {
      setState(() {
        for (var msgData in data) {
          messages.add(msgData['msg']);
          playerId.add(msgData['playerId']);
          displayNames.add(msgData['displayName']); // displayName 저장
          myTurn.add(msgData['myTurn']);
          msgDate.add(msgData['msgDate']);
          msgTime.add(msgData['msgTime']);
          isDateChanged.add(msgData['isDateChanged']);
        }
      });
    });

    // 서버로부터 채팅 메시지를 받았을 때
    socket.on('msg', (data) {
      setState(() {
        messages.insert(0, data['msg']);
        playerId.insert(0, data['playerId']);
        displayNames.insert(0, data['displayName']); // displayName 저장
        myTurn.insert(0, data['myTurn']);
        msgDate.insert(0, data['msgDate']);
        msgTime.insert(0, data['msgTime']);
        isDateChanged.insert(0, data['isDateChanged']);
      });
    });

    socket.on('disconnect', (_) {
      print('disconnected');
      socket.emit('exit', {'roomId': widget.roomId});
    });

    socket.onConnectError((err) => print('Connect error: $err'));
    socket.onError((err) => print('Error: $err'));
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      DateTime dt = DateTime.now();
      String timeString =
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      String dateString =
          '${dt.year.toString()}년 ${dt.month.toString()}월 ${dt.day.toString()}일';

      FocusScope.of(context).unfocus();
      socket.emit('msg', {
        'roomId': widget.roomId,
        'msg': _controller.text,
        'playerId': myPlayerId,
        'myTurn': _checkMyTurn(timeString),
        'msgDate': dateString,
        'msgTime': timeString,
        'isDateChanged': _checkIsDateChanged(dateString),
        // 서버에서 displayName을 가져와 전송하기 때문에 여기서는 필요 없음
      });

      _controller.clear();
    }
  }

// myTurn을 위한 함수; 말풍선 UI를 위해 사용;
  bool _checkMyTurn(String timeString) {
    if (myTurn.isEmpty) {
      // 첫 메시지는 무조건 false;
      return false;
    } else if (playerId[0] != myPlayerId) {
      // 이전 메시지가 내가 보낸 것이 아니면 무조건 false;
      return false;
    } else if (msgTime[0] != timeString) {
      // 일분 경과하면 무조건 false;
      return false;
    } else {
      // 첫 메시지가 아니며 내가 보냈고 일분이 안지났다면 true;
      return true;
    }
  }

// isDateChanged를 위한 함수; 날짜 바(DateBar)를 위해 사용;
  bool _checkIsDateChanged(String dateString) {
    if (isDateChanged.isEmpty) {
      // 첫 메시지는 무조건 true;
      return true;
    } else if (msgDate[0] != dateString) {
      // 이전 메시지와 날짜가 다르면 무조건 true;
      return true;
    } else {
      // 첫 메시지가 아니고 이전 메시지와 같은 날짜이면 false;
      return false;
    }
  }

  @override
  void dispose() {
    socket.emit('exit', {'roomId': widget.roomId});
    socket.dispose();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppbarWidget(
        title: widget.roomName,
        titleSize: 21.sp,
        isBackIcon: true,
        actions: [
          //왼쪽상단 메뉴
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(_focusNode);
              _scaffoldKey.currentState?.openEndDrawer();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(children: [
                Positioned(
                  top: 0.1.h,
                  left: 0.1.w,
                  child: Icon(
                    Icons.menu,
                    color: AppColors.backgroundColor.withOpacity(0.3),
                    size: 30.w,
                  ),
                ),
                Icon(
                  Icons.menu,
                  color: AppColors.focusColor,
                  size: 28.w,
                )
              ]),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
        ],
      ),
      endDrawer: ChatDrawer(
          widget: widget, playerList: playerList, focusNode: _focusNode),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              // 중앙 채팅방
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return MessageWidget(
                      myPlayerId,
                      playerId[index],
                      messages[index],
                      myTurn[index],
                      displayName: displayNames[index], // displayName을 전달
                      msgDate: msgDate[index],
                      msgTime: msgTime[index],
                      isDateChanged: isDateChanged[index],
                    );
                  },
                ),
              ),
              // 하단 텍스트 필드
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.w, horizontal: 10.w),
                child: TextField(
                  minLines: 1,
                  maxLines: 4,
                  controller: _controller,
                  onChanged: (value) {
                    setState(() {});
                  },
                  style: TextStyles.mediumText,
                  // 입력창
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20.w),
                    hintText: '메시지를 입력하세요',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.bottomNavColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.bottomNavColor.withOpacity(0.5),
                      ),
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                    // 보내기 버튼
                    suffixIcon: Visibility(
                      visible: _controller.text.isNotEmpty,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: Container(
                          height: 30.h,
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Transform.rotate(
                            angle: -0.5,
                            child: IconButton(
                              onPressed: _sendMessage,
                              icon: Icon(
                                Icons.send,
                                color: AppColors.bottomNavColor,
                                size: 16.sp,
                              ),
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.only(bottom: 1.h),
                                shape: CircleBorder(),
                                backgroundColor: AppColors.focusPurpleColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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

/* 나중에 시간나면 할일
1. 앱바 오른쪽에 드로워메뉴 추가해서 채팅방 유저목록 불러온 후 카드or리스트타일로 표시하기; (일단 왼료)
1-2. 유저목록 프로필 사진 업데이트;
1-3. textfield를 열었다 닫은 후 drawer을 열면 textfield가 같이 열리는 버그가있음; (완료; focusNode로 해결)
1-4. 유저목록에 같은 유저가 중복되어 표시됨;
2. 같은유저의 연속된 채팅은 이름표시하지 않음; (완료)
3. 하단구석에 채팅시간 표시; (완료)
3-2. 같은 분일때 시간표시 생략; (완료)
4. 방이름 가져오기; (완료)
5. 날짜바 넣기; (완료)
6. 보내기버튼 디자인 수정; (완료)
6-2. 보내기 버튼 애니메이션 추가;
7.닉네임변경시 과거 기록도 일괄변경; // 연기

오류
1. 방이름, 필터, 닉넴 글자수 제한하기;
*/
