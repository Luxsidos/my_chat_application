import 'package:dars61/screens/privateChat/persons/persons.dart';
import 'package:dars61/screens/realChat/contact/contactPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:google_fonts/google_fonts.dart';

FirebaseAuth _authUser = FirebaseAuth.instance;

class Chats extends StatefulWidget {
  @override
  _PersonsPageState createState() => _PersonsPageState();
}

class _PersonsPageState extends State<Chats> with TickerProviderStateMixin {
  TabController? _tabBarConttroller;
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabBarConttroller = TabController(length: 2, vsync: this);
  }

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
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.0),
          ),
          backgroundColor: Colors.white,
          elevation: 24.0,
          shadowColor: Colors.black12,
          leading: CupertinoButton(
            onPressed: () {},
            child: Icon(
              CupertinoIcons.search,
              color: Colors.blue.shade600,
              size: 26.0,
            ),
          ),
          centerTitle: true,
          title: Text(
            "Messages",
            style: GoogleFonts.comfortaa(
              textStyle: TextStyle(
                  color: Colors.black87,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700),
            ),
          ),
          actions: [
            CupertinoButton(
              child: Icon(
                Icons.logout,
                color: Colors.blue.shade600,
                size: 26.0,
              ),
              onPressed: () async {
                await _authUser.signOut();
                Navigator.pushReplacementNamed(context, "kirish_page");
              },
            ),
          ],
          bottom: TabBar(
            controller: _tabBarConttroller,
            physics: BouncingScrollPhysics(),
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.black,
            labelStyle: GoogleFonts.comfortaa(
                textStyle: TextStyle(fontWeight: FontWeight.w800)),
            tabs: [Tab(text: "Persons"), Tab(text: "Groups")],
          ),
        ),
        body: OfflineBuilder(
          connectivityBuilder: (
            BuildContext context,
            ConnectivityResult connectivity,
            Widget child,
          ) {
            final bool connected = connectivity != ConnectivityResult.none;
            return Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  padding: EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                          color: connected
                              ? Colors.blue.shade600
                              : Color(0xFFEE4400),
                          width: 2.0)),
                  child: connected
                      ? Text(
                          "ONLINE",
                          style: TextStyle(
                              color: Colors.blue.shade600,
                              fontWeight: FontWeight.w800),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "OFFLINE",
                              style: TextStyle(
                                  color: Color(0xFFEE4400),
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(width: 8.0),
                            SizedBox(
                              width: 12.0,
                              height: 12.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            ),
                          ],
                        ),
                ),
                connected
                    ? Expanded(
                        child: TabBarView(
                          physics: BouncingScrollPhysics(),
                          controller: _tabBarConttroller,
                          children: [PersonsPage(), ContactPage()],
                        ),
                      )
                    : Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.warning,
                                color: Colors.red,
                                size: 56.0,
                              ),
                              SizedBox(height: 16.0),
                              Text(
                                "Just turn off your internet :(",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
              ],
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("Just turn off your internet")],
          ),
        ),
      ),
    );
  }
}

/*
TabBarView(
        physics: BouncingScrollPhysics(),
        controller: _tabBarConttroller,
        children: [PersonsPage(), ContactPage()],
      ),
*/
