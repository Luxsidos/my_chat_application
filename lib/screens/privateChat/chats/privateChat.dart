import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars61/constants/chatPageConstant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;
FirebaseAuth _authUser = FirebaseAuth.instance;

class PrivateChat extends StatefulWidget {
  int currentIndex;
  QueryDocumentSnapshot otherUser;
  String chatId;
  String? tag;
  DocumentSnapshot myData;

  PrivateChat({
    this.tag,
    required this.myData,
    required this.chatId,
    required this.currentIndex,
    required this.otherUser,
    Key? key,
  }) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<PrivateChat> {
  TextEditingController _messageController = TextEditingController();
  var _formKey = GlobalKey<FormFieldState>();

  dbGet() async {
    if (widget.tag == 'new') {
      await _firestore.collection('users').doc(widget.otherUser.id).set({
        "chat_id_array": FieldValue.arrayUnion([widget.chatId])
      }, SetOptions(merge: true));
      await _firestore.collection('users').doc(widget.myData.id).set({
        "chat_id_array": FieldValue.arrayUnion([widget.chatId])
      }, SetOptions(merge: true));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbGet();
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
          widget.otherUser['email'],
          style: GoogleFonts.comfortaa(
              textStyle:
                  TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        ),
        actions: [
          CupertinoButton(
            onPressed: () {
              showMore();
            },
            child: Icon(
              Icons.more_horiz,
              color: Colors.blue.shade600,
              size: 32.0,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('date')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                          color: Colors.blue.shade500),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Expanded(
                    child: Container(
                      child: Text(
                        "Has error!",
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  );
                }
                final chats = snapshot.data!.docs.reversed;
                List<BubbleChat> lstMessages = [];
                var idChats = [];
                for (QueryDocumentSnapshot chat in chats) {
                  idChats.add(chat.id);
                  String from_user_id = chat['from_user_id'];
                  String message = chat['message'];
                  String time = chat['time'];
                  lstMessages.add(BubbleChat(
                    fromUserId: from_user_id,
                    message: message,
                    myAccount: widget.myData,
                    otherAccount: widget.otherUser,
                    time: time,
                  ));
                }
                if (lstMessages.isEmpty) {
                  return Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "Chat is empty",
                        style: TextStyle(
                          fontSize: 24.0,
                          color: Colors.blue.shade500,
                        ),
                      ),
                    ),
                  );
                }
                return Expanded(
                  child: Container(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      reverse: true,
                      itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          ochir(idChats[index]);
                        },
                        child: lstMessages[index],
                      ),
                      itemCount: lstMessages.length,
                    ),
                  ),
                );
              },
            ),
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
                      key: _formKey,
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
                    onPressed: () {
                      sendMessage();
                      _messageController.clear();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  showMore() async {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          backgroundColor: Colors.blue.shade900,
          contentPadding: EdgeInsets.all(16.0),
          title: Text(
            "Do you want to delete all chats?",
            style: GoogleFonts.comfortaa(
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)),
              padding: EdgeInsets.all(8.0),
              child: Text(
                widget.otherUser['email'],
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                    color: Colors.blue.shade900,
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                  ),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Waiting...")));
                QuerySnapshot messages = await _firestore
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .get();
                for (var message in messages.docs) {
                  await _firestore
                      .collection('chats')
                      .doc(widget.chatId)
                      .collection('messages')
                      .doc(message.id)
                      .delete();
                }
                Navigator.pop(context);
              },
              child: Text(
                "ALL MESSAGE DELETE",
                style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(fontWeight: FontWeight.w800)),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            )
          ],
        );
      },
    );
  }

  ochir(idChat) async {
    DocumentSnapshot chat = await _firestore
        .doc("chats/${widget.chatId}/")
        .collection('messages')
        .doc(idChat)
        .get();
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          backgroundColor: Colors.blue.shade900,
          contentPadding: EdgeInsets.all(16.0),
          title: Text(
            "Do you want to delete this chat?",
            style: GoogleFonts.comfortaa(
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0)),
              padding: EdgeInsets.all(8.0),
              child: Text(
                chat['message'],
                style: GoogleFonts.comfortaa(
                  textStyle: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.w800,
                      fontSize: 16.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _firestore
                    .collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .doc(idChat)
                    .delete();
              },
              child: Text(
                "DELETE",
                style: GoogleFonts.comfortaa(
                    textStyle: TextStyle(fontWeight: FontWeight.w800)),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            )
          ],
        );
      },
    );
  }

  void sendMessage() async {
    if (_messageController.text != '') {
      await _firestore
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        "from_user_id": widget.otherUser.id,
        "message": _messageController.text,
        'date': FieldValue.serverTimestamp(),
        "time": DateTime.now().hour.toString() +
            ":" +
            DateTime.now().minute.toString(),
      });
    }
  }
}

class BubbleChat extends StatelessWidget {
  String fromUserId;
  String message;
  DocumentSnapshot myAccount;
  DocumentSnapshot otherAccount;
  String time;
  BubbleChat({
    required this.time,
    required this.fromUserId,
    required this.message,
    required this.myAccount,
    required this.otherAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Align(
            alignment: fromUserId == myAccount.id
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Text(
              fromUserId != myAccount.id
                  ? "${myAccount['email']}"
                  : "${otherAccount['email']}",
              style: GoogleFonts.comfortaa(
                textStyle:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ),
          SizedBox(height: 4.0),
          Align(
            alignment: fromUserId == myAccount.id
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                borderRadius:
                    fromUserId == myAccount.id ? kChapTomon : kOngTomon,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade600,
                    Colors.blue.shade900,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: fromUserId == myAccount.id
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
