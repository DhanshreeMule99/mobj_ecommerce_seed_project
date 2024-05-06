// // LoginScreen

// // import 'package:flutter/material.dart';
// import 'dart:developer';

// import 'package:http/http.dart' as http;
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:mobj_project/utils/cmsConfigue.dart';
// import '../../provider/addressProvider.dart';
// import '../../services/shopifyServices/graphQLServices/graphQlRespository.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   String error = "";
//   final formKey = GlobalKey<FormState>();
//   bool _obscured = true;
//   final textFieldFocusNode = FocusNode();
//   bool isLoading = false;
//   final email = TextEditingController();
//   final pass = TextEditingController();
//   final FocusNode _focusNode = FocusNode();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   bool loadingSignup = false;

//   // Future<void> _handleSignIn() async {
//   //   setState(() {
//   //     loadingSignup = true;
//   //   });
//   //   loadingSignup == true
//   //       ? showDialog<bool>(
//   //           context: context,
//   //           builder: (BuildContext context) {
//   //             return AlertDialog(
//   //                 content: Row(
//   //               crossAxisAlignment: CrossAxisAlignment.center,
//   //               mainAxisAlignment: MainAxisAlignment.center,
//   //               children: [
//   //                 CircularProgressIndicator(),
//   //                 SizedBox(width: 20.0),
//   //                 Text(AppLocalizations.of(context)!.pleaseWait),
//   //               ],
//   //             ));
//   //           },
//   //         )
//   //       : null;
//   //   try {
//   //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//   //     if (googleUser != null) {
//   //       final GoogleSignInAuthentication googleAuth =
//   //           await googleUser.authentication;
//   //       final AuthCredential credential = GoogleAuthProvider.credential(
//   //         accessToken: googleAuth.accessToken,
//   //         idToken: googleAuth.idToken,
//   //       );
//   //       final UserCredential authResult =
//   //           await _auth.signInWithCredential(credential);
//   //       final User? user = authResult.user;
//   //       if (user != null) {
//   //         final body = {
//   //           "email": user.email,
//   //           "isSocialLogin": true,
//   //           "socialLoginType": AppString.google,
//   //           "token": googleAuth.idToken
//   //         };
//   //         final login = LoginRepository();
//   //         login.signIn(body).then((value) async {
//   //           await SharedPreferenceManager()
//   //               .setGoogleToken(googleAuth.idToken.toString());
//   //           Navigator.pop(context);
//   //           if (value.runtimeType != String) {
//   //             setState(() {
//   //               error = "";
//   //               loadingSignup = false;
//   //             });
//   //             Fluttertoast.showToast(
//   //                 msg: value["message"].toString(),
//   //                 toastLength: Toast.LENGTH_SHORT,
//   //                 gravity: ToastGravity.BOTTOM,
//   //                 timeInSecForIosWeb: 0,
//   //                 backgroundColor: AppColors.green,
//   //                 textColor: AppColors.whiteColor,
//   //                 fontSize: 16.0);
//   //             DeviceRepository().deviceInfo(value['data']["_id"]);

//   //             await SharedPreferenceManager()
//   //                 .setToken(value['data']["token"].toString());
//   //             await SharedPreferenceManager()
//   //                 .setUserId(value['data']['_id'].toString());
//   //             Navigator.of(context).pushAndRemoveUntil(
//   //                 PageRouteBuilder(
//   //                   pageBuilder: (context, animation1, animation2) =>
//   //                       const HomeScreen(),
//   //                   transitionDuration: Duration.zero,
//   //                   reverseTransitionDuration: Duration.zero,
//   //                 ),
//   //                 (route) => route.isCurrent);
//   //           } else if (value == "2") {
//   //             setState(() {
//   //               error = AppLocalizations.of(context)!.userNotFound;
//   //               loadingSignup = false;
//   //             });
//   //           } else if (value == "3") {
//   //             setState(() {
//   //               error = AppLocalizations.of(context)!.checkInternet;
//   //               isLoading = false;
//   //             });
//   //           } else if (value == "4") {
//   //             setState(() {
//   //               error = AppLocalizations.of(context)!.userNotRegister;
//   //               loadingSignup = false;
//   //             });
//   //           } else {
//   //             setState(() {
//   //               error = value;
//   //               loadingSignup = false;
//   //             });
//   //           }
//   //           // if (widget.logout == null) {
//   //           //   Navigator.of(context).push(PageRouteBuilder(
//   //           //     pageBuilder: (context, animation1, animation2) =>
//   //           //         Login_volunteer_otp_screen(
//   //           //           mob_or_email: mob_or_email,
//   //           //           mob_or_email_value: mob_or_email_value,
//   //           //         ),
//   //           //     transitionDuration: Duration.zero,
//   //           //     reverseTransitionDuration: Duration.zero,
//   //           //   ));
//   //           // } else {
//   //           //   Navigator.of(context).push(PageRouteBuilder(
//   //           //     pageBuilder: (context, animation1, animation2) =>
//   //           //         Login_volunteer_otp_screen(
//   //           //             mob_or_email: mob_or_email,
//   //           //             mob_or_email_value: mob_or_email_value,
//   //           //             logout: widget.logout),
//   //           //     transitionDuration: Duration.zero,
//   //           //     reverseTransitionDuration: Duration.zero,
//   //           //   ));
//   //           // }
//   //         });
//   //         // Navigator.of(context).pushReplacement(MaterialPageRoute(
//   //         //   builder: (context) => HomePage(user: user),
//   //         // ));
//   //       } else {
//   //         setState(() {
//   //           loadingSignup = false;
//   //         });
//   //         Navigator.pop(context);
//   //       }
//   //     }
//   //   } catch (error) {
//   //     setState(() {
//   //       loadingSignup = false;
//   //     });
//   //     Navigator.pop(context);

//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Text("${AppString.googleSignupError}: $error"),
//   //       ),
//   //     );u
//   //   }
//   // }

//   // signUp() async {
//   //   setState(() {
//   //     isLoading = true;
//   //   });
//   //   final body = {"email": email.text.trim(), "password": pass.text.trim()};

//   //   final login = LoginRepository();
//   //   login.signIn(body).then((value) async {
//   //     if (value.runtimeType != String) {
//   //       setState(() {
//   //         error = "";
//   //         isLoading = false;
//   //       });
//   //       Fluttertoast.showToast(
//   //           msg: value["message"].toString(),
//   //           toastLength: Toast.LENGTH_SHORT,
//   //           gravity: ToastGravity.BOTTOM,
//   //           timeInSecForIosWeb: 0,
//   //           backgroundColor: AppColors.green,
//   //           textColor: AppColors.whiteColor,
//   //           fontSize: 16.0);
//   //       await SharedPreferenceManager()
//   //           .setToken(value['data']["token"].toString());
//   //       await SharedPreferenceManager()
//   //           .setUserId(value['data']['_id'].toString());
//   //       ref.refresh(addressDataProvider);
//   //       ref.refresh(orderDataProvider);
//   //       ref.refresh(profileDataProvider);

//   //       Navigator.of(context).pushAndRemoveUntil(
//   //           PageRouteBuilder(
//   //             pageBuilder: (context, animation1, animation2) =>
//   //                 const HomeScreen(),
//   //             transitionDuration: Duration.zero,
//   //             reverseTransitionDuration: Duration.zero,
//   //           ),
//   //           (route) => route.isCurrent);
//   //     } else if (value == "2") {
//   //       setState(() {
//   //         error = AppLocalizations.of(context)!.userNotRegister;
//   //         isLoading = false;
//   //       });
//   //     } else if (value == "3") {
//   //       setState(() {
//   //         error = AppLocalizations.of(context)!.checkInternet;
//   //         isLoading = false;
//   //       });
//   //     } else if (value == "4") {
//   //       setState(() {
//   //         error = AppLocalizations.of(context)!.invalidCred;
//   //         isLoading = false;
//   //       });
//   //     } else {
//   //       setState(() {
//   //         error = value;
//   //         isLoading = false;
//   //       });
//   //     }
//   //     // if (widget.logout == null) {
//   //     //   Navigator.of(context).push(PageRouteBuilder(
//   //     //     pageBuilder: (context, animation1, animation2) =>
//   //     //         Login_volunteer_otp_screen(
//   //     //           mob_or_email: mob_or_email,
//   //     //           mob_or_email_value: mob_or_email_value,
//   //     //         ),
//   //     //     transitionDuration: Duration.zero,
//   //     //     reverseTransitionDuration: Duration.zero,
//   //     //   ));
//   //     // } else {
//   //     //   Navigator.of(context).push(PageRouteBuilder(
//   //     //     pageBuilder: (context, animation1, animation2) =>
//   //     //         Login_volunteer_otp_screen(
//   //     //             mob_or_email: mob_or_email,
//   //     //             mob_or_email_value: mob_or_email_value,
//   //     //             logout: widget.logout),
//   //     //     transitionDuration: Duration.zero,
//   //     //     reverseTransitionDuration: Duration.zero,
//   //     //   ));
//   //     // }
//   //   });
//   // }

//   void _toggleObscured() {
//     setState(() {
//       _obscured = !_obscured;
//       if (textFieldFocusNode.hasPrimaryFocus) {
//         return; // If focus is on text field, dont unfocus
//       }
//       textFieldFocusNode.canRequestFocus =
//           false; // Prevents focus if tap on eye
//     });
//   }

//   GraphQlRepository graphQLConfig = GraphQlRepository();

//   Future<void> getCustomerDetails(String accessToken) async {
//     GraphQLClient client = graphQLConfig.clientToQuery();
//     try {
//       QueryResult result = await client.query(QueryOptions(
//         fetchPolicy: FetchPolicy.noCache,
//         document: gql('''
//         query GetCustomerDetails(\$accessToken: String!) {
//           customer(customerAccessToken: \$accessToken) {
//             id
//             displayName
//             email
//             phone
//             orders(first: 5) {
//               edges {
//                 node {
//                   id
//                   name
//                 }
//               }
//             }
//           }
//         }
//       '''),
//         variables: {
//           'accessToken': accessToken,
//         },
//       ));
//       debugPrint("$result");

//       if (result.hasException) {
//         setState(() {
//           error = AppString.oops;
//           isLoading = false;
//         });

//         throw Exception(result.exception);
//       } else {
//         if (result.data?['customer'] != null) {
//           setState(() {
//             error = "";
//             isLoading = false;
//           });
//           log("customer details are this $result $accessToken");
//           debugPrint(
//               "Customer id is this -- ${result.data!['customer']['id'].toString().replaceAll("gid://shopify/Customer/", "")}");
//           await SharedPreferenceManager().setUserId(result.data!['customer']
//                   ['id']
//               .toString()
//               .replaceAll("gid://shopify/Customer/", ""));
//           await SharedPreferenceManager().setToken(accessToken);
//           ref.refresh(addressDataProvider);
//           ref.refresh(orderDataProvider);
//           ref.refresh(profileDataProvider);
//           Fluttertoast.showToast(
//               msg: AppLocalizations.of(context)!.loginSuccess,
//               toastLength: Toast.LENGTH_SHORT,
//               gravity: ToastGravity.BOTTOM,
//               timeInSecForIosWeb: 0,
//               backgroundColor: AppColors.green,
//               textColor: AppColors.whiteColor,
//               fontSize: 16.0);
//           Navigator.of(context).pushAndRemoveUntil(
//               PageRouteBuilder(
//                 pageBuilder: (context, animation1, animation2) =>
//                     const HomeScreen(),
//                 transitionDuration: Duration.zero,
//                 reverseTransitionDuration: Duration.zero,
//               ),
//               (route) => route.isCurrent);
//         } else {
//           setState(() {
//             error = AppLocalizations.of(context)!.oops;
//             isLoading = false;
//           });
//         }
//       }
//     } catch (errors) {
//       setState(() {
//         error = AppLocalizations.of(context)!.oops;
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> _signInWithEmailAndPassword(BuildContext context) async {
//     if (AppConfigure.bigCommerce) {
//       // Login with BigCommerce
//       String bigCommerceUrl = AppConfigure.bigcommerceUrl;
//       try {
//         setState(() {
//           isLoading = true;
//         });
//         final response = await http.post(
//           Uri.parse('$bigCommerceUrl/customers/validate-credentials'),
//           headers: <String, String>{
//             "Content-Type": "application/json",
//             "X-Auth-Token": AppConfigure.bigCommerceAccessToken,
//           },
//           body: jsonEncode(<String, String>{
//             'email': email.text.trim(),
//             'password': pass.text.trim(),
//           }),
//         );
//         print('BigCommerce Response: ${response.body}');
//         if (response.statusCode == 200) {
//           final Map<String, dynamic> responseData = json.decode(response.body);
//           if (responseData['is_valid'] == true) {
//             await SharedPreferenceManager().setEmail(
//               email.text.trim(),
//             );
//             await SharedPreferenceManager().setUserId(
//                 responseData['customer_id']
//                     .toString()
//                     .replaceAll("gid://shopify/Customer/", ""));
//             await SharedPreferenceManager()
//                 .setToken(AppConfigure.bigCommerceAccessToken);
//             ref.refresh(addressDataProvider);
//             ref.refresh(orderDataProvider);
//             ref.refresh(profileDataProvider);
//             Fluttertoast.showToast(
//                 msg: AppLocalizations.of(context)!.loginSuccess,
//                 toastLength: Toast.LENGTH_SHORT,
//                 gravity: ToastGravity.BOTTOM,
//                 timeInSecForIosWeb: 0,
//                 backgroundColor: AppColors.green,
//                 textColor: AppColors.whiteColor,
//                 fontSize: 16.0);
//             Navigator.of(context).pushAndRemoveUntil(
//                 PageRouteBuilder(
//                   pageBuilder: (context, animation1, animation2) =>
//                       const HomeScreen(),
//                   transitionDuration: Duration.zero,
//                   reverseTransitionDuration: Duration.zero,
//                 ),
//                 (route) => route.isCurrent);
//           } else {
//             // Failure, show error message
//             setState(() {
//               error = AppLocalizations.of(context)!.invalidCred;
//               isLoading = false;
//             });
//           }
//         } else {
//           // If the server did not return a 200 OK response, show error message
//           setState(() {
//             error = AppLocalizations.of(context)!.oops;
//             isLoading = false;
//           });
//         }
//       } catch (e) {
//         // Exception occurred, show error message
//         print('Error occurred: $e');
//       }
//     } else {
//       // Login with Shopify (existing code)
//       GraphQLClient client = graphQLConfig.clientToQuery();
//       setState(() {
//         isLoading = true;
//       });
//       try {
//         QueryResult result = await client.query(QueryOptions(
//           fetchPolicy: FetchPolicy.noCache,
//           document: gql('''
//           mutation SignInWithEmailAndPassword(\$email: String!, \$password: String!) {
//             customerAccessTokenCreate(input: { email: \$email, password: \$password }) {
//               customerAccessToken {
//                 accessToken
//                 expiresAt
//               }
//               customerUserErrors {
//                 code
//                 message
//               }
//             }
//           }
//         '''),
//           variables: {"email": email.text.trim(), "password": pass.text.trim()},
//         ));

//         if (result.hasException) {
//           setState(() {
//             error = AppLocalizations.of(context)!.oops;
//             isLoading = false;
//           });
//         } else {
//           if (result.data?["customerAccessTokenCreate"] != null &&
//               result.data?["customerAccessTokenCreate"]
//                       ['customerAccessToken'] !=
//                   null) {
//             getCustomerDetails(result.data!["customerAccessTokenCreate"]
//                     ['customerAccessToken']['accessToken']
//                 .toString());
//           } else {
//             setState(() {
//               error = AppLocalizations.of(context)!.invalidCred;
//               isLoading = false;
//             });
//           }
//         }
//       } catch (errors) {
//         setState(() {
//           error = AppLocalizations.of(context)!.oops;
//           isLoading = false;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//             top: true,
//             child: SingleChildScrollView(
//                 child: Consumer(builder: (context, watch, child) {
//               final appInfoAsyncValue = ref.watch(appInfoProvider);
//               return appInfoAsyncValue.when(
//                 data: (appInfo) => Form(
//                   key: formKey, //key for form
//                   child: Column(children: [
//                     Padding(
//                         padding: const EdgeInsets.only(top: 15, left: 0),
//                         child: Text(
//                           AppLocalizations.of(context)!.login,
//                           style: TextStyle(
//                               fontSize:
//                                   MediaQuery.of(context).size.width * 0.06,
//                               fontWeight: FontWeight.w600),
//                         )
//                         ),
//                     const Divider(
//                       thickness: 1.5,
//                     ),
//                     Padding(
//                         padding:
//                             const EdgeInsets.only(top: 25, left: 0, bottom: 0),
//                         child: Text(
//                           '${AppLocalizations.of(context)!.welcome} ${appInfo.appName}',
//                           style: TextStyle(
//                               fontSize:
//                                   MediaQuery.of(context).size.width * 0.07,
//                               fontWeight: FontWeight.w600),
//                         )),
//                     const SizedBox(
//                       height: 15,
//                     ),
//                     SizedBox(
//                       height: 200,
//                       width: 200,
//                       child: CachedNetworkImage(
//                         imageUrl: appInfo.logoImagePath,
//                         placeholder: (context, url) => Container(
//                           width: MediaQuery.of(context).size.width,
//                           color: AppColors.greyShade200,
//                         ),
//                         errorWidget: (context, url, error) =>
//                             const Icon(Icons.error),
//                       ),
//                     ),
//                     Padding(
//                         padding:
//                             const EdgeInsets.only(right: 10, left: 10, top: 25),
//                         child: TextFormField(
//                           controller: email,
//                           validator: (value) {
//                             return Validation().emailValidation(value);
//                           },
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           decoration: InputDecoration(
//                               label: Row(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Text(AppLocalizations.of(context)!.email),
//                                   const Text(
//                                     '*',
//                                     style: TextStyle(
//                                         color: AppColors.red, fontSize: 20),
//                                   )
//                                 ],
//                               ),
//                               border: OutlineInputBorder(
//                                   //Outline border type for TextFeild
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(
//                                           AppDimension.buttonRadius)),
//                                   borderSide: BorderSide(
//                                     color: appInfo.primaryColorValue,
//                                     width: 1.5,
//                                   )),
//                               //normal border
//                               enabledBorder: OutlineInputBorder(
//                                   //Outline border type for TextFeild
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(
//                                           AppDimension.buttonRadius)),
//                                   borderSide: BorderSide(
//                                     color: appInfo.primaryColorValue,
//                                     width: 1.5,
//                                   )),
//                               focusedBorder: OutlineInputBorder(
//                                   borderRadius: const BorderRadius.all(
//                                       Radius.circular(
//                                           AppDimension.buttonRadius)),
//                                   borderSide: BorderSide(
//                                       color: appInfo.primaryColorValue,
//                                       width: 1.5))),
//                           keyboardType: TextInputType.emailAddress,
//                         )),
//                     Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: TextFormField(
//                             keyboardType: TextInputType.visiblePassword,
//                             obscureText: _obscured,
//                             controller: pass,
//                             // focusNode: _focuspass,

//                             autofocus: false,
//                             decoration: InputDecoration(
//                                 label: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                         AppLocalizations.of(context)!.password),
//                                     const Text(
//                                       '*',
//                                       style: TextStyle(
//                                           color: AppColors.red, fontSize: 20),
//                                     )
//                                   ],
//                                 ),
//                                 border: OutlineInputBorder(
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(
//                                             AppDimension.buttonRadius)),
//                                     borderSide: BorderSide(
//                                       color: appInfo.primaryColorValue,
//                                       width: 1.5,
//                                     )),
//                                 enabledBorder: OutlineInputBorder(
//                                     //Outline border type for TextFeild
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(
//                                             AppDimension.buttonRadius)),
//                                     borderSide: BorderSide(
//                                       color: appInfo.primaryColorValue,
//                                       width: 1.5,
//                                     )),
//                                 focusedBorder: OutlineInputBorder(
//                                     //Outline border type for TextFeild
//                                     borderRadius: const BorderRadius.all(
//                                         Radius.circular(
//                                             AppDimension.buttonRadius)),
//                                     borderSide: BorderSide(
//                                         color: appInfo.primaryColorValue,
//                                         width: 1.5)),
//                                 suffixIcon: Padding(
//                                   padding:
//                                       const EdgeInsets.fromLTRB(0, 0, 4, 0),
//                                   child: GestureDetector(
//                                     onTap: _toggleObscured,
//                                     child: Icon(
//                                         _obscured
//                                             ? Icons.visibility_off_rounded
//                                             : Icons.visibility_rounded,
//                                         size: 25,
//                                         color: appInfo.primaryColorValue),
//                                   ),
//                                 )),
//                             validator: (value) {
//                               return Validation().validatePassword(value!);
//                             })
//                             ),
//                     error != ""
//                         ? Center(
//                             child: Text(
//                             error,
//                             style: const TextStyle(color: AppColors.red),
//                           ))
//                         : Container(),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
//                       child: Consumer(
//                         builder: (context, watch, _) {
//                           return ElevatedButton(
//                               onPressed: () async {
//                                 if (isLoading == false) {
//                                   if (formKey.currentState!.validate()) {
//                                     _signInWithEmailAndPassword(context);

//                                     _focusNode.unfocus();
//                                   } else {}
//                                 }
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: appInfo.primaryColorValue,
//                                 minimumSize: const Size.fromHeight(50),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(
//                                         AppDimension.buttonRadius)),
//                                 textStyle: const TextStyle(
//                                     color: AppColors.whiteColor,
//                                     fontSize: 10,
//                                     fontStyle: FontStyle.normal),
//                               ),
//                               child: isLoading == false
//                                   ? Text(
//                                       AppLocalizations.of(context)!
//                                           .login
//                                           .toUpperCase(),
//                                       style: TextStyle(
//                                           fontSize: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                               0.05,
//                                           color: AppColors.whiteColor,
//                                           fontWeight: FontWeight.bold),
//                                     )
//                                   : const CircularProgressIndicator(
//                                       color: AppColors.whiteColor,
//                                     ));
//                         },
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(AppLocalizations.of(context)!.notHaveAcc),
//                         TextButton(
//                           child: Text(
//                             AppLocalizations.of(context)!.signUp,
//                             style: TextStyle(
//                               fontSize: 20,
//                               color: appInfo.primaryColorValue,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                           onPressed: () {
//                             //signup screen
//                             Navigator.of(context).push(PageRouteBuilder(
//                                 pageBuilder:
//                                     (context, animation1, animation2) =>
//                                         const RegistrationScreen()));
//                           },
//                         )
//                       ],
//                     ),
//                     //ToDo list forget your password
//                     TextButton(
//                       child: Text(
//                         AppLocalizations.of(context)!.forgetPass,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: appInfo.primaryColorValue,
//                           decoration: TextDecoration.underline,
//                         ),
//                       ),
//                       onPressed: () {
//                         //signup screen
//                         Navigator.of(context).push(PageRouteBuilder(
//                             pageBuilder: (context, animation1, animation2) =>
//                                 const ForgotPasswordScreen()));
//                       },
//                     ),
//                     //ToDo list login with google
//                     // ElevatedButton(
//                     //   onPressed: _handleSignIn,
//                     //   style: ElevatedButton.styleFrom(
//                     //     primary: appInfo.primaryColorValue,
//                     //     shape: RoundedRectangleBorder(
//                     //         borderRadius: BorderRadius.circular(
//                     //             AppDimension.buttonRadius)),
//                     //     textStyle: const TextStyle(
//                     //         color: AppColors.whiteColor,
//                     //         fontSize: 10,
//                     //         fontStyle: FontStyle.normal),
//                     //   ),
//                     //   child: Text(
//                     //     AppString.signInGoogle,
//                     //     style: TextStyle(
//                     //         color: AppColors.whiteColor,
//                     //         fontSize: MediaQuery.of(context).size.width * 0.045,
//                     //         fontWeight: FontWeight.bold),
//                     //   ),
//                     // ),
//                   ]),
//                 ),
//                 loading: () => const Center(child: CircularProgressIndicator()),
//                 error: (error, stackTrace) => const Text(AppString.oops),
//               );
//             }
//             )
//             )
//             )
//             );
//   }
// }





// LoginScreen

import 'dart:developer';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import '../../provider/addressProvider.dart';
import '../../services/shopifyServices/graphQLServices/graphQlRespository.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String error = "";
  final formKey = GlobalKey<FormState>();
  bool _obscured = true;
  final textFieldFocusNode = FocusNode();
  bool isLoading = false;
  final email = TextEditingController();
  final pass = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool loadingSignup = false;



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

  GraphQlRepository graphQLConfig = GraphQlRepository();

  Future<void> getCustomerDetails(String accessToken) async {
    GraphQLClient client = graphQLConfig.clientToQuery();
    try {
      QueryResult result = await client.query(QueryOptions(
        fetchPolicy: FetchPolicy.noCache,
        document: gql('''
        query GetCustomerDetails(\$accessToken: String!) {
          customer(customerAccessToken: \$accessToken) {
            id
            displayName
            email
            phone
            orders(first: 5) {
              edges {
                node {
                  id
                  name
                }
              }
            }
          }
        }
      '''),
        variables: {
          'accessToken': accessToken,
        },
      ));
      debugPrint("$result");

      if (result.hasException) {
        setState(() {
          error = AppString.oops;
          isLoading = false;
        });

        throw Exception(result.exception);
      } else {
        if (result.data?['customer'] != null) {
          setState(() {
            error = "";
            isLoading = false;
          });
          log("customer details are this $result $accessToken");
          debugPrint(
              "Customer id is this -- ${result.data!['customer']['id'].toString().replaceAll("gid://shopify/Customer/", "")}");
          await SharedPreferenceManager().setUserId(result.data!['customer']
                  ['id']
              .toString()
              .replaceAll("gid://shopify/Customer/", ""));
          await SharedPreferenceManager().setToken(accessToken);
          ref.refresh(addressDataProvider);
          ref.refresh(orderDataProvider);
          ref.refresh(profileDataProvider);
          Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.loginSuccess,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 0,
              backgroundColor: AppColors.green,
              textColor: AppColors.whiteColor,
              fontSize: 16.0);
          Navigator.of(context).pushAndRemoveUntil(
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    const HomeScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => route.isCurrent);
        } else {
          setState(() {
            error = AppLocalizations.of(context)!.oops;
            isLoading = false;
          });
        }
      }
    } catch (errors) {
      setState(() {
        error = AppLocalizations.of(context)!.oops;
        isLoading = false;
      });
    }
  }

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    if (AppConfigure.bigCommerce) {
      // Login with BigCommerce
      String bigCommerceUrl = AppConfigure.bigcommerceUrl;
      try {
        setState(() {
          isLoading = true;
        });
        final response = await http.post(
          Uri.parse('$bigCommerceUrl/customers/validate-credentials'),
          headers: <String, String>{
            "Content-Type": "application/json",
            "X-Auth-Token": AppConfigure.bigCommerceAccessToken,
          },
          body: jsonEncode(<String, String>{
            'email': email.text.trim(),
            'password': pass.text.trim(),
          }),
        );
        print('BigCommerce Response: ${response.body}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          if (responseData['is_valid'] == true) {
            await SharedPreferenceManager().setEmail(
              email.text.trim(),
            );
            await SharedPreferenceManager().setUserId(
                responseData['customer_id']
                    .toString()
                    .replaceAll("gid://shopify/Customer/", ""));
            await SharedPreferenceManager()
                .setToken(AppConfigure.bigCommerceAccessToken);
            ref.refresh(addressDataProvider);
            ref.refresh(orderDataProvider);
            ref.refresh(profileDataProvider);
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)!.loginSuccess,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 0,
                backgroundColor: AppColors.green,
                textColor: AppColors.whiteColor,
                fontSize: 16.0);
            Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const HomeScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                (route) => route.isCurrent);
          } else {
            // Failure, show error message
            setState(() {
              error = AppLocalizations.of(context)!.invalidCred;
              isLoading = false;
            });
          }
        } else {
          // If the server did not return a 200 OK response, show error message
          setState(() {
            error = AppLocalizations.of(context)!.oops;
            isLoading = false;
          });
        }
      } catch (e) {
        // Exception occurred, show error message
        print('Error occurred: $e');
      }
    } else if (AppConfigure.wooCommerce) {

// login with Woo Commerce
API api = API();
     
          final body = 
                  {
            "username": email.text,
            "password": pass.text,
          };
      try {
          setState(() {
          isLoading = true;
        });
        final response = await api.sendRequest.post(
          '/wp-json/jwt-auth/v1/token',
          options: Options(headers: {
            "Content-Type": "application/x-www-form-urlencoded",
          }),
          data: body,
         
        );
        print('wooCommerce Response: ${response.data}');
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = response.data;

           final String userEmail = responseData['data']['email'];
      final int userId = responseData['data']['id'];
      final String token = responseData['data']['token'];
          if (responseData['success'] == true) {

        await SharedPreferenceManager().setEmail(userEmail);
        await SharedPreferenceManager().setUserId(userId.toString());
        await SharedPreferenceManager().setToken(token);
           
            ref.refresh(addressDataProvider);
            ref.refresh(orderDataProvider);
            ref.refresh(profileDataProvider);
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)!.loginSuccess,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 0,
                backgroundColor: AppColors.green,
                textColor: AppColors.whiteColor,
                fontSize: 16.0);
            Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const HomeScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                (route) => route.isCurrent);
          } else {
            // Failure, show error message
            setState(() {
              error = AppLocalizations.of(context)!.invalidCred;
              isLoading = false;
            });
          }
        } else {
          // If the server did not return a 200 OK response, show error message
          setState(() {
            error = AppLocalizations.of(context)!.oops;
            isLoading = false;
          });
        }
      } catch (e) {
         setState(() {
              error = AppLocalizations.of(context)!.doesNotHaveAcc;
              isLoading = false;
            });
        // Exception occurred, show error message
        print('Error occurred: $e');
      }
    } 
     else {
      // Login with Shopify (existing code)
      GraphQLClient client = graphQLConfig.clientToQuery();
      setState(() {
        isLoading = true;
      });
      try {
        QueryResult result = await client.query(QueryOptions(
          fetchPolicy: FetchPolicy.noCache,
          document: gql('''
          mutation SignInWithEmailAndPassword(\$email: String!, \$password: String!) {
            customerAccessTokenCreate(input: { email: \$email, password: \$password }) {
              customerAccessToken {
                accessToken
                expiresAt
              }
              customerUserErrors {
                code
                message
              }
            }
          }
        '''),
          variables: {"email": email.text.trim(), "password": pass.text.trim()},
        ));

        if (result.hasException) {
          setState(() {
            error = AppLocalizations.of(context)!.oops;
            isLoading = false;
          });
        } else {
          if (result.data?["customerAccessTokenCreate"] != null &&
              result.data?["customerAccessTokenCreate"]
                      ['customerAccessToken'] !=
                  null) {
            getCustomerDetails(result.data!["customerAccessTokenCreate"]
                    ['customerAccessToken']['accessToken']
                .toString());
          } else {
            setState(() {
              error = AppLocalizations.of(context)!.invalidCred;
              isLoading = false;
            });
          }
        }
      } catch (errors) {
        setState(() {
          error = AppLocalizations.of(context)!.oops;
          isLoading = false;
        });
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.23),

          
                child:
                 Container(
                    //  height: MediaQuery.of(context).size.height * 0.6,
                  //  width: MediaQuery.of(context).size.width  ,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/login.jpg"),
                  fit: BoxFit.cover, 
                    
                    ),
                  ), 
                ),
               ),
                 
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                    //  height: MediaQuery.of(context).size.height * 0.5,
                    // width: MediaQuery.of(context).size.width  ,
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
               child:
                Consumer(builder: (context, watch, child) {
              final appInfoAsyncValue = ref.watch(appInfoProvider);
              return appInfoAsyncValue.when(
                data: (appInfo) => 
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                       padding: const EdgeInsets.only( left: 10),
                        child: Text(
                            AppLocalizations.of(context)!.login, style: Theme.of(context).textTheme.headlineLarge,
                          
                          ),
                      ),
                       Padding(
                        padding:
                            const EdgeInsets.only(right: 10, left: 10, top: 25),
                        child: TextFormField(

                          onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
                          
                          controller: email,
                          validator: (value) {
                            return Validation().emailValidation(value);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            errorStyle: TextStyle(fontSize: 12),
                             contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10),
                              label: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(AppLocalizations.of(context)!.email),
                                  const Text(
                                    '*',
                                    style: TextStyle(
                                        color: AppColors.red, fontSize: 20),
                                  )
                                ],
                              ),
                              border: OutlineInputBorder(
                                  //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          AppDimension.buttonRadius)),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 1.5,
                                  )),
                              // //normal border
                              enabledBorder: OutlineInputBorder(
                                  //Outline border type for TextFeild
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          AppDimension.buttonRadius)),
                                  borderSide: BorderSide(
                                   color: Theme.of(context).colorScheme.primary,
                                    width: 1.5,
                                  )
                                  ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(
                                          AppDimension.buttonRadius)),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                      width: 1.5)
                                      )
                                      ),
                          keyboardType: TextInputType.emailAddress,
                        )),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: TextFormField(
                          onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscured,
                            controller: pass,
                            // focusNode: _focuspass,
                            autofocus: false,
                            decoration: InputDecoration(
                          errorStyle: TextStyle(fontSize: 12),
                
                               contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10),
                                label: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                        AppLocalizations.of(context)!.password),
                                    const Text(
                                      '*',
                                      style: TextStyle(
                                          color: AppColors.red, fontSize: 20),
                                    )
                                  ],
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            AppDimension.buttonRadius)),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 1.5,
                                    )),
                                enabledBorder: OutlineInputBorder(
                                    //Outline border type for TextFeild
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            AppDimension.buttonRadius)),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primary,
                                      width: 1.5,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    //Outline border type for TextFeild
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                            AppDimension.buttonRadius)),
                                    borderSide: BorderSide(
                                      color: Theme.of(context).colorScheme.primary,
                                        width: 1.5)),
                                suffixIcon: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                  child: GestureDetector(
                                    onTap: _toggleObscured,
                                    child: Icon(
                                        _obscured
                                            ? Icons.visibility_off_rounded
                                            : Icons.visibility_rounded,
                                        size: 25,
                                      color: Theme.of(context).colorScheme.primary,
                                        ),
                                  ),
                                )),
                            validator: (value) {
                              return Validation().validatePassword(value!);
                            })
                            ),
                     
                     
                         error != ""
                        ? Center(
                            child: Text(
                            error,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.red),
                          ))
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                      child: Consumer(
                        builder: (context, watch, _) {
                          return ElevatedButton(
                              onPressed: () async {
                                if (isLoading == false) {
                                  if (formKey.currentState!.validate()) {
                                    _signInWithEmailAndPassword(context);

                                    _focusNode.unfocus();
                                  } else {}
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
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
                                      AppLocalizations.of(context)!
                                          .login
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          color: AppColors.whiteColor,
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
                        Text(AppLocalizations.of(context)!.notHaveAcc,style: Theme.of(context).textTheme.bodyLarge),
                        TextButton(
                          child: Text(
                            AppLocalizations.of(context)!.signUp,style: Theme.of(context).textTheme.displayMedium
                         
                          ),
                          onPressed: () {
                            //signup screen
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        const RegistrationScreen()));
                          },
                        )
                      ],
                    ),
                        TextButton(
                      child: Text(
                        AppLocalizations.of(context)!.forgetPass,style: Theme.of(context).textTheme.displayMedium

                        
                      ),
                      onPressed: () {
                        //signup screen
                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const ForgotPasswordScreen()));
                      },
                    ),
                    
                    ],
                  ),
                ),
                 loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => const Text(AppString.oops),
              );
            }
            )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
