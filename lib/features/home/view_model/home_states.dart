
abstract class HomeState {}

class HomeInitial extends HomeState {}

class AuthLoginLoading extends HomeState {}

class AuthLoginSuccess extends HomeState {}

class AuthLoginError extends HomeState {
  final String errorMessage;

  AuthLoginError({required this.errorMessage});
}

class AuthRegisterLoading extends HomeState {}

class AuthRegisterSuccess extends HomeState {}

class AuthRegisterError extends HomeState {
  final String errorMessage;

  AuthRegisterError({required this.errorMessage});
}

class GetCurrentAddressSuccess extends HomeState {}

class OTPLoading extends HomeState {}

class ClientNotExist extends HomeState {}

class ClientExist extends HomeState {}

class OTPSuccess extends HomeState {}

class OTPError extends HomeState {}

class CheckBoxState extends HomeState {}

class ChangeLanguageState extends HomeState {}



class CreateUserSuccessState extends HomeState {
  final uId;
  CreateUserSuccessState(this.uId);

}

class CreateUserErrorState extends HomeState {
  final String errorMessage;

  CreateUserErrorState(this.errorMessage);
}



class LoginLoadingState extends HomeState {}

class LoginSuccessState extends HomeState {

  LoginSuccessState();
}

class LoginErrorState extends HomeState {
  final error;

  LoginErrorState(this.error);
}

