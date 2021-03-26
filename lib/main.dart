import 'package:flutter/material.dart';
import 'inherited_widget/note_inherited_widget.dart';
import 'package:smartnote/screens/note_llist.dart';
import 'screens/homescreen.dart';
import 'screens/note.dart';
import 'model/style.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main(){
  /*WidgetsFlutterBinding.ensureInitialized();

  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/app_icon');
  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (id, title, body, payload) async {});
  var initializationSettings = InitializationSettings(
    initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
    if (payload != null){
      debugPrint('notification payload: ' + payload);
    }
  });*/
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoteInheritedWidget(
        MaterialApp(
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              textTheme: TextTheme(title: AppBarTextStyle),
              color: Color(0xff3B3A50),
            ),
            textTheme: TextTheme(
              title: TitleTextStyle,
              body1: TextTextStyle,
              body2: DateStyle,
            )
          ),
        debugShowCheckedModeBanner: false,
        title: 'Smart Note',
        home: HomeScreen(),
        routes: {
          NoteList.routeName: (ctx) => NoteList(),
          
        }
      ),
    );
  }
}



