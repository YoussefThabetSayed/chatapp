import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholarchat/constans.dart';
import 'package:scholarchat/helper/show_snak_bar.dart';
import 'package:scholarchat/pages/chat_screen.dart';
import 'package:scholarchat/pages/cubits/auth_cubit/auth_cubit.dart';
import 'package:scholarchat/widgets/custom_button.dart';
import 'package:scholarchat/widgets/custom_text_field.dart';

class RegisterPage extends StatelessWidget {
  String? email;

  String? password;

  bool isLoading = false;
  static String id = 'registerPage';

  GlobalKey<FormState> formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is RegisterLoading) {
          isLoading = true;
        } else if (state is RegisterSuccess) {
          Navigator.pushNamed(context,ChatScreen.id);
        } else if (state is RegisterFailure) {
          showSnakBar(context, state.errorMessage);
          isLoading = false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
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
                          'REGISTER',
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
                          BlocProvider.of<AuthCubit>(context)
                              .registerUser(email: email!, password: password!);
                        } else {}
                      },
                      text: 'REGISTER',
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'you have an account?',
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            '  SIGNUP',
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
        );
      },
    );
  }

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
