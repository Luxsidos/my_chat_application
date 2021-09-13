import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class KirishPage extends StatefulWidget {
  const KirishPage({Key? key}) : super(key: key);

  @override
  _KirishPageState createState() => _KirishPageState();
}

class _KirishPageState extends State<KirishPage> with TickerProviderStateMixin {
  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if (isExitWarning) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Press back again to exit")));

          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                    image: AssetImage("assets/images/picture.jpg"),
                    fit: BoxFit.cover)),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: Container(), flex: 1),
                ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 4.0, sigmaX: 4.0),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(width: 2.0, color: Colors.white),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        "Welcome to chat!",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 32.0,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 4.0, sigmaX: 4.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "sign_in_page");
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  "SIGN IN",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      width: 2.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: ClipRRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaY: 4.0, sigmaX: 4.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, "sign_up_page");
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: Colors.white.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      width: 2.0, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  flex: 4,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
