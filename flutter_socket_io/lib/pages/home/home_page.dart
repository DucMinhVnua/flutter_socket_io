import 'package:flutter/material.dart';
import 'package:flutter_socket_io/models/group_chat_model.dart';
import 'package:flutter_socket_io/pages/chat/chat_page.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<GroupChatModel> groups = [
      GroupChatModel(
          id: 1,
          avatarPath:
              'https://cdn.24h.com.vn/upload/2-2022/images/2022-04-27/anh-1-1651049189-186-width650height1054.jpg',
          name: 'Vợ thằng bạn',
          chat: 'Tối đi uống nước không e?',
          time: '12:00'),
      GroupChatModel(
          id: 2,
          avatarPath:
              'https://gamek.mediacdn.vn/133514250583805952/2021/9/17/photo-1-1631856680040545802895.jpg',
          name: 'Mãi yêu <3',
          chat: 'Chia tay nhé anh :))',
          time: '16:00'),
      GroupChatModel(
          id: 3,
          avatarPath:
              'https://scontent.fhan3-5.fna.fbcdn.net/v/t1.6435-9/47400432_257882211546064_3502088050798755840_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=B1yT8a57wywAX86Se5J&_nc_ht=scontent.fhan3-5.fna&oh=00_AT_je_PA3XFuPcADPEYlvbhs0poAJyCQecy-7SDSvxqpfg&oe=62B96488',
          name: 'Vợ nhà',
          chat: 'Về chăm con ngay !!',
          time: '09:00'),
    ];

    return Scaffold(
      body: SizedBox(
          width: double.infinity,
          child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.to(() => ChatPage(),
                        arguments: groups[index], transition: Transition.zoom);
                  },
                  child: Conversation(
                    groups: groups,
                    index: index,
                  ),
                );
              })),
    );
  }
}

class Conversation extends StatelessWidget {
  const Conversation({
    Key? key,
    required this.groups,
    required this.index,
  }) : super(key: key);

  final List<GroupChatModel> groups;
  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(groups[index].avatarPath),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${groups[index].name}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 2,
                  ),
                  Text('${groups[index].chat}\t ${groups[index].time}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
