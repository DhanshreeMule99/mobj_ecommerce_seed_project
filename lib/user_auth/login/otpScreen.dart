// otpScreen

import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen(this.id, {super.key});

  final String id;

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final intRegex = RegExp(r'\d+', multiLine: true);

  @override
  void initState() {
    super.initState();
  }

  final otpText = TextEditingController();
  bool isLoading = false;
  bool isLoadingForSend = false;
  final formKey = GlobalKey<FormState>();
  String error = "";

  verifyOTP() async {
    setState(() {
      isLoading = true;
    });
    final body = {"otp": otpText.text, "id": widget.id};

    final login = LoginRepository();
    login.verifyOTP(body).then((value) async {
      if (value.runtimeType != String) {
        setState(() {
          error = "";
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: value["message"].toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 0,
            backgroundColor: AppColors.green,
            textColor: AppColors.whiteColor,
            fontSize: 16.0);
        DeviceRepository().deviceInfo(value['data']["_id"]);

        await SharedPreferenceManager()
            .setToken(value['data']["token"].toString());
        await SharedPreferenceManager()
            .setUserId(value['data']['_id'].toString());
        Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const HomeScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
            (route) => route.isCurrent);
      } else if (value == "2") {
        setState(() {
          error = AppString.userNotFound;
          isLoading = false;
        });
      } else if (value == "3") {
        setState(() {
          error = AppString.checkInternet;
          isLoading = false;
        });
      } else if (value == "4") {
        setState(() {
          error = AppString.invalidOtp;
          isLoading = false;
        });
      } else {
        setState(() {
          error = value;
          isLoading = false;
        });
      }
      // if (widget.logout == null) {
      //   Navigator.of(context).push(PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) =>
      //         Login_volunteer_otp_screen(
      //           mob_or_email: mob_or_email,
      //           mob_or_email_value: mob_or_email_value,
      //         ),
      //     transitionDuration: Duration.zero,
      //     reverseTransitionDuration: Duration.zero,
      //   ));
      // } else {
      //   Navigator.of(context).push(PageRouteBuilder(
      //     pageBuilder: (context, animation1, animation2) =>
      //         Login_volunteer_otp_screen(
      //             mob_or_email: mob_or_email,
      //             mob_or_email_value: mob_or_email_value,
      //             logout: widget.logout),
      //     transitionDuration: Duration.zero,
      //     reverseTransitionDuration: Duration.zero,
      //   ));
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return appInfoAsyncValue.when(
      data: (appInfo) => Scaffold(
          appBar: AppBar(
            elevation: 2,
            title: Text(appInfo.appName,
                style: const TextStyle(
                    )),
          ),
          // backgroundColor: Colors.white,
          body: SafeArea(
            top: true,
            child: SingleChildScrollView(
                child: Form(
                    key: formKey, //key for form
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Text(
                                AppString.verificationCode,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                    fontWeight: FontWeight.bold),
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 15, bottom: 15, right: 15),
                              child: Text(
                                AppString.otpInfo,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                textAlign: TextAlign.center,
                              )),
                          // mob_or_email != "both"
                          //     ? Padding(
                          //     padding: EdgeInsets.only(top: 15, bottom: 0),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: [
                          //         Text(
                          //              mob_or_email_value + " ",
                          //             color: appInfo.primaryColorValue,
                          //             fontsize:
                          //             MediaQuery.of(context).size.width *
                          //                 0.05,
                          //             textAlign: TextAlign.center,
                          //             fontweight: FontWeight.bold),
                          //         InkWell(
                          //           child:
                          //           CircleAvatar(child: Icon(Icons.edit)),
                          //           onTap: () {
                          //             Navigator.pop(context);
                          //           },
                          //         )
                          //       ],
                          //     ))
                          //     : Container(),
                          Padding(
                              padding:
                                  const EdgeInsets.only(top: 15, left: 0, bottom: 25),
                              child: Center(
                                  child: Consumer(builder: (context, watch, _) {
                                return PinCodeTextField(
                                  animationCurve: Curves.linear,
                                  animationType: AnimationType.none,
                                  appContext: context,
                                  pastedTextStyle: const TextStyle(
                                    color: AppColors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  length: 6,
                                  obscureText: true,
                                  obscuringCharacter: '*',
                                  blinkWhenObscuring: false,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  pinTheme: PinTheme(
                                      fieldOuterPadding: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      borderWidth: 2,
                                      shape: PinCodeFieldShape.box,
                                      borderRadius: BorderRadius.circular(5),
                                      inactiveColor: appInfo.primaryColorValue,
                                      selectedColor: appInfo.primaryColorValue,
                                      selectedFillColor: AppColors.whiteColor,
                                      activeColor: appInfo.primaryColorValue,
                                      inactiveFillColor: AppColors.whiteColor,
                                      activeFillColor:
                                          appInfo.primaryColorValue,
                                      // Set the desired background color
                                      errorBorderColor: AppColors.red),
                                  enableActiveFill: true,
                                  controller: otpText,
                                  keyboardType: TextInputType.number,
                                  onCompleted: (v) {},
                                  onChanged: (value) async {
                                    if (value.length == 6 &&
                                        value == DefaultValues.defaultOTP) {
                                      //TODO list API integration
                                      // verifyOTP();
                                      //Static value authentication
                                      Fluttertoast.showToast(
                                          msg: AppString.login,
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 0,
                                          backgroundColor: AppColors.green,
                                          textColor: AppColors.whiteColor,
                                          fontSize: 16.0);

                                      await SharedPreferenceManager()
                                          .setToken(DefaultValues.defaultToken);
                                      await SharedPreferenceManager()
                                          .setUserId("1");
                                      Navigator.of(context).pushAndRemoveUntil(
                                          PageRouteBuilder(
                                            pageBuilder: (context, animation1,
                                                    animation2) =>
                                                const HomeScreen(),
                                            transitionDuration: Duration.zero,
                                            reverseTransitionDuration:
                                                Duration.zero,
                                          ),
                                          (route) => route.isCurrent);
                                      setState(() {
                                        error = "";
                                      });
                                    } else {
                                      setState(() {
                                        error = AppString.validOTP;
                                      });
                                    }
                                  },
                                  beforeTextPaste: (text) {
                                    return true;
                                  },
                                );
                              }))),
                          error != ""
                              ? Text(
                                  error,
                                  style: const TextStyle(
                                    color: AppColors.red,
                                  ),
                                )
                              : Container(),
                          TextButton(
                            child: isLoadingForSend == false
                                ? Text(
                                    AppString.resendOTP,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                    ),
                                  )
                                : CircularProgressIndicator(
                                    color: appInfo.primaryColorValue,
                                  ),
                            onPressed: () {
                              otpText.text = "";
                            },
                          ),
                          Padding(
                              padding: const EdgeInsets.all(15),
                              child: Consumer(builder: (context, watch, _) {
                                return ElevatedButton(
                                    onPressed: () async {
                                      if (isLoading == false) {
                                        if (formKey.currentState!.validate()) {
                                          if (otpText.text.length == 6 &&
                                              isLoading == false &&
                                              otpText.text ==
                                                  DefaultValues.defaultOTP) {
                                            // verifyOTP();
                                            //TODO list API integration
                                            // verifyOTP();
                                            //Static value authentication
                                            Fluttertoast.showToast(
                                                msg: AppString.login,
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 0,
                                                backgroundColor:
                                                    AppColors.green,
                                                textColor: AppColors.whiteColor,
                                                fontSize: 16.0);

                                            await SharedPreferenceManager()
                                                .setToken(
                                                    DefaultValues.defaultToken);
                                            await SharedPreferenceManager()
                                                .setUserId("1");
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation1,
                                                              animation2) =>
                                                          const HomeScreen(),
                                                      transitionDuration:
                                                          Duration.zero,
                                                      reverseTransitionDuration:
                                                          Duration.zero,
                                                    ),
                                                    (route) => route.isCurrent);
                                            setState(() {
                                              error = "";
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            error = AppString.validOTP;
                                          });
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          appInfo.primaryColorValue,
                                      minimumSize: const Size.fromHeight(50),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              AppDimension.buttonRadius)),
                                      textStyle: const TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: 10,
                                          fontStyle: FontStyle.normal),
                                    ),
                                    child: isLoading == false
                                        ? Text(
                                            AppString.submit,
                                            style: TextStyle(
                                                color: AppColors.whiteColor,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontWeight: FontWeight.bold),
                                          )
                                        : const CircularProgressIndicator(
                                            color: AppColors.whiteColor,
                                          ));
                              }))
                        ]))),
          )),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => const SizedBox(),
    );
  }
}
