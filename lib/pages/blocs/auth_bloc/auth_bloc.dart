import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event is LodingEvent) {
        emit(LoginLoading());
        try {
          UserCredential user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: event.email, password: event.password);
          emit(LoginSuccess());
        } on FirebaseAuthException catch (e) {
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
      if (event is RegisterEvent) {
        emit(RegisterLoading());
         emit(RegisterLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: event.email, password: event.password);
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(errorMessage: 'Weak password'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errorMessage: 'Email already exists'));
      } else if (e.code == 'invalid-email') {
        emit(RegisterFailure(errorMessage: 'Invalid email format'));
      } else {
        emit(RegisterFailure(errorMessage: 'Something went wrong: ${e.code}'));
      }
    } catch (e) {
      emit(RegisterFailure(errorMessage: 'Something went wrong'));
    }
      }
    });
  }
}
