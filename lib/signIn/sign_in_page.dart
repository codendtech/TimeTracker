import 'file:///C:/Users/91999/AndroidStudioProjects/TimeTracker/lib/services/sign_in_manager.dart';
import 'file:///C:/Users/91999/AndroidStudioProjects/TimeTracker/lib/signIn/email_sign_in_page.dart';
import 'package:TimeTracker/services/authentication.dart';
import 'package:TimeTracker/signIn/sign_in_button.dart';
import 'package:TimeTracker/widgets/platform_exception_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  SignInPage({
    @required this.signInManager,
    @required this.isLoading,
  });
  final SignInManager signInManager;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (context, signInManager, _) => SignInPage(
              signInManager: signInManager,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  void _showError(BuildContext context, PlatformException e) {
    PlatformExceptionAlertDialog(
      title: 'Sign in Failed',
      exception: e,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await signInManager.signInAnonimously();
    } on PlatformException catch (e) {
      _showError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await signInManager.signInWithGoogle();
    } on PlatformException catch (e) {
      _showError(context, e);
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await signInManager.signInWithFacebook();
    } on PlatformException catch (e) {
      _showError(context, e);
    }
  }

  void _goToEmailSignIn(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EmailSignIn(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Tracker'),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    return Builder(
      builder: (context) => Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sign In',
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.0),
            SignInButton(
              image: Icon(
                Icons.send,
                color: Colors.white,
              ),
              height: 50.0,
              text: 'Sign In with Google',
              borderRadius: 48,
              backGroundColor: Colors.red[800],
              fontSize: 18.0,
              textColor: Colors.white,
              onPressed: () =>
                  isLoading != true ? _signInWithGoogle(context) : null,
            ),
            SizedBox(height: 8.0),
            SignInButton(
              height: 50.0,
              image: Image.asset('images/facebook-logo.png'),
              text: 'Sign In with Facebook',
              borderRadius: 48.0,
              backGroundColor: Color(0xFF334D92),
              fontSize: 18.0,
              textColor: Colors.white,
              onPressed: () =>
                  isLoading != true ? _signInWithFacebook(context) : null,
            ),
            SizedBox(height: 8.0),
            SignInButton(
              image: Icon(
                Icons.email,
                color: Colors.white,
                size: 35.0,
              ),
              height: 50.0,
              text: 'Sign In with Email',
              borderRadius: 48.0,
              backGroundColor: Colors.green[900],
              fontSize: 18.0,
              textColor: Colors.white,
              onPressed: () =>
                  isLoading != true ? _goToEmailSignIn(context) : null,
            ),
            SizedBox(height: 20.0),
            Text(
              'or',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            SignInButton(
              image: Icon(
                Icons.face,
                color: Colors.white,
                size: 35.0,
              ),
              height: 50.0,
              text: 'Anonymous Login',
              borderRadius: 48.0,
              backGroundColor: Colors.deepOrangeAccent,
              fontSize: 18.0,
              textColor: Colors.white,
              onPressed: () =>
                  isLoading != true ? _signInAnonymously(context) : null,
            ),
            SizedBox(height: 20.0),
            Visibility(
              maintainAnimation: true,
              maintainSize: false,
              maintainState: true,
              visible: isLoading ? true : false,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
