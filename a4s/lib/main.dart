import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:a4s/MainPage/main_page.dart';
import 'package:a4s/data/view/user_view_model.dart';
import 'package:a4s/firebase_options.dart';
import 'package:a4s/Login/login.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:a4s/notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:a4s/model/alarm.dart';
import 'package:a4s/provider/alarm_list_provider.dart';
import 'package:a4s/provider/permission_provider.dart';
import 'package:a4s/service/alarm_file_handler.dart';
import 'package:a4s/service/alarm_polling_worker.dart';
import 'package:a4s/provider/alarm_state.dart';
import 'package:a4s/alarm/alarm_observer.dart';
import 'package:a4s/alarm/permission_request_screen.dart';
import 'package:provider/provider.dart' as provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AndroidAlarmManager.initialize();

  final AlarmState alarmState = AlarmState();
  final List<Alarm> alarms = await AlarmFileHandler().read() ?? [];
  final SharedPreferences preference = await SharedPreferences.getInstance();

  // 앱 진입시 알람 탐색을 시작해야 한다.
  AlarmPollingWorker().createPollingWorker(alarmState);

  runApp(ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.ChangeNotifierProvider(create: (context) => alarmState),
          provider.ChangeNotifierProvider(create: (context) => AlarmListProvider(alarms)),
          // ChangeNotifierProvider(
          //   create: (context) => PermissionProvider(preference),
          // ),
        ],
        child: const AlarmForSleep(),
          )
  ));


  // runApp(ProviderScope(
  //   child: AlarmForSleep(),
  // ));
}

class AlarmForSleep extends ConsumerWidget {
  const AlarmForSleep({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final autoLogin = ref.read(userViewModelProvider).autoSignIn();

    return GetMaterialApp(
        title: 'AlarmForSleep',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 255, 255, 255)),
          useMaterial3: true,
        ),
        home: autoLogin == true ? AlarmObserver(child: const MainPage()) : AlarmObserver(child: LoginPage())
    );
  }
}
