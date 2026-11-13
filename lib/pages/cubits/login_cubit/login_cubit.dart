import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:scholarchat/helper/show_snak_bar.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(
      {required String email, required String password}) async {
    emit(LoginLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSuccess());
    }on FirebaseAuthException catch (e) {
  if (e.code == 'user-not-found') {
    emit(LoginFailure(errorMessage: 'User not found'));
  } else if (e.code == 'wrong-password') {
    emit(LoginFailure(errorMessage: 'Wrong password'));
  } else if (e.code == 'invalid-credential') {
    emit(LoginFailure(errorMessage: 'Invalid email or password'));
  } else {
    emit(LoginFailure(errorMessage: 'Something went wrong: ${e.code}'));
  }
} catch (e) {
  emit(LoginFailure(errorMessage: 'Something went wrong'));
}
  }
}
