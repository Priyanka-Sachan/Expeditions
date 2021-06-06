import 'package:expeditions/Providers/Places.dart';
import 'package:expeditions/UI/Screens/AddPlaceScreen.dart';
import 'package:expeditions/UI/Screens/PlacesOverviewScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Places(),
      child: MaterialApp(
        title: 'Flutter Demo',
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
              50:  Color(0xff343f56),
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
            iconTheme: IconThemeData(color: Colors.black)),
        home: PlacesOverviewScreen(),
        // initialRoute: PlacesOverviewScreen.id,
        routes: {
          PlacesOverviewScreen.id: (ctx) => PlacesOverviewScreen(),
          AddPlaceScreen.id: (ctx) => AddPlaceScreen()
        },
      ),
    );
  }
}
