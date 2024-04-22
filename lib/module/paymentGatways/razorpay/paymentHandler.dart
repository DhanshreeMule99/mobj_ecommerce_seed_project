import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

class PaymentHandler {
  final Razorpay _razorpay;
  final BuildContext context;
  final WidgetRef ref;
  PaymentHandler(this._razorpay, this.context, this.ref);

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    CommonAlert.show_loading_alert(context);
    Fluttertoast.showToast(
        msg: "${AppString.successPayment}: ${response.paymentId}",
        timeInSecForIosWeb: 4);
    var checkout;

    checkout = await ProductRepository().checkout(response.paymentId!);

    if (checkout == AppString.success) {
      Navigator.pop(context);

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const SuccessScreen(AppString.success),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
      ref.refresh(cartDetailsDataProvider);
      ref.refresh(orderDataProvider);
    } else {
      Fluttertoast.showToast(msg: AppString.error, timeInSecForIosWeb: 4);
      // Navigate to the error screen
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            const SuccessScreen(AppString.error),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ));
    }
  }
  // Navigate to the success screen

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "${AppString.error}: ${response.code} - ${response.message}",
        timeInSecForIosWeb: 4);
    // Navigate to the error screen
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) =>
          const SuccessScreen(AppString.error),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  void handleExternalWallet(ExternalWalletResponse response) {}

  void openPaymentPortal(
      String name, String contact, String email, double amount) {
    double amountInPaise = amount * 100;
    print('amount is this $amountInPaise $amount');
    var options = {
      'key': AppConfigure.razorPayId,
      'amount': amountInPaise.toStringAsFixed(2),
      'name': name,
      'description': DefaultValues.defaultPaymentDescription,
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (error) {
      rethrow;
    }
  }
}
