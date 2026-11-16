import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholarchat/constans.dart';
import 'package:scholarchat/helper/show_snak_bar.dart';
import 'package:scholarchat/pages/blocs/auth_bloc/auth_bloc.dart';
import 'package:scholarchat/pages/chat_screen.dart';
import 'package:scholarchat/pages/register_page.dart';
import 'package:scholarchat/widgets/custom_button.dart';
import 'package:scholarchat/widgets/custom_text_field.dart';

class LoginPage extends StatelessWidget {
  bool isLoading = false;
  static String id = 'loginPage';

  GlobalKey<FormState> formkey = GlobalKey();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          Navigator.pushNamed(context, ChatScreen.id, arguments: email);
          isLoading = false;
        } else if (state is LoginFailure) {
          showSnakBar(context, state.errorMessage);
          isLoading = false;
        }
      },
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Scaffold(
          backgroundColor: kPrimaryColor,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Form(
              key: formkey,
              child: ListView(
                children: [
                  const SizedBox(
                    height: 60,
                  ),
                  Image.asset(
                    iconImage,
                    height: 100,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Scholar Chat',
                        style: TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontFamily: 'pacifico'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 110,
                  ),
                  const Row(
                    children: [
                      Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 26, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomFormTextField(
                    onChange: (data) {
                      email = data;
                    },
                    hintText: 'Email',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomFormTextField(
                    obscureText: true,
                    onChange: (data) {
                      password = data;
                    },
                    hintText: 'Password',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomButton(
                    onTap: () async {
                      if (formkey.currentState!.validate()) {
                        BlocProvider.of<AuthBloc>(context).add(LodingEvent(email: email!, password: password!));
                      } else {}
                    },
                    text: 'LOGIN',
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'don\'t have an account?',
                        style:
                            TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: const Text(
                          '  REGISTER',
                          style: TextStyle(
                            color: Color(0xffC7EDE6),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
