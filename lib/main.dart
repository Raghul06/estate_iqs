import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'core/navigation/app_router.dart';
import 'injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBKjMGiD4nFkxoeLstaBgLlnrNT-Xx_P-E",
        appId: "1:623137483053:android:9679983f7a57201ce7cba4",
        messagingSenderId: "623137483053",
        projectId: "fade-and-blade")
  );
  // Initialize dependency injection.
  await initInjectionContainer();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FlutterSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'EstateIQ',
          theme: ThemeData(
            primaryColor: const Color(0xFF1F4E79),
            scaffoldBackgroundColor: Colors.white,
            textTheme: const TextTheme(
              displayLarge: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              bodyLarge: TextStyle(fontFamily: 'Roboto'),
            ),
          ),
          // GoRouter handles all the navigation; SplashScreen is the initial route.
          routerConfig: appRouter,
        );
      }
    );
  }
}
