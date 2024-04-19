import 'cmsConfigue.dart';

class CommonAlert {
  static void show_loading_alert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog dismissal on outside tap
      builder: (BuildContext context) {
        return  AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16.0),
              Text(AppLocalizations.of(context)!.pleaseWait),
            ],
          ),
        );
      },
    );
  }
  static void showAlertAndNavigateToLogin(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(AppLocalizations.of(context)!.pleaseLogin),
          content:  Text(AppLocalizations.of(context)!.needLogin),
          actions: <Widget>[
            TextButton(
              child:  Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:  Text(AppLocalizations.of(context)!.login),
              onPressed: () {
                // Navigate to the login screen
                Navigator.of(context).pop(); // Close the alert
                Navigator.pushReplacementNamed(context, RouteConstants.login);
              },
            ),
          ],
        );
      },
    );
  }
}