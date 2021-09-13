import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dars61/screens/privateChat/chats/privateChat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

FirebaseAuth _authUser = FirebaseAuth.instance;
FirebaseFirestore _firestore = FirebaseFirestore.instance;

bool _found = false;

class PersonsPage extends StatefulWidget {
  @override
  _PersonsPageState createState() => _PersonsPageState();
}

class _PersonsPageState extends State<PersonsPage> {
  DocumentSnapshot? men;

  getData() async {
    await _firestore.collection('users').doc(_authUser.currentUser!.uid).set({
      "email": _authUser.currentUser!.email,
      "chat_id_array": FieldValue.arrayUnion([]),
    }, SetOptions(merge: true));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection("users").snapshots(),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshots.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  onTap: () {
                    if (snapshots.data!.docs[index].id !=
                        _authUser.currentUser!.uid) {
                      _checkUser(
                        snapshots: snapshots,
                        index: index,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("This is you!"),
                        ),
                      );
                    }
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade600,
                    child: Icon(CupertinoIcons.person_fill),
                  ),
                  title: Text(
                    snapshots.data!.docs[index]['email'],
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text("Person"),
                ),
              );
            },
            itemCount: snapshots.data!.docs.length,
            physics: BouncingScrollPhysics(),
          );
        }
        return Center(
          child: Text(
            "Has error!!!",
            style: TextStyle(
              fontSize: 24.0,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }

  _checkUser({index, AsyncSnapshot<QuerySnapshot<Object?>>? snapshots}) async {
    men = await _firestore
        .collection('users')
        .doc(_authUser.currentUser!.uid)
        .get();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Waiting...")));
    for (String id in men!['chat_id_array']) {
      var doc = await _firestore.collection('chats').doc(id).get();
      if (snapshots!.data!.docs[index].id == doc['user_id_one'] ||
          snapshots.data!.docs[index].id == doc['user_id_two']) {
        _found = true;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PrivateChat(
              currentIndex: index,
              chatId: id,
              myData: men!,
              otherUser: snapshots.data!.docs[index],
            ),
          ),
        );
      }
    }

    print("OCHISH");

    if (!_found) {
      var newChat = await _firestore.collection('chats').add({
        "user_id_one": men!.id,
        "user_id_two": snapshots!.data!.docs[index].id,
      });
      print("IFNI ICHIGA KIRDI!!!");
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PrivateChat(
            currentIndex: index,
            myData: men!,
            chatId: newChat.id,
            otherUser: snapshots.data!.docs[index],
            tag: "new",
          ),
        ),
      );
    }
  }
}
