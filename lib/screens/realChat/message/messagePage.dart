import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars61/constants/chatPageConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _authUser = FirebaseAuth.instance;

class MessagePage extends StatefulWidget {
  int currentIndex;
  MessagePage(this.currentIndex, {Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  TextEditingController _messageController = TextEditingController();
  String? groupName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var groups = [
      "Dastur haqida",
      "Dart | Flutter Uzbekistan",
      "Coding Nerds"
    ];

    if (widget.currentIndex == 0) {
      groupName = "Dastur haqida";
    } else if (widget.currentIndex == 1) {
      groupName = "Dart | Flutter Uzbekistan";
    } else if (widget.currentIndex == 2) {
      groupName = "Coding Nerds";
    } else {
      groupName = "Group";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        toolbarHeight: 80.0,
        backgroundColor: Colors.white,
        elevation: 24.0,
        shadowColor: Colors.black12,
        leading: CupertinoButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.back,
            color: Colors.blue.shade600,
            size: 32.0,
          ),
        ),
        centerTitle: true,
        title: Text(
          groupName!.toString(),
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chat${widget.currentIndex + 1}')
                    .orderBy('uploadTime')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                  final chats = snapshot.data!.docs.reversed;
                  List<BubbleChat> listChat = [];
                  for (var chat in chats) {
                    String message = chat['message'];
                    String email = chat['email'];
                    String time = chat['time'];
                    final bubbleChat = BubbleChat(
                        message, email, _authUser.currentUser!.email, time);
                    listChat.add(bubbleChat);
                  }
                  if (listChat.isEmpty) {
                    return Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Chat is empty",
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    );
                  }
                  return Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      padding: EdgeInsets.all(12.0),
                      itemBuilder: (context, index) {
                        return listChat[index];
                      },
                      itemCount: listChat.length,
                    ),
                  );
                }),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(24.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, -2),
                      spreadRadius: 0.0,
                      blurRadius: 18.0,
                      color: Colors.black.withOpacity(0.01),
                    )
                  ]),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _messageController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.2),
                              ),
                              borderRadius: BorderRadius.circular(32.0)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.blue.shade600, width: 2.0),
                              borderRadius: BorderRadius.circular(32.0)),
                          hintText: "Type your message",
                          hintStyle: TextStyle(color: Colors.black26)),
                    ),
                  ),
                  CupertinoButton(
                    child: Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void sendMessage() async {
    if (_messageController.text != '') {
      await _firestore.collection("chat${widget.currentIndex + 1}").add(
        {
          "message": _messageController.text,
          "email": _authUser.currentUser!.email,
          "uploadTime": DateTime.now(),
          "time": DateTime.now().hour.toString() +
              ":" +
              DateTime.now().minute.toString(),
        },
      );
      _messageController.clear();
    }
  }
}

class BubbleChat extends StatelessWidget {
  String message;
  String email;
  var userEmail;
  String time;
  BubbleChat(this.message, this.email, this.userEmail, this.time);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Align(
            alignment: userEmail != email
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Text(
              "$email",
              style: GoogleFonts.comfortaa(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 4.0),
          Align(
            alignment: userEmail != email
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius: userEmail != email ? kChapTomon : kOngTomon,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade600,
                    Colors.blue.shade900,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: userEmail != email
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: [
                  Text(
                    "$message",
                    style: GoogleFonts.comfortaa(
                        textStyle: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                  Text(
                    time.toString(),
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
