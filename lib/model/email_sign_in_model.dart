import 'package:TimeTracker/services/authentication.dart';
import 'package:flutter/widgets.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInModel with ChangeNotifier {
  EmailSignInModel({
    @required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailSignInFormType.signIn,
    this.isLoading = false,
    this.isValidate = false,
    this.emailError,
    this.passwordError,
  });
  AuthBase auth;
  String email;
  String password;
  EmailSignInFormType formType;
  bool isLoading;
  bool isValidate;
  String emailError;
  String passwordError;

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool isValidate,
    String emailError,
    String passwordError,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.isValidate = isValidate ?? this.isValidate;
    this.emailError = emailError ?? this.emailError;
    this.passwordError = passwordError ?? this.passwordError;
    notifyListeners();
  }

  Future<void> submit() async {
    updateWith(isLoading: true);
    try {
      if (this.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(this.email, this.password);
      } else {
        await auth.registerUserWithEmail(this.email, this.password);
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void validator() {
    this.emailError = null;
    this.passwordError = null;
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    if (this.email.isEmpty) {
      updateWith(isValidate: false);
      this.emailError = 'Email Cannot be empty';
    } else if (!regex.hasMatch(this.email)) {
      updateWith(isValidate: false);
      this.emailError = 'Not a valid email';
    } else if (this.email.length == 0) {
      updateWith(isValidate: false);
      this.emailError = 'Email is required';
    } else if (this.password.isEmpty) {
      updateWith(isValidate: false);
      this.passwordError = 'Password needed';
    } else if (this.password.length < 4) {
      updateWith(isValidate: false);
      this.passwordError = 'Password must be minimum 4 characters';
      updateWith(isValidate: false);
    } else {
      updateWith(isValidate: true);
    }
  }

  void updateEmail(String email) {
    updateWith(email: email);
    validator();
  }

  void updatePassword(String password) {
    updateWith(password: password);
    validator();
  }

  void toggleSignInForm() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      isLoading: false,
      formType: formType,
    );
  }

  String primaryButtonText() {
    String primaryText = formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an Account';
    return primaryText;
  }

  String secondaryButtonText() {
    String secondaryText = formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Already have an account? Sign In';
    return secondaryText;
  }
}
