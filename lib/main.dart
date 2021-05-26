import 'dart:math';
import 'package:apby/screens/auth_screen.dart';
import 'package:apby/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:apby/commons/const.dart';
import 'package:apby/userProfile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'commons/utils.dart';
import 'controllers/FBCloudMessaging.dart';
import 'threadMain.dart';
//new
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();
    return FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, appSnapshot) {
          return MaterialApp(
            title: 'FlutterChat',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              backgroundColor: Colors.deepPurpleAccent,
              accentColor: Colors.pink,
              accentColorBrightness: Brightness.dark,
              buttonTheme: ButtonTheme.of(context).copyWith(
                  buttonColor: Colors.deepPurpleAccent,
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, userSnapshot) {
                  if (userSnapshot.hasData) {
                    return ChatScreen();
                  }
                  return AuthScreen();
                }),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  TabController _tabController;
  MyProfileData myData;

  bool _isLoading = false;

  @override
  void initState() {
    FBCloudMessaging.instance.takeFCMTokenWhenAppLaunch();
    FBCloudMessaging.instance.initLocalNotification();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    _takeMyData();
    super.initState();
  }

  Future<void> _takeMyData() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String myThumbnail;
    String myName;
    if (prefs.get('myThumbnail') == null) {
      String tempThumbnail = iconImageList[Random().nextInt(50)];
      prefs.setString('myThumbnail', tempThumbnail);
      myThumbnail = tempThumbnail;
    } else {
      myThumbnail = prefs.get('myThumbnail');
    }

    if (prefs.get('myName') == null) {
      String tempName = Utils.getRandomString(8);
      prefs.setString('myName', tempName);
      myName = tempName;
    } else {
      myName = prefs.get('myName');
    }

    setState(() {
      myData = MyProfileData(
        myThumbnail: myThumbnail,
        myName: myName,
        myLikeList: prefs.getStringList('likeList'),
        myLikeCommnetList: prefs.getStringList('likeCommnetList'),
        myFCMToken: prefs.getString('FCMToken'),
      );
    });

    setState(() {
      _isLoading = false;
    });
  }

  void _handleTabSelection() => setState(() {});

  void onTabTapped(int index) {
    setState(() {
      _tabController.index = index;
    });
  }

  void updateMyData(MyProfileData newMyData) {
    setState(() {
      myData = newMyData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter !'), centerTitle: true, actions: [
        RaisedButton(
          textColor: Colors.white,
          color: Colors.purpleAccent,
          child: Text('Back to Main Page'),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ]),
      body: Stack(children: <Widget>[
        TabBarView(controller: _tabController, children: [
          ThreadMain(
            myData: myData,
            updateMyData: updateMyData,
          ),
          UserProfile(
            myData: myData,
            updateMyData: updateMyData,
          ),
        ]),
        Utils.loadingCircle(_isLoading),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _tabController.index,
        selectedItemColor: Colors.amber[900],
        unselectedItemColor: Colors.grey[800],
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.people),
            title: new Text('Thread'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle),
            title: new Text('Profile'),
          ),
        ],
      ),
    );
  }
}
