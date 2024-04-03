// resetPasswordScreen
import 'package:mobj_project/utils/cmsConfigue.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  String error = "";
  final formKey = GlobalKey<FormState>();
  bool _obscured = true;
  final textFieldFocusNode = FocusNode();
  bool isLoading = false;
  final email = TextEditingController();
  final pass = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final confirmPass = TextEditingController();
  bool _confirmObscured = true;
  bool _oldObscured = true;

  final password = TextEditingController();
  final oldPassword = TextEditingController();

  resetPassword() async {
    setState(() {
      isLoading = true;
    });
    final body = {
      "oldPassword": oldPassword.text,
      "newPassword": password.text,
      "confirmPassword": confirmPass.text
    };

    final resPass = ResetPasswordRepository();
    resPass.resetPassword(body).then((value) async {
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

        Navigator.pushReplacementNamed(context, RouteConstants.login);
      } else if (value == "2") {
        setState(() {
          error = AppLocalizations.of(context)!.userNotFound;
          isLoading = false;
        });
      } else if (value == "3") {
        setState(() {
          error = AppLocalizations.of(context)!.checkInternet;
          isLoading = false;
        });
      } else if (value == "4") {
        setState(() {
          error = AppLocalizations.of(context)!.passInc;
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

  void _toggleObscuredForConfirmPass() {
    setState(() {
      _confirmObscured = !_confirmObscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  void _toggleoldForPass() {
    setState(() {
      _oldObscured = !_confirmObscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            top: true,
            child: SingleChildScrollView(
                child: Consumer(builder: (context, watch, child) {
              final appInfoAsyncValue = ref.watch(appInfoProvider);
              // String appName = appInfoAsyncValue.data?.appName ?? 'Default App Name';

              return appInfoAsyncValue.when(
                data: (appInfo) => Form(
                  key: formKey, //key for form
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 15, left: 15),
                            child: Text(
                              AppLocalizations.of(context)!.resetPassword,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.06,
                                  fontWeight: FontWeight.w600),
                            )),
                        const Divider(
                          thickness: 1.5,
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 15, right: 15),
                            child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _oldObscured,
                                controller: oldPassword,
                                autofocus: false,
                                decoration: InputDecoration(
                                    label:  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(AppLocalizations.of(context)!.oldPass),
                                        Text(
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
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 4, 0),
                                      child: GestureDetector(
                                        onTap: _toggleoldForPass,
                                        child: Icon(
                                            _oldObscured
                                                ? Icons.visibility_off_rounded
                                                : Icons.visibility_rounded,
                                            size: 25,
                                            color: appInfo.primaryColorValue),
                                      ),
                                    )),
                                validator: (value) {
                                  return Validation().validatePassword(value!);
                                })),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 15, right: 15),
                            child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _obscured,
                                controller: password,
                                autofocus: false,
                                decoration: InputDecoration(
                                    label:  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(AppLocalizations.of(context)!.password),
                                        Text(
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
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 4, 0),
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
                                  return Validation().validatePassword(value!);
                                })),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: 15, left: 15, right: 15),
                            child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: _confirmObscured,
                                controller: confirmPass,
                                autofocus: false,
                                decoration: InputDecoration(
                                    label:  Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(AppLocalizations.of(context)!.confirmPass),
                                        Text(
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
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 4, 0),
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
                        error != ""
                            ? Padding(
                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                child: Center(
                                    child: Text(
                                  error,
                                  style: const TextStyle(color: AppColors.red),
                                )))
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                          child: Consumer(
                            builder: (context, watch, _) {
                              return ElevatedButton(
                                  onPressed: () {
                                    if (isLoading == false) {
                                      if (formKey.currentState!.validate()) {
                                        resetPassword();

                                        _focusNode.unfocus();
                                      }
                                    } else {}
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: appInfo.primaryColorValue,
                                    minimumSize: Size.fromHeight(50),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppDimension.buttonRadius)),
                                    // maximumSize: Size(1330, 500),
                                    // minimumSize:Size(1000, 500) ,
                                    textStyle: const TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 10,
                                        fontStyle: FontStyle.normal),
                                  ),
                                  child: isLoading == false
                                      ? Text(
                                    AppLocalizations.of(context)!.resetPass,
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
                            },
                          ),
                        ),
                      ]),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) => const Text(AppString.oops),
              );
            }))));
  }
}
