
import 'package:dars61/screens/chats/chats.dart';
import 'package:dars61/screens/kirishPage.dart';
import 'package:dars61/screens/realChat/contact/contactPage.dart';
import 'package:dars61/screens/realChat/message/messagePage.dart';
import 'package:dars61/screens/singIn.dart';
import 'package:dars61/screens/singUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseAuth _authUser = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat',
      theme: ThemeData(
        brightness: Brightness.light,
        textTheme: GoogleFonts.comfortaaTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute:
          _authUser.currentUser != null ? 'persons_page' : 'kirish_page',
      routes: {
        "kirish_page": (context) => KirishPage(),
        "sign_in_page": (context) => SignIn(),
        "sign_up_page": (context) => SignUp(),
        "contact_page": (context) => ContactPage(),
        "persons_page": (context) => Chats(),
      },
      onGenerateRoute: (settings) {
        List<String> lst1 = settings.name.toString().split('/');
        if (lst1[1] == 'info') {
          return MaterialPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (context) => MessagePage(
              int.parse(lst1[2]),
            ),
          );
        }
      },
    );
  }
}
