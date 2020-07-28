import 'package:TimeTracker/widgets/platform_alert_dialog.dart';
import 'package:meta/meta.dart';
import 'package:flutter/services.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  final String title;
  final PlatformException exception;
  PlatformExceptionAlertDialog({@required this.title, @required this.exception})
      : super(
          title: title,
          content: _message(exception),
          defaultActionText: 'OK',
        );

  static String _message(PlatformException exception) {
    if (exception.code == 'PERMISSION_DENIED') {
      return exception.message;
    }
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    "ERROR_INVALID_EMAIL":
        "Invalid email address. Please use correct email ID.",
    "ERROR_WRONG_PASSWORD":
        "Password is incorrect. Please enter the correct password.",
    "ERROR_USER_NOT_FOUND":
        "There is no user found with the corresponding email address.",
    "ERROR_USER_DISABLED":
        "This user account has been disabled by the administrator. Please contact the admin.",
    "ERROR_WEAK_PASSWORD":
        "Weak password. Please use complex password for more safety",
    "ERROR_EMAIL_ALREADY_IN_USE":
        "This email address is already been registered with another account.",
  };
}
