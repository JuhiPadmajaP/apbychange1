import 'package:apby/main.dart';
import 'package:apby/widgets/chat/messages.dart';
import 'package:apby/widgets/chat/new_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Initialize FlutterFire
      appBar: AppBar(title: Text('Sanity media Chat'), actions: [
        /*RaisedButton(
          textColor: Colors.white,
          color: Colors.blue,
          child: Text('Go to SubPage'),
          onPressed: () {
            navigateToSubPage(context);
          },*/

        DropdownButton(
          icon: Icon(Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color),
          items: [
            DropdownMenuItem(
              child: Container(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text('Logout')
                  ],
                ),
              ),
              value: 'logout',
            )
          ],
          onChanged: (itemIdentifier) {
            if (itemIdentifier == 'logout') {
              FirebaseAuth.instance.signOut();
            }
          },
        ),
      ]),

      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
            RaisedButton(
              textColor: Colors.white,
              color: Colors.blue,
              child: Text('Go to HomePage'),
              onPressed: () {
                navigateToSubPage(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

Future navigateToSubPage(context) async {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => MyHomePage()));
}
