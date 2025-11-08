abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email, password;
  LoginRequested(this.email, this.password);
}

class SignupRequested extends AuthEvent {
  final String email, password;
  SignupRequested(this.email, this.password);
}
