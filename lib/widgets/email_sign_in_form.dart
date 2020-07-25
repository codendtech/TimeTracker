import 'package:TimeTracker/services/authentication.dart';
import 'package:TimeTracker/widgets/platform_alert_dialog.dart';
import 'package:TimeTracker/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:TimeTracker/widgets/platform_exception_alert_dialog.dart';

class EmailSignInForm extends StatefulWidget {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

enum EmailSignInFormType { signIn, register }

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  EmailSignInFormType _formType = EmailSignInFormType.signIn;
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void _submit(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    setState(() {
      _isLoading = true;
    });
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await auth.registerUserWithEmail(_email, _password);
      }
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in Failed',
        exception: e,
      ).show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleEmailSignInForm() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    String primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign In'
        : 'Create an Account';

    String secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Already have an account? Sign In';

    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'email@email.com',
              enabled: _isLoading ? false : true,
            ),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            focusNode: _emailFocusNode,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_passwordFocusNode),
            onChanged: (email) => _updateState(),
          ), // email
          SizedBox(height: 8.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              enabled: _isLoading ? false : true,
            ),
            obscureText: true,
            textInputAction: TextInputAction.done,
            focusNode: _passwordFocusNode,
            onEditingComplete: () => _submit(context),
            onChanged: (password) => _updateState(),
          ),
          SizedBox(height: 12.0),
          FormSubmitButton(
            onPressed: () =>
                _isLoading == false && _email.isNotEmpty && _password.isNotEmpty
                    ? _submit(context)
                    : null,
            text: primaryText,
            backGroundColor: Colors.indigo,
            textColor: Colors.white,
            borderRadius: 48.0,
            height: 45.0,
            fontSize: 18.0,
          ),
          SizedBox(height: 10.0),
          Visibility(
            maintainAnimation: true,
            maintainSize: false,
            maintainState: true,
            visible: _isLoading ? true : false,
            child: Center(child: CircularProgressIndicator()),
          ),
          SizedBox(height: 10.0),
          FlatButton(
            child: Text(secondaryText),
            onPressed: _toggleEmailSignInForm,
          )
        ],
      ),
    );
  }

  void _updateState() {
    setState(() {});
  }
}
