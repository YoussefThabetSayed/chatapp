import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholarchat/pages/chat_screen.dart';
import 'package:scholarchat/pages/cubits/login_cubit/login_cubit.dart';
import 'package:scholarchat/pages/cubits/register_cubit/register_cubit.dart';
import 'package:scholarchat/pages/login_page.dart';
import 'package:scholarchat/pages/register_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => RegisterCubit(),
        ),
      ],
      child: MaterialApp(
        routes: {
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          ChatScreen.id: (context) => ChatScreen(),
        },
        debugShowCheckedModeBanner: false,
        initialRoute: LoginPage.id,
      ),
    );
  }
}
