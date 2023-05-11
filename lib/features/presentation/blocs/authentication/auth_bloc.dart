import 'package:cinema_app/features/data/datasources/api_client.dart';
import 'package:cinema_app/features/data/datasources/storage.dart';
import 'package:cinema_app/features/presentation/blocs/authentication/auth_event.dart';
import 'package:cinema_app/features/presentation/blocs/authentication/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiClient apiClient;
  String? phoneNumber;
  String? otp;

  AuthBloc({required this.apiClient}) : super(const AuthInitial()) {
    on<AuthEvent>((event, emit) async {
      if (event == AuthEvent.checkForStoredToken) {
        final storedToken = await Storage.getAccessToken();
        if (storedToken != null) {
          final response = await apiClient.checkToken(storedToken);
          if(response == true){
            emit(AuthAuthenticated(accessToken: storedToken));
          }
        }
      } else if (event == AuthEvent.sendOTP) {
        emit(const AuthSendingOTP());
        try {
          await apiClient.sendOTP(phoneNumber!);
          emit(const AuthOTPReceived());
        } catch (e) {
          emit(AuthPhoneNumberError(e.toString()));
        }
      } else if (event == AuthEvent.authenticate) {
        emit(const AuthAuthenticating());
        try {
          final response = await apiClient.authenticate(phoneNumber!, otp!);
          final accessToken = response.data['data']['accessToken'];
          await Storage.setAccessToken(accessToken);
          emit(AuthAuthenticated(accessToken: accessToken));

          final currentUser = await apiClient.getCurrentUser(accessToken);
        } catch (e) {
          emit(AuthOTPError(e.toString()));
        }
      } else if (event == AuthEvent.done) {
        emit(const AuthInitial());
      }
      else if (event == AuthEvent.logOut) {
        await Storage.removeAccessToken();
        emit(const AuthInitial());
      }
    });
  }
}
