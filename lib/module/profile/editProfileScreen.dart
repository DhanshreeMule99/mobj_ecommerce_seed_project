// editProfileScreen

import 'package:mobj_project/utils/cmsConfigue.dart';

final isLoading = StateProvider((ref) => false);
final fNameProvider = StateProvider((ref) => "");
final lNameProvider = StateProvider((ref) => "");
final emailProvider = StateProvider((ref) => "");
final phoneProvider = StateProvider((ref) => "");

class EditProfileScreen extends ConsumerStatefulWidget {
  final bool? logout;

  const EditProfileScreen({Key? key, this.logout}) : super(key: key);

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final double ratings = 0.0;
  final String error = "";

  final formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  getProfilePic() async {
    profilePic = await SharedPreferenceManager().getProfile();
    setState(() {});
  }

  String? profilePic;

  @override
  void initState() {
    // TODO: implement initState
    getProfilePic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    editProfile() async {
      //ref.read(isLoading.notifier).state = true;
      final uid = await SharedPreferenceManager().getUserId();
      final accessToken = await SharedPreferenceManager().getToken();
     Map<String, dynamic> body;

if (AppConfigure.bigCommerce) {
  body = {
    "first_name": ref.read(fNameProvider),
    "last_name": ref.read(lNameProvider),
    "company": "setooooo",
    "phone": ref.read(phoneProvider),
    "id": int.parse(uid)
  };
} else if (AppConfigure.wooCommerce) {
  body = {
    "first_name": ref.read(fNameProvider),
    "last_name": ref.read(lNameProvider),
    "billing": {
      "phone": ref.read(phoneProvider),
    },
    "id": int.parse(uid)
  };
} else {
  body = {
    "customerAccessToken": "${AppConfigure.accessToken}",
    "customer": {
      "firstName": ref.read(fNameProvider),
      "lastName": ref.read(lNameProvider),
      "phone": "+91${ref.read(phoneProvider)}"
    }
  };
}

      final register = UserRepository();
      register.editProfile(body).then((value) async {
        if (value != AppString.serverError) {
          print('got in');
          if (value == AppString.checkInternet) {
            ref.read(isLoading.notifier).state = false;
            Fluttertoast.showToast(
                msg: value,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 0,
                backgroundColor: AppColors.green,
                textColor: AppColors.whiteColor,
                fontSize: 16.0);
          } else {
            ref.refresh(profileDataProvider);
            ref.read(isLoading.notifier).state = false;
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const ProfileScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ));
            Fluttertoast.showToast(
                msg: AppLocalizations.of(context)!.updateProfileSuccess,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 0,
                backgroundColor: AppColors.green,
                textColor: AppColors.whiteColor,
                fontSize: 16.0);
          }
        } else {
          Fluttertoast.showToast(
              msg: value,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 0,
              backgroundColor: AppColors.green,
              textColor: AppColors.whiteColor,
              fontSize: 16.0);
          ref.read(isLoading.notifier).state = false;
        }
      });
    }

    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return appInfoAsyncValue.when(
        data: (appInfo) => Scaffold(
            appBar: AppBar(
              elevation: 2,
              // backgroundColor: app_colors.white_color,
              title: Text(
                AppLocalizations.of(context)!.profile,
              ),
            ),
            bottomNavigationBar: MobjBottombar(
              bgcolor: AppColors.whiteColor,
              selcted_icon_color: AppColors.buttonColor,
              unselcted_icon_color: AppColors.blackColor,
              selectedPage: 3,
              screen1: const HomeScreen(),
              screen2: const SearchWidget(),
              screen3: const HomeScreen(),
              screen4: const ProfileScreen(),
              ref: ref,
            ),
            body: SingleChildScrollView(
                child: ref.watch(profileDataProvider).when(
                    data: (profile) {
                      return Form(
                          key: formKey, //key for form
                          child: Column(children: [
                            const SizedBox(
                              height: 10,
                            ),
                            // profilePic != null && profilePic != ""
                            //     ? InkWell(
                            //         onTap: () {},
                            //         child: CircleAvatar(
                            //           backgroundImage:
                            //               FileImage(File(profilePic!)),
                            //           radius: 50,
                            //         ))
                            //     : const CircleAvatar(
                            //         radius: 50,
                            //         child: Icon(Icons.person),
                            //       ),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // Padding(
                            //   padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                            //   child: ElevatedButton(
                            //       onPressed: () {
                            //         // uploadImage();
                            //         Navigator.of(context).push(
                            //           PageRouteBuilder(
                            //             pageBuilder:
                            //                 (context, animation1, animation2) =>
                            //                     const ImageCrop(),
                            //             transitionDuration: Duration.zero,
                            //             reverseTransitionDuration:
                            //                 Duration.zero,
                            //           ),
                            //         );
                            //       },
                            //       style: ElevatedButton.styleFrom(
                            //         backgroundColor: appInfo.primaryColorValue,
                            //         // minimumSize: Size.fromHeight(50),
                            //         shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(
                            //                 AppDimension.buttonRadius)),
                            //         // maximumSize: Size(1330, 500),
                            //         // minimumSize:Size(1000, 500) ,
                            //         textStyle: const TextStyle(
                            //             color: AppColors.whiteColor,
                            //             fontSize: 10,
                            //             fontStyle: FontStyle.normal),
                            //       ),
                            //       child: Text(
                            //         AppString.uploadImage,
                            //         style: TextStyle(
                            //             color: AppColors.whiteColor,
                            //             fontSize:
                            //                 MediaQuery.of(context).size.width *
                            //                     0.05,
                            //             fontWeight: FontWeight.bold),
                            //       )),
                            // ),
                            // const SizedBox(
                            //   height: 16,
                            // ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 10, right: 5),
                                      child: TextFormField(
                                        initialValue:
                                            profile.firstName.toString(),
                                        validator: (value) {
                                          return Validation()
                                              .nameValidation(value);
                                        },
                                        onChanged: (val) {
                                          ref
                                              .read(fNameProvider.notifier)
                                              .state = val;
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,

                                        decoration: InputDecoration(
                                            label: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(AppLocalizations.of(
                                                        context)!
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
                                                    color: appInfo.primaryColorValue,
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
                                          top: 15, left: 5, right: 5),
                                      child: TextFormField(
                                        initialValue:
                                            profile.lastName.toString(),
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
                                                Text(AppLocalizations.of(
                                                        context)!
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
                                            //enabled bordera

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
                                        keyboardType: TextInputType.text,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                              RegExp(r'\s')),
                                        ],
                                        onChanged: (val) {
                                          ref
                                              .read(lNameProvider.notifier)
                                              .state = val;
                                        },

                                        // inputFormatters: widget.inputFormatters,
                                      )),
                                )
                              ],
                            ),
                            // Padding(
                            //     padding: const EdgeInsets.only(
                            //         top: 15, left: 10, right: 5),
                            //     child: TextFormField(
                            //       initialValue: profile.email.toString(),
                            //       validator: (value) {
                            //         return Validation().emailValidation(value);
                            //       },
                            //       onChanged: (val) {
                            //         ref.read(emailProvider.notifier).state =
                            //             val;
                            //       },
                            //       autovalidateMode:
                            //           AutovalidateMode.onUserInteraction,
                            //       // autofocus: widget.autofocus,
                            //       decoration: InputDecoration(
                            //           label: const Row(
                            //             mainAxisSize: MainAxisSize.min,
                            //             children: [
                            //               Text(AppString.email),
                            //               Text(
                            //                 '*',
                            //                 style: TextStyle(
                            //                     color: AppColors.red,
                            //                     fontSize: 20),
                            //               )
                            //             ],
                            //           ),
                            //           border: OutlineInputBorder(
                            //               //Outline border type for TextFeild
                            //               borderRadius: const BorderRadius.all(
                            //                   Radius.circular(
                            //                       AppDimension.buttonRadius)),
                            //               borderSide: BorderSide(
                            //                 color: appInfo.primaryColorValue,
                            //                 width: 1.5,
                            //               )),
                            //           //normal border
                            //           enabledBorder: OutlineInputBorder(
                            //               //Outline border type for TextFeild
                            //               borderRadius: const BorderRadius.all(
                            //                   Radius.circular(
                            //                       AppDimension.buttonRadius)),
                            //               borderSide: BorderSide(
                            //                 color: appInfo.primaryColorValue,
                            //                 width: 1.5,
                            //               )),
                            //           focusedBorder: OutlineInputBorder(
                            //               //Outline border type for TextFeild
                            //               borderRadius: const BorderRadius.all(
                            //                   Radius.circular(
                            //                       AppDimension.buttonRadius)),
                            //               borderSide: BorderSide(
                            //                   color: appInfo.primaryColorValue,
                            //                   width: 1.5))),
                            //       keyboardType: TextInputType.emailAddress,
                            //     )),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 15, left: 10, right: 5),
                                child: TextFormField(
                                  initialValue: profile.phone
                                      .replaceAll("+91", "")
                                      .toString(),

                                  onChanged: (val) {
                                    ref.read(phoneProvider.notifier).state =
                                        val.replaceAll("+91", "");
                                  },
                                  validator: (value) {
                                    return Validation()
                                        .validateMobileNo(value!);
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

                                  // inputFormatters: widget.inputFormatters,
                                )),

                            error != ""
                                ? Center(
                                    child: Text(
                                    error,
                                    style: const TextStyle(
                                      color: AppColors.red,
                                    ),
                                  ))
                                : Container(),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 35, 10, 15),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate() &&
                                      ref.read(isLoading) == false) {
                                    if (ref.read(fNameProvider) == "") {
                                      ref.read(fNameProvider.notifier).state =
                                          profile.firstName;
                                    }
                                    if (ref.read(lNameProvider) == "") {
                                      ref.read(lNameProvider.notifier).state =
                                          profile.lastName;
                                    }
                                    if (ref.read(emailProvider) == "") {
                                      ref.read(emailProvider.notifier).state =
                                          profile.email;
                                    }
                                    if (ref.read(phoneProvider) == "") {
                                      ref.read(phoneProvider.notifier).state =
                                          profile.phone;
                                    }

                                    editProfile();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: appInfo.primaryColorValue,
                                  minimumSize: const Size.fromHeight(50),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          AppDimension.buttonRadius)),
                                  textStyle: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontSize: 10,
                                      fontStyle: FontStyle.normal),
                                ),
                                child: ref.watch(isLoading) == false
                                    ? Text(
                                        AppLocalizations.of(context)!
                                            .updateProfile
                                            .toUpperCase(),
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
                                      ),
                              ),
                            ),
                          ]));
                    },
                    error: (error, s) => const SizedBox(),
                    loading: () => const SizedBox()))),
        loading: () => const CircularProgressIndicator(),
        error: (error, stackTrace) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4.2,
                ),
              ],
            ));
  }
}
