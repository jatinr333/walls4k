// @dart=2.9
import 'package:custom_splash/custom_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'screens/categorylist.dart';
import 'screens/walls.dart';

import 'screens/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Map<int, Widget> op = {1: MyHomePage(), 2: MyHomePage()};
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: "4k Wallpapers",
      themeMode: ThemeMode.dark,
      theme: NeumorphicThemeData(
        baseColor: Colors.white70,
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Colors.blueGrey.shade800,
        lightSource: LightSource.topLeft,
        depth: 9,
      ),
      home: CustomSplash(
        imagePath: 'assets/splash.png',
        backGroundColor: Colors.black,
        animationEffect: 'fade-in',
        logoSize: 900.0,
        home: MyHomePage(),
        //customFunction: Wall.fetchwalls(),
        duration: 2000,
        type: CustomSplashType.StaticDuration,
        outputAndHome: op,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    configOneSignel();

    var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
    double gap = 10;
    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.lightGreenAccent,
      iconColor: Colors.white,
      textColor: Colors.white,
      backgroundColor: Colors.lightGreenAccent.withOpacity(.2),
      iconSize: 24,
      padding: padding,
      icon: Icons.verified_user,
      text: "Editor's Choice",
    ));

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.red,
      iconColor: Colors.white,
      textColor: Colors.white,
      backgroundColor: Colors.redAccent.withOpacity(.2),
      iconSize: 24,
      padding: padding,
      icon: Icons.category,
      text: 'Category',
    ));
  }

  int _selectedIndex = 0;
  PageController controller = PageController();
  List<GButton> tabs = [];

  void configOneSignel() {
    print("hello one signal");
    OneSignal.shared.init('874f7a59-b129-4b88-85db-8072e08d18a0');
    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: Text("4K Wallpapers"),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            color: Colors.white,
            iconSize: 30.5,
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Setting()));
              //currentTheme.toggleTheme();
            },
          )
        ],
        centerTitle: true,
      ),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: PageView.builder(
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
        controller: controller,
        itemBuilder: (BuildContext context, int index) {
          return getScreen(index);
        },
        itemCount: tabs.length,
      ),
      bottomNavigationBar: SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: -10,
                        blurRadius: 60,
                        color: Colors.black.withOpacity(.20),
                        offset: Offset(0, 15))
                  ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                child: GNav(
                    tabs: tabs,
                    selectedIndex: _selectedIndex,
                    onTabChange: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      controller.jumpToPage(index);
                    }),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 19, vertical: 5),
              child: FloatingActionButton(
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.format_paint_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  NeumorphicTheme.of(context).themeMode =
                      NeumorphicTheme.isUsingDark(context)
                          ? ThemeMode.light
                          : ThemeMode.dark;
                },
                elevation: 3.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _iconsColor(BuildContext context) {
    final theme = NeumorphicTheme.of(context);
    if (theme.isUsingDark) {
      return theme.current.accentColor;
    } else {
      return null;
    }
  }

  getScreen(int selectedIndex) {
    if (selectedIndex == 0) {
      return Wall();
    } else if (selectedIndex == 1) {
      return CategoryList();
    }
  }

  Color _textColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.white;
    }
  }
}
