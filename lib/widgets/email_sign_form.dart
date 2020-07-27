import 'package:TimeTracker/model/email_sign_in_model.dart';
import 'package:TimeTracker/services/authentication.dart';
import 'package:TimeTracker/widgets/form_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:TimeTracker/widgets/platform_exception_alert_dialog.dart';

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({@required this.model});
  final EmailSignInModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<EmailSignInModel>(
      create: (context) => EmailSignInModel(auth: auth),
      child: Consumer<EmailSignInModel>(
        builder: (context, model, _) => EmailSignInForm(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();

  EmailSignInModel get model => widget.model;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
  }

  void _submit(BuildContext context) async {
    model.validator();
    if (model.isValidate) {
      try {
        await model.submit();
        Navigator.of(context).pop();
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Sign in Failed',
          exception: e,
        ).show(context);
      }
    }
  }

  void _toggleEmailSignInForm() {
    model.toggleSignInForm();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
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
              enabled: model.isLoading ? false : true,
              errorText: model.emailError,
            ),
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            focusNode: _emailFocusNode,
            onEditingComplete: () =>
                FocusScope.of(context).requestFocus(_passwordFocusNode),
            onChanged: model.updateEmail,
          ), // email
          SizedBox(height: 8.0),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              enabled: model.isLoading ? false : true,
              errorText: model.passwordError,
            ),
            obscureText: true,
            textInputAction: TextInputAction.done,
            focusNode: _passwordFocusNode,
            onEditingComplete: () => _submit(context),
            onChanged: model.updatePassword,
          ),
          SizedBox(height: 12.0),
          FormSubmitButton(
            onPressed: () => _submit(context),
            text: model.primaryButtonText(),
            backGroundColor: Colors.indigo,
            textColor: Colors.white,
            borderRadius: 48.0,
            height: 45.0,
            fontSize: 18.0,
            disabledColor: Colors.grey,
          ),
          SizedBox(height: 10.0),
          Visibility(
            maintainAnimation: true,
            maintainSize: false,
            maintainState: true,
            visible: model.isLoading ? true : false,
            child: Center(child: CircularProgressIndicator()),
          ),
          SizedBox(height: 10.0),
          FlatButton(
            child: Text(model.secondaryButtonText()),
            onPressed: _toggleEmailSignInForm,
          )
        ],
      ),
    );
  }
}
