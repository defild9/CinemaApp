abstract class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthSendingOTP extends AuthState {
  const AuthSendingOTP();
}

class AuthOTPReceived extends AuthState {
  const AuthOTPReceived();
}

class AuthAuthenticating extends AuthState {
  const AuthAuthenticating();
}

class AuthAuthenticated extends AuthState {
  final String accessToken;

  const AuthAuthenticated({required this.accessToken});
}

class AuthError extends AuthState {
  final String error;

  const AuthError(this.error);
}
class AuthPhoneNumberError extends AuthState {
  final String error;

  const AuthPhoneNumberError(this.error);
}

class AuthOTPError extends AuthState {
  final String error;

  const AuthOTPError(this.error);
}