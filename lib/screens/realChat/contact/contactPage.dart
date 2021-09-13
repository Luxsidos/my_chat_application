import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactPage extends StatelessWidget {
  ContactPage({Key? key}) : super(key: key);
  var groups = ["Dastur haqida", "Dart | Flutter Uzbekistan", "Coding Nerds"];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            onTap: () {
              Navigator.of(context).pushNamed("/info/$index");
            },
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade600,
              child: Icon(CupertinoIcons.person_3_fill),
            ),
            title: Text(
              groups[index],
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text("Group"),
           
          ),
        );
      },
      itemCount: groups.length,
      physics: BouncingScrollPhysics(),
    );
  }
}
