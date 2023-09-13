import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:a4s/MainPage/main_page.dart';
import 'package:a4s/data/view/user_view_model.dart';
import 'package:a4s/firebase_options.dart';
import 'package:a4s/Login/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
    child: AlarmForSleep(),
  ));
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
        home: autoLogin == true ? const MainPage() : LoginPage());
  }
}
