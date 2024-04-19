
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:mobj_project/utils/cmsConfigue.dart';

class StripePaymentService {
  final BuildContext context;
  final WidgetRef ref;
  Map<String, dynamic>? paymentIntent;

  StripePaymentService({required this.context, required this.ref});

  void handlePaymentSuccess() async {
    CommonAlert.show_loading_alert(context);
    Fluttertoast.showToast(
        msg: "${AppString.successPayment}: ", timeInSecForIosWeb: 4);

    final checkout = await ProductRepository().checkout("asdfjdfgadfhsdf");
    debugPrint("checkout is this $checkout");
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

  void handlePaymentError() {
    Fluttertoast.showToast(msg: "${AppString.error}: ", timeInSecForIosWeb: 4);
    // Navigate to the error screen
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) =>
          const SuccessScreen(AppString.error),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
  }

  makepayment(String name, String contact, String email, double amount) async {
    try {
      //CommonAlert.show_loading_alert(context);
      print('1');
      paymentIntent = await createPaymentIntent(name, contact, email, amount);
      print('2');
      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "IN",
          currencyCode: "INR",
          testEnv: true,
          amount: "10000");
      print("3 ${paymentIntent!['client_secret']}");
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent!['client_secret'],
              style: ThemeMode.dark,
              googlePay: gpay,
              merchantDisplayName: 'Setoo'));
      print("4");
      displayPaymentSheet();
    } catch (e) {
      handlePaymentError();
      print(e.toString());
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        debugPrint("Payment Successfully $value");
        handlePaymentSuccess();
      });
      print('done');
    } catch (e) {
      debugPrint('failed to present payment sheet');
    }
  }

  Future createPaymentIntent(
      String name, String contact, String email, double amount) async {
    try {
      http.Response response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'Authorization':
                'Bearer sk_test_51OwL4aSJobhEaXflKoUl8huQFSfe6lyA4rwvKL55M8m7f91cHz0QyCbZFg3XmL1lqOSjbdUTPQPTqYCr7zHXdAHJ00CKddSw4r',
          },
          body: {
            'amount': "10000",
            'currency': 'INR',
          });
      print(response.statusCode);
      print(response.body);
      return json.decode(response.body);
    } catch (e) {
      print("error is this ${e.toString()}");
    }
  }
}
