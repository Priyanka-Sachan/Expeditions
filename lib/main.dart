import 'package:expeditions/HomePage.dart';
import 'package:expeditions/Providers/Places.dart';
import 'package:expeditions/UI/Screens/AddPlaceScreen.dart';
import 'package:expeditions/UI/Screens/AuthScreen.dart';
import 'package:expeditions/UI/Screens/ChatScreen.dart';
import 'package:expeditions/UI/Screens/PlaceDetailsScreen.dart';
import 'package:expeditions/UI/Screens/PlacesOverviewScreen.dart';
import 'package:expeditions/UI/Screens/ProfileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Places(),
      child: MaterialApp(
        title: 'Expeditions',
        theme: ThemeData(
            fontFamily: 'Raleway',
            backgroundColor: Color(0xfff5e6ca),
            appBarTheme: AppBarTheme(
                color: Colors.transparent,
                elevation: 0,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Dancing Script',
                  fontSize: 32,
                ),
                iconTheme: IconThemeData(color: Colors.black)),
            primarySwatch: MaterialColor(0xff343f56, {
              50: Color(0xff343f56),
              100: Color(0xff343f56),
              200: Color(0xff343f56),
              300: Color(0xff343f56),
              400: Color(0xff343f56),
              500: Color(0xff343f56),
              600: Color(0xff343f56),
              700: Color(0xff343f56),
              800: Color(0xff343f56),
              900: Color(0xff343f56),
            }),
            accentColor: Color(0xfff54748),
            iconTheme: IconThemeData(color: Color(0xff343f56))),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) return HomePage();
            return AuthScreen();
          },
        ),
        // initialRoute: PlacesOverviewScreen.id,
        routes: {
          AuthScreen.id: (ctx) => AuthScreen(),
          HomePage.id: (ctx) => HomePage(),
          PlacesOverviewScreen.id: (ctx) => PlacesOverviewScreen(),
          AddPlaceScreen.id: (ctx) => AddPlaceScreen(),
          PlaceDetailsScreen.id: (ctx) => PlaceDetailsScreen(),
          ChatScreen.id: (ctx) => ChatScreen(),
          ProfileScreen.id: (ctx) => ProfileScreen()
        },
      ),
    );
  }
}
