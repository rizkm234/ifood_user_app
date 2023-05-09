import 'package:firebase_core/firebase_core.dart';
import 'package:ifood_user_app/assistant%20methods/address_changer.dart';
import 'package:ifood_user_app/assistant%20methods/cart_item_counter.dart';
import 'package:ifood_user_app/assistant%20methods/total_amount.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Splash Screen/splash_screen.dart';
import 'global/global.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (c)=> CartItemCounter()),
        ChangeNotifierProvider(create: (c)=> TotalAmount()),
        ChangeNotifierProvider(create: (c)=> AddressChanger()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'User App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:  MySplashScreen(),
      ),
    );
  }
}

