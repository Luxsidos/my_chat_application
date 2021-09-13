import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const kContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const kMessageSendTextFieldStyle = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
    hintText: "Type message...",
    border: InputBorder.none);

const kChapTomon = BorderRadius.only(
  topRight: Radius.circular(32.0),
  bottomLeft: Radius.circular(32.0),
  bottomRight: Radius.circular(32.0),
);

const kOngTomon = BorderRadius.only(
  topLeft: Radius.circular(32.0),
  bottomLeft: Radius.circular(32.0),
  bottomRight: Radius.circular(32.0),
);
