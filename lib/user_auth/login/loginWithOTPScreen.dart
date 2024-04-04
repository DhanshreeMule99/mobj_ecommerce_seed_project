// LoginWithOTPScreen

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

class LoginWithOTP extends ConsumerStatefulWidget {
  const LoginWithOTP({super.key});

  @override
  ConsumerState<LoginWithOTP> createState() => _LoginWithOTPState();
}

final str = StateProvider((ref) => 0);

class _LoginWithOTPState extends ConsumerState<LoginWithOTP> {
  int? _currentSelection = 0;
  final formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final mobNo = TextEditingController();
  String error = "";
  bool isLoading = false;

//TODO list
  sendOTP() async {
    setState(() {
      isLoading = true;
    });
    final body = _currentSelection == 0
        ? {
            "email": email.text,
            "isOtp": true,
          }
        : {
            "phone": mobNo.text,
            "isOtp": true,
          };
    final sendOTP = LoginRepository();
    sendOTP.signIn(body).then((value) async {
      if (value.runtimeType != String) {
        setState(() {
          error = "";
          isLoading = false;
        });
        Fluttertoast.showToast(
            msg: value["otp"].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 0,
            backgroundColor: Colors.green.shade400,
            textColor: Colors.white,
            fontSize: 16.0);
        //If Login with OTP uncomment this code
        Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                OtpScreen(value["id"].toString())));
        //And comment below code
        // DeviceRepository().deviceInfo(value['data']["_id"]);
        //
        // await SharedPreferenceManager().settoken(
        //     value['data']["token"].toString());
        // await SharedPreferenceManager().setuserid(
        //     value['data']['_id'].toString());
        // Navigator.of(context).pushAndRemoveUntil(
        //     PageRouteBuilder(
        //       pageBuilder: (context, animation1, animation2) =>
        //       const HomeScreen(),
        //       transitionDuration: Duration.zero,
        //       reverseTransitionDuration: Duration.zero,
        //     ),
        //         (route) => route.isCurrent);
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
          error = AppString.userNotRegister;
          isLoading = false;
        });
      } else {
        setState(() {
          error = value;
          isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return appInfoAsyncValue.when(
        data: (appInfo) => Scaffold(
            body: SafeArea(
                top: true,
                child: SingleChildScrollView(
                  child: Form(
                      key: formKey, //key for form
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 0),
                                child: Text(
                                  AppString.login,
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.06,
                                      fontWeight: FontWeight.w600),
                                )),
                            const Divider(
                              thickness: 1.5,
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 25, left: 0, bottom: 0),
                                child: Text(
                                  '${AppString.welcome} ${appInfo.appName}',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.07,
                                      fontWeight: FontWeight.w600),
                                )),
                            Container(
                                child: SizedBox(
                              height: 200,
                              width: 200,
                              child: CachedNetworkImage(
                                imageUrl: appInfo.logoImagePath,
                                placeholder: (context, url) => Container(
                                  width: MediaQuery.of(context).size.width,
                                  color: AppColors.greyShade200,
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, left: 0, bottom: 25),
                                child: Center(
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: MaterialSegmentedControl(
                                            selectionIndex: _currentSelection,
                                            borderColor: AppColors.grey,
                                            selectedColor:
                                                appInfo.primaryColorValue,
                                            unselectedColor:
                                                AppColors.whiteColor,
                                            selectedTextStyle: const TextStyle(
                                                color: AppColors.whiteColor),
                                            unselectedTextStyle:
                                                const TextStyle(
                                                    color: AppColors.red),
                                            borderWidth: 0.7,
                                            borderRadius:
                                                AppDimension.buttonRadius,
                                            disabledChildren: _disabledIndices,
                                            verticalOffset: 8.0,
                                            onSegmentTapped: (index) {
                                              setState(() {
                                                error = "";
                                                _currentSelection = index;
                                              });
                                            },
                                            children: {
                                              0: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    AppString.email,
                                                    style: TextStyle(
                                                        color:
                                                            _currentSelection ==
                                                                    0
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                              1: Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Text(
                                                    AppString.mobileNo,
                                                    style: TextStyle(
                                                        color:
                                                            _currentSelection ==
                                                                    1
                                                                ? AppColors
                                                                    .whiteColor
                                                                : AppColors
                                                                    .blackColor,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )),
                                            })))),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 35, left: 15, right: 15, bottom: 20),
                                child: _currentSelection == 1
                                    ? IntlPhoneField(
                                        // validator: ,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(10),
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        controller: mobNo,
                                        focusNode: _focusNode,
                                        initialCountryCode: "IN",
                                        disableLengthCheck: false,
                                        decoration: InputDecoration(
                                          label: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(AppString.mobileNo),
                                              Text(
                                                '*',
                                                style: TextStyle(
                                                    color: AppColors.red,
                                                    fontSize: 20),
                                              )
                                            ],
                                          ),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(
                                                          AppDimension
                                                              .buttonRadius)),
                                              borderSide: BorderSide(
                                                color:
                                                    appInfo.primaryColorValue,
                                                width: 3,
                                              )),
                                          //normal border
                                          enabledBorder: OutlineInputBorder(
                                              //Outline border type for TextFeild
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(
                                                          AppDimension
                                                              .buttonRadius)),
                                              borderSide: BorderSide(
                                                color:
                                                    appInfo.primaryColorValue,
                                                width: 1.5,
                                              )),
                                          focusedBorder: OutlineInputBorder(
                                              //Outline border type for TextFeild
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(
                                                          AppDimension
                                                              .buttonRadius)),
                                              borderSide: BorderSide(
                                                  color:
                                                      appInfo.primaryColorValue,
                                                  width: 1.5)),
                                          suffixIcon: const Icon(Icons.check),
                                        ),
                                        onChanged: (phone) {
                                          if (phone.number.length == 10) {
                                            _focusNode
                                                .unfocus(); // this will remove the keyboard
                                          }
                                        },
                                        onCountryChanged: (country) {},
                                      )
                                    : TextFormField(
                                        controller: email,
                                        validator: (value) {
                                          return Validation()
                                              .emailValidation(value);
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            label: const Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(AppString.email),
                                                Text(
                                                  '*',
                                                  style: TextStyle(
                                                      color: AppColors.red,
                                                      fontSize: 20),
                                                )
                                              ],
                                            ),
                                            border: OutlineInputBorder(
                                                //Outline border type for TextFeild
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(AppDimension
                                                        .buttonRadius)),
                                                borderSide: BorderSide(
                                                  color:
                                                      appInfo.primaryColorValue,
                                                  width: 1.5,
                                                )),
                                            //normal border
                                            enabledBorder: OutlineInputBorder(
                                                //Outline border type for TextFeild
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(AppDimension
                                                            .buttonRadius)),
                                                borderSide: BorderSide(
                                                  color:
                                                      appInfo.primaryColorValue,
                                                  width: 1.5,
                                                )),
                                            focusedBorder: OutlineInputBorder(
                                                //Outline border type for TextFeild
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(
                                                            AppDimension
                                                                .buttonRadius)),
                                                borderSide: BorderSide(
                                                    color: appInfo.primaryColorValue,
                                                    width: 1.5))),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      )),
                            error != ""
                                ? Center(
                                    child: Text(
                                    error,
                                    style: TextStyle(color: AppColors.red),
                                  ))
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                              child: Consumer(
                                builder: (context, watch, _) {
                                  return ElevatedButton(
                                      onPressed: () {
                                        if (isLoading == false) {
                                          if (formKey.currentState!
                                              .validate()) {
                                            //Static value authentication
                                            if (mobNo.text ==
                                                    DefaultValues.defaultMob ||
                                                email.text ==
                                                    DefaultValues
                                                        .defaultEmail) {
                                              setState(() {
                                                error = "";
                                                isLoading = false;
                                              });
                                              Fluttertoast.showToast(
                                                  msg: AppString.otpInfo,
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 0,
                                                  backgroundColor:
                                                      AppColors.green,
                                                  textColor:
                                                      AppColors.whiteColor,
                                                  fontSize: 16.0);
                                              //If Login with OTP uncomment this code
                                              Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                      pageBuilder: (context,
                                                              animation1,
                                                              animation2) =>
                                                          const OtpScreen(
                                                              DefaultValues
                                                                  .defaultOTP)));
                                            } else {
                                              setState(() {
                                                error = AppString.userNotFound;
                                                isLoading = false;
                                              });
                                            }
                                            //TODO list API integration
                                            // sendOTP();
                                          }
                                        } else {}
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: appInfo.primaryColorValue,
                                        minimumSize: Size.fromHeight(50),
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
                                              AppString.login,
                                              style: TextStyle(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.05,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const CircularProgressIndicator(
                                              color: AppColors.whiteColor,
                                            ));
                                },
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(AppString.doesNotHaveAcc),
                                TextButton(
                                  child: Text(
                                    AppString.signUp,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: appInfo.primaryColorValue),
                                  ),
                                  onPressed: () {
                                    //signup screen
                                    Navigator.of(context).push(PageRouteBuilder(
                                        pageBuilder: (context, animation1,
                                                animation2) =>
                                            RegistrationScreen(isOtp: true)));
                                  },
                                )
                              ],
                            ),
                          ])),
                ))),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const SizedBox());
  }

  final List<int> _disabledIndices = [];
}
