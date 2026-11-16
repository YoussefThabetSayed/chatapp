import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholarchat/pages/blocs/auth_bloc/auth_bloc.dart';
import 'package:scholarchat/pages/chat_screen.dart';
import 'package:scholarchat/pages/cubits/auth_cubit/auth_cubit.dart';
import 'package:scholarchat/pages/cubits/chat_cubit/chat_cubit.dart';
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
        // BlocProvider(
        //   create: (context) => LoginCubit(),
        // ),
        // BlocProvider(
        //   create: (context) => RegisterCubit(),
        // ),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(
          create: (context) => ChatCubit()..getMessages(),
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
