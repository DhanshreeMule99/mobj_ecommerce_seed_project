// registrationScreen

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobj_project/user_auth/login/loginScreen.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../../utils/api.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  final bool? isOtp;

  const RegistrationScreen({Key? key, this.isOtp}) : super(key: key);

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final mobNo = TextEditingController();
  final password = TextEditingController();
  final confirmPass = TextEditingController();

  final textFieldFocusNode = FocusNode();
  bool loadingSignup = false;

  String error = "";
  bool isLoading = false;
  bool _obscured = true;
  bool _confirmObscured = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final API api = API();

//ToDo list sign in with google
//   Future<void> _handleSignIn() async {
//     setState(() {
//       loadingSignup = true;
//     });
//     loadingSignup == true
//         ? showDialog<bool>(
//             context: context,
//             builder: (BuildContext context) {
//               return const AlertDialog(
//                   content: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(width: 20.0),
//                   Text(AppString.pleaseWait),
//                 ],
//               ));
//             },
//           )
//         : null;
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser != null) {
//         final GoogleSignInAuthentication googleAuth =
//             await googleUser.authentication;
//         final AuthCredential credential = GoogleAuthProvider.credential(
//           accessToken: googleAuth.accessToken,
//           idToken: googleAuth.idToken,
//         );
//         final UserCredential authResult =
//             await _auth.signInWithCredential(credential);
//         final User? user = authResult.user;
//
//         if (user != null) {
//           List<String> parts = user.displayName!.split(" ");
//
//           String fname = parts[0];
//           String lname = parts[1];
//           final body = {
//             "firstName": fname,
//             "lastName": lname,
//             "email": user.email,
//             "phone": user.phoneNumber ?? "",
//             "password": "",
//             "isSocialLogin": true,
//             "socialLoginType": AppString.google,
//             "token": googleAuth.idToken
//           };
//           final login = RegistrationRepository();
//           login.signIn(body).then((value) async {
//             Navigator.pop(context);
//
//             if (value.runtimeType != String) {
//               setState(() {
//                 error = "";
//                 loadingSignup = false;
//               });
//
//               Fluttertoast.showToast(
//                   msg: value["message"].toString(),
//                   toastLength: Toast.LENGTH_SHORT,
//                   gravity: ToastGravity.BOTTOM,
//                   timeInSecForIosWeb: 0,
//                   backgroundColor: AppColors.green,
//                   textColor: AppColors.whiteColor,
//                   fontSize: 16.0);
//               DeviceRepository().deviceInfo(value['data']["_id"]);
//
//               await SharedPreferenceManager()
//                   .setToken(value['data']["token"].toString());
//               await SharedPreferenceManager()
//                   .setUserId(value['data']['_id'].toString());
//               Navigator.of(context).pushAndRemoveUntil(
//                   PageRouteBuilder(
//                     pageBuilder: (context, animation1, animation2) =>
//                         const HomeScreen(),
//                     transitionDuration: Duration.zero,
//                     reverseTransitionDuration: Duration.zero,
//                   ),
//                   (route) => route.isCurrent);
//             } else if (value == "2") {
//               setState(() {
//                 error = AppString.userExists;
//                 loadingSignup = false;
//               });
//             } else if (value == "3") {
//               setState(() {
//                 error = AppString.checkInternet;
//                 loadingSignup = false;
//               });
//             } else if (value == "4") {
//               setState(() {
//                 error = AppString.correctData;
//                 loadingSignup = false;
//               });
//             } else {
//               setState(() {
//                 error = value;
//                 loadingSignup = false;
//               });
//             }
//             // if (widget.logout == null) {
//             //   Navigator.of(context).push(PageRouteBuilder(
//             //     pageBuilder: (context, animation1, animation2) =>
//             //         Login_volunteer_otp_screen(
//             //           mob_or_email: mob_or_email,
//             //           mob_or_email_value: mob_or_email_value,
//             //         ),
//             //     transitionDuration: Duration.zero,
//             //     reverseTransitionDuration: Duration.zero,
//             //   ));
//             // } else {
//             //   Navigator.of(context).push(PageRouteBuilder(
//             //     pageBuilder: (context, animation1, animation2) =>
//             //         Login_volunteer_otp_screen(
//             //             mob_or_email: mob_or_email,
//             //             mob_or_email_value: mob_or_email_value,
//             //             logout: widget.logout),
//             //     transitionDuration: Duration.zero,
//             //     reverseTransitionDuration: Duration.zero,
//             //   ));
//             // }
//           });
//         }
//       }
//     } catch (error) {
//       Navigator.pop(context);
//       setState(() {
//         loadingSignup = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("${AppString.googleSignupError} $error"),
//         ),
//       );
//     }
//   }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  void _toggleObscuredForConfirmPass() {
    setState(() {
      _confirmObscured = !_confirmObscured;
      if (textFieldFocusNode.hasPrimaryFocus) {
        return; // If focus is on text field, dont unfocus
      }
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  signIn() async {
    setState(() {
      loadingSignup = true;
    });

    debugPrint(
        "this is data ${widget.isOtp} \n ${email.text} \n ${firstName.text}\n${lastName.text} \n${mobNo.text},\n${password.text}");

    if (AppConfigure.bigCommerce == true) {
      //Signing wih bigCommerce
      final body = [
        {
          "email": email.text,
          "first_name": firstName.text,
          "last_name": lastName.text,
          "phone": mobNo.text,
          "authentication": {
            "force_password_reset": true,
            "new_password": password.text
          },
          "accepts_product_review_abandoned_cart_emails": true
        }
      ];

      try {
        final response = await api.sendRequest.post(
          '${AppConfigure.bigcommerceUrl}/customers',
          data: body,
          options: Options(headers: {
            "X-Auth-Token": AppConfigure.bigCommerceAccessToken,
            "Content-Type": "application/json",
          }),
        );

        debugPrint('status code is ${response.statusCode}');
        var data = response.data;
        if (response.statusCode == APIConstants.successCode ||
            response.statusCode == APIConstants.successCreateCode) {
          setState(() {
            loadingSignup = false;
          });
          // Handle successful registration here
          Fluttertoast.showToast(
              msg: "Registration successful",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 0,
              backgroundColor: AppColors.green,
              textColor: AppColors.whiteColor,
              fontSize: 16.0);
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const LoginScreen(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
          // Optionally, you can navigate to another screen or perform any additional action here
        } else if (response.statusCode == APIConstants.alreadyExistCode) {
          setState(() {
            loadingSignup = false;
          });
          Fluttertoast.showToast(
              msg: "User Already Exist",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 0,
              backgroundColor: AppColors.green,
              textColor: AppColors.whiteColor,
              fontSize: 16.0);
          //   Navigator.of(context).pushReplacement(
          //   PageRouteBuilder(
          //     pageBuilder: (context, animation1, animation2) =>
          //         const LoginScreen(),
          //     transitionDuration: Duration.zero,
          //     reverseTransitionDuration: Duration.zero,
          //   ),
          // );
        } else {
          setState(() {
            error = "Registration failed";
            loadingSignup = false;
          });
        }
      } on DioException catch (error) {
        if (error.response!.statusCode == APIConstants.alreadyExistCode) {
          Fluttertoast.showToast(
              msg: "${error.response!.data["errors"]}",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 0,
              backgroundColor: AppColors.green,
              textColor: AppColors.whiteColor,
              fontSize: 16.0);
        }
        debugPrint("error: $error");
        setState(() {
          loadingSignup = false;
        });
      }
    } else {
      // Perform login using existing login logic
      final body = widget.isOtp == true
          ? {
              "firstName": firstName.text,
              "lastName": lastName.text,
              "email": email.text,
              "phone": "+91${mobNo.text}",
              "password": password.text,
              "isOtp": widget.isOtp
            }
          : {
              "email": email.text,
              "password": password.text,
              "firstName": firstName.text,
              "lastName": lastName.text,
              "phone": "+91${mobNo.text}",
              'acceptsMarketing': true,
            };

      final login = RegistrationRepository();
      login.signIn(body).then((value) async {
        if (value.runtimeType != String) {
          setState(() {
            error = "";
            loadingSignup = false;
          });
          if (widget.isOtp == true) {
            Fluttertoast.showToast(
                msg: value["message"].toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 0,
                backgroundColor: AppColors.green,
                textColor: AppColors.whiteColor,
                fontSize: 16.0);
            //If Login with OTP uncomment this code
            Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    OtpScreen(value["data"]["_id"].toString())));
          } else {
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)!.registerSuccess,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 0,
                backgroundColor: AppColors.green,
                textColor: AppColors.whiteColor,
                fontSize: 16.0);
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const LoginScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          }
        } else if (value == "2") {
          setState(() {
            error = AppLocalizations.of(context)!.userExists;
            loadingSignup = false;
          });
        } else if (value == "3") {
          setState(() {
            error = AppLocalizations.of(context)!.checkInternet;
            loadingSignup = false;
          });
        } else if (value == "4") {
          setState(() {
            error = AppLocalizations.of(context)!.correctData;
            loadingSignup = false;
          });
        } else {
          setState(() {
            error = value;
            loadingSignup = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            top: true,
            child: SingleChildScrollView(
                child: Consumer(builder: (context, watch, child) {
              final appInfoAsyncValue = ref.watch(appInfoProvider);
              return appInfoAsyncValue.when(
                data: (appInfo) => Form(
                    key: formKey, //key for form
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 15, bottom: 10),
                              child: Text(
                                AppLocalizations.of(context)!.signUp,
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.06,
                                    fontWeight: FontWeight.bold),
                              )),
                          const Divider(
                            thickness: 1.5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 15, right: 5),
                                    child: TextFormField(
                                      controller: firstName,
                                      validator: (value) {
                                        return Validation()
                                            .nameValidation(value);
                                      },

                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,

                                      decoration: InputDecoration(
                                          label: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(AppLocalizations.of(context)!
                                                  .firstName),
                                              const Text(
                                                '*',
                                                style: TextStyle(
                                                    color: AppColors.red,
                                                    fontSize: 20),
                                              )
                                            ],
                                          ),
                                          border: OutlineInputBorder(
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
                                                  width: 1.5))),
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'\s')),
                                      ],

                                      // inputFormatters: widget.inputFormatters,
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15, left: 5, right: 15),
                                    child: TextFormField(
                                      controller: lastName,
                                      validator: (value) {
                                        return Validation()
                                            .nameValidation(value);
                                      },

                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,

                                      decoration: InputDecoration(
                                          label: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(AppLocalizations.of(context)!
                                                  .lastName),
                                              const Text(
                                                '*',
                                                style: TextStyle(
                                                    color: AppColors.red,
                                                    fontSize: 20),
                                              )
                                            ],
                                          ),
                                          border: OutlineInputBorder(
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
                                                  width: 1.5))),
                                      keyboardType: TextInputType.text,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(
                                            RegExp(r'\s')),
                                      ],

                                      // inputFormatters: widget.inputFormatters,
                                    )),
                              ),
                            ],
                          ),

                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 15, right: 15),
                              child: TextFormField(
                                controller: email,
                                validator: (value) {
                                  return Validation().emailValidation(value);
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // autofocus: widget.autofocus,
                                decoration: InputDecoration(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(AppLocalizations.of(context)!
                                            .email),
                                        const Text(
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
                                            Radius.circular(
                                                AppDimension.buttonRadius)),
                                        borderSide: BorderSide(
                                          color: appInfo.primaryColorValue,
                                          width: 1.5,
                                        )),
                                    //normal border
                                    enabledBorder: OutlineInputBorder(
                                        //Outline border type for TextFeild
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppDimension.buttonRadius)),
                                        borderSide: BorderSide(
                                          color: appInfo.primaryColorValue,
                                          width: 1.5,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        //Outline border type for TextFeild
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppDimension.buttonRadius)),
                                        borderSide: BorderSide(
                                            color: appInfo.primaryColorValue,
                                            width: 1.5))),
                                keyboardType: TextInputType.emailAddress,
                              )),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, left: 15, right: 15),
                              child: TextFormField(
                                controller: mobNo,
                                validator: (value) {
                                  return Validation().validateMobileNo(value!);
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // autofocus: widget.autofocus,
                                decoration: InputDecoration(
                                    label: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(AppLocalizations.of(context)!
                                            .mobileNo),
                                        const Text(
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
                                            Radius.circular(
                                                AppDimension.buttonRadius)),
                                        borderSide: BorderSide(
                                          color: appInfo.primaryColorValue,
                                          width: 1.5,
                                        )),
                                    enabledBorder: OutlineInputBorder(
                                        //Outline border type for TextFeild
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppDimension.buttonRadius)),
                                        borderSide: BorderSide(
                                          color: appInfo.primaryColorValue,
                                          width: 1.5,
                                        )),
                                    focusedBorder: OutlineInputBorder(
                                        //Outline border type for TextFeild
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(
                                                AppDimension.buttonRadius)),
                                        borderSide: BorderSide(
                                            color: appInfo.primaryColorValue,
                                            width: 1.5))),
                                keyboardType: TextInputType.phone,
                                // maxLength: 10,
                              )),
                          Padding(
                              padding: const EdgeInsets.all(15),
                              child: TextFormField(
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: _obscured,
                                  controller: password,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(AppLocalizations.of(context)!
                                              .password),
                                          const Text(
                                            '*',
                                            style: TextStyle(
                                                color: AppColors.red,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  AppDimension.buttonRadius)),
                                          borderSide: BorderSide(
                                            color: appInfo.primaryColorValue,
                                            width: 1.5,
                                          )),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  AppDimension.buttonRadius)),
                                          borderSide: BorderSide(
                                            color: appInfo.primaryColorValue,
                                            width: 1.5,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          //Outline border type for TextFeild
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  AppDimension.buttonRadius)),
                                          borderSide: BorderSide(
                                              color: appInfo.primaryColorValue,
                                              width: 1.5)),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 4, 0),
                                        child: GestureDetector(
                                          onTap: _toggleObscured,
                                          child: Icon(
                                              _obscured
                                                  ? Icons.visibility_off_rounded
                                                  : Icons.visibility_rounded,
                                              size: 25,
                                              color: appInfo.primaryColorValue),
                                        ),
                                      )),
                                  validator: (value) {
                                    return Validation()
                                        .validatePassword(value!);
                                  })),
                          Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: TextFormField(
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: _confirmObscured,
                                  controller: confirmPass,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                      label: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(AppLocalizations.of(context)!
                                              .confirmPass),
                                          const Text(
                                            '*',
                                            style: TextStyle(
                                                color: AppColors.red,
                                                fontSize: 20),
                                          )
                                        ],
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  AppDimension.buttonRadius)),
                                          borderSide: BorderSide(
                                            color: appInfo.primaryColorValue,
                                            width: 1.5,
                                          )),
                                      enabledBorder: OutlineInputBorder(
                                          //Outline border type for TextFeild
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  AppDimension.buttonRadius)),
                                          borderSide: BorderSide(
                                            color: appInfo.primaryColorValue,
                                            width: 1.5,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          //Outline border type for TextFeild
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(
                                                  AppDimension.buttonRadius)),
                                          borderSide: BorderSide(
                                              color: appInfo.primaryColorValue,
                                              width: 1.5)),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 4, 0),
                                        child: GestureDetector(
                                          onTap: _toggleObscuredForConfirmPass,
                                          child: Icon(
                                              _confirmObscured
                                                  ? Icons.visibility_off_rounded
                                                  : Icons.visibility_rounded,
                                              size: 25,
                                              color: appInfo.primaryColorValue),
                                        ),
                                      )),
                                  validator: (value) {
                                    return Validation().validateConfirmPassword(
                                        value!, password.text);
                                  })),
                          const SizedBox(
                            height: 10,
                          ),
                          error != ""
                              ? Center(
                                  child: Text(
                                  error,
                                  style: const TextStyle(color: AppColors.red),
                                ))
                              : Container(),
                          //fo,)),
                          Padding(
                              padding: const EdgeInsets.all(15),
                              child: Consumer(
                                builder: (context, watch, _) {
                                  return ElevatedButton(
                                      onPressed: () {
                                        if (loadingSignup == false) {
                                          if (formKey.currentState!
                                              .validate()) {
                                            signIn();
                                            _focusNode.unfocus();
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
                                      child: loadingSignup == false
                                          ? Text(
                                              AppLocalizations.of(context)!
                                                  .register,
                                              style: TextStyle(
                                                  color: AppColors.whiteColor,
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
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(AppLocalizations.of(context)!
                                  .alreadyHaveAccount),
                              TextButton(
                                child: Text(
                                  AppLocalizations.of(context)!.login,
                                  style: TextStyle(
                                      fontSize: 20,
                                      decoration: TextDecoration.underline,
                                      color: appInfo.primaryColorValue),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                      PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              const LoginScreen()));
                                },
                              )
                            ],
                          ),
                          //ToDO list signIn with google
                          // widget.isOtp != true
                          //     ? Center(
                          //   child: ElevatedButton(
                          //     onPressed: _handleSignIn,
                          //     style: ElevatedButton.styleFrom(
                          //       primary: appInfo.primaryColorValue,
                          //       shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(
                          //               AppDimension.buttonRadius)),
                          //       textStyle: const TextStyle(
                          //           color: AppColors.whiteColor,
                          //           fontSize: 10,
                          //           fontStyle: FontStyle.normal),
                          //     ),
                          //     child: Text(
                          //       AppString.signUpWithGoogle,
                          //       style: TextStyle(
                          //           color: AppColors.whiteColor,
                          //           fontSize: MediaQuery
                          //               .of(context)
                          //               .size
                          //               .width *
                          //               0.04,
                          //           fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // )
                          //     : Container()
                        ])),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => const Text(AppString.oops),
              );
            }))));
  }
}
