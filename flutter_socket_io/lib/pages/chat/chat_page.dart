import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_socket_io/models/chat_model.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  List chats = [];

  @override
  void initState() {
    socket = IO.io("http://192.168.0.133:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });
    socket.connect();
    // socket.emit("signin", widget.sourchat.id);
    socket.onConnect((data) {
      print("Connected");
      socket.on("message", (msg) {
        print("msg1 ${msg}");
        setState(() {
          chats.add(ChatModel(message: msg['message'], user: msg['user']));
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(chats);
    // data người chat
    var data = Get.arguments;
    TextEditingController controller = TextEditingController();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black12.withOpacity(0.1),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.keyboard_arrow_left),
              color: Colors.deepPurpleAccent),
          title: Row(
            children: [
              /// avatar
              Container(
                width: 40,
                height: 40,
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
                    backgroundImage: NetworkImage(data.avatarPath),
                  ),
                ),
              ),

              SizedBox(
                width: 10,
              ),

              /// info state
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${data.name}',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 2,
                    ),
                    Text('Đang hoạt động',
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
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              /// chats
              Expanded(
                  child: ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        if (chats[index].source) {
                          return SizedBox(
                              width: double.infinity,
                              child: ScrollChats(
                                  msg: chats[index].message,
                                  user: chats[index].user));
                        } else {
                          return SizedBox(
                              width: double.infinity,
                              child: ScrollChats(
                                  msg: chats[index].message,
                                  user: chats[index].user));
                        }
                      })),

              /// input chat
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(width: 1, color: Colors.black38),
                    borderRadius: BorderRadius.circular(40)),
                child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Aa',
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none),
                    controller: controller,
                    onSubmitted: (value) {
                      // setState(() {
                      //   chats.add(ChatModel(
                      //       message: value, user: false, source: true));
                      // });
                      socket.emit("message", {"message": value});
                    }),
              ),
              SizedBox(height: 10),
            ],
          ),
        ));
  }
}

/// đoạn hội thoại
class ScrollChats extends StatelessWidget {
  const ScrollChats({
    Key? key,
    required this.user,
    required this.msg,
  }) : super(key: key);

  final bool user;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment:
          user ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Container(
            margin: EdgeInsets.only(
                right: user ? 100 : 10,
                left: user ? 10 : 100,
                top: 5,
                bottom: 5),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: user ? Colors.black12 : Colors.deepPurpleAccent),
            child: Text(msg,
                style: TextStyle(color: user ? Colors.black : Colors.white))),
      ],
    );
  }
}
