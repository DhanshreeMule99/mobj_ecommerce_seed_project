import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

import '../../../utils/cmsConfigue.dart';

class PhonePePaymentHandler {
  String transactionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool enableLogging = true;
  String checksum = "";
  String body = "";
  Object? result;
  final BuildContext context;
  final WidgetRef ref;
  final int amount;
  final String mobile;
  PhonePePaymentHandler(this.context, this.ref,this.amount,this.mobile) {
    phonepeInit();
    body = getChecksum(amount,mobile).toString();
  }

  String getChecksum(int amount,String mobileNumber) {
    final requestData = {
      "merchantId": AppConfigure.merchantId,
      "merchantTransactionId": transactionId,
      "merchantUserId": "90223250",//static for test
      "amount": amount,
      "mobileNumber": mobileNumber,
      "callbackUrl": AppConfigure.callbackUrl,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    String base64Body = base64.encode(utf8.encode(json.encode(requestData)));

    checksum =
        '${sha256.convert(utf8.encode(base64Body + AppConfigure.apiEndPoint + AppConfigure.saltKey)).toString()}###${AppConfigure.saltIndex}';

    return base64Body;
  }

  void phonepeInit() {
    PhonePePaymentSdk.init(AppConfigure.environment, AppConfigure.appId,
            AppConfigure.merchantId, enableLogging)
        .then((val) => {
              result = 'PhonePe SDK Initialized - $val',
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void startPgTransaction(
      Function(Map<String, dynamic>) onTransactionComplete) async {

    try {
      var response = PhonePePaymentSdk.startPGTransaction(body,
          AppConfigure.callbackUrl, checksum, {}, AppConfigure.apiEndPoint, "");
      response.then((val) async {
        if (val != null) {
          String status = val['status'].toString();
          String error = val['error'].toString();

          if (status == 'SUCCESS') {
            result = "Flow complete - status : SUCCESS";
            CommonAlert.show_loading_alert(context);
            await checkStatus(onTransactionComplete);
          } else {
            CommonAlert.show_loading_alert(context);
            handleError(error);
          }
        } else {
          CommonAlert.show_loading_alert(context);
          handleError(AppString.error);
        }
      }).catchError((error) {
        handleError(error);
        onTransactionComplete(<String, dynamic>{});
        return <dynamic>{};
      });
    } catch (error) {
      CommonAlert.show_loading_alert(context);
      handleError(error);
      onTransactionComplete(<String, dynamic>{});
    }
  }

  void handleError(error) {
    Navigator.pop(context);
    Fluttertoast.showToast(
        msg: "${AppString.error}: ${AppString.oops}", timeInSecForIosWeb: 4);
    // Navigate to the error screen
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) =>
          const SuccessScreen(AppString.error),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ));
    result = {"error": error};
  }

  checkStatus(Function(Map<String, dynamic>) onStatusCheckComplete) async {
    try {
      String url =
          "https://api-preprod.phonepe.com/apis/pg-sandbox/pg/v1/status/${AppConfigure.merchantId}/$transactionId"; //Test

      String concatenatedString =
          "/pg/v1/status/${AppConfigure.merchantId}/$transactionId${AppConfigure.saltKey}";

      var bytes = utf8.encode(concatenatedString);
      var digest = sha256.convert(bytes);
      String hashedString = digest.toString();

      // combine with salt key
      String xVerify = "$hashedString###${AppConfigure.saltIndex}";

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "X-MERCHANT-ID": AppConfigure.merchantId,
        "X-VERIFY": xVerify,
      };

      await http.get(Uri.parse(url), headers: headers).then((value) async {
        Map<String, dynamic> res = jsonDecode(value.body);

        try {
          if (res["code"] == "PAYMENT_SUCCESS" &&
              res['data']['responseCode'] == "SUCCESS") {
            Fluttertoast.showToast(
                msg: "${AppString.successPayment}: ${res["message"]}",
                timeInSecForIosWeb: 4);

            final checkout = await ProductRepository().checkout("");
            Navigator.pop(context);

            if (checkout == AppString.success) {
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
              Fluttertoast.showToast(
                  msg: "${AppString.error}: ${AppString.oops}",
                  timeInSecForIosWeb: 4);
              // Navigate to the error screen
              Navigator.of(context).pushReplacement(PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const SuccessScreen(AppString.error),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ));
            }
          }
        } catch (e) {
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg: "${AppString.error}: ${AppString.oops}",
              timeInSecForIosWeb: 4);
          // Navigate to the error screen
          Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const SuccessScreen(AppString.error),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ));
        }

        onStatusCheckComplete(res);
      });
    } catch (e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: "${AppString.error}: ${AppString.oops}", timeInSecForIosWeb: 4);
      // Navigate to the error screen
      Navigator.of(context).pushReplacement(PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            const SuccessScreen(AppString.error),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ));
    }
  }
}
