// forgotPasswordScreen
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

import '../../services/shopifyServices/graphQLServices/graphQlRespository.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  final bool? isResetPass;

  const ForgotPasswordScreen({super.key, this.isResetPass});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  String error = "";
  final formKey = GlobalKey<FormState>();
  final bool _obscured = true;
  final textFieldFocusNode = FocusNode();
  bool isLoading = false;
  final email = TextEditingController();
  final pass = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  GraphQlRepository graphQLConfig = GraphQlRepository();

  signUp() async {
    setState(() {
      isLoading = true;
    });

    final body = {"email": email.text};
    GraphQLClient client = graphQLConfig.clientToQuery();

    try {
      final MutationOptions options = MutationOptions(
        document: gql('''
        mutation SendPasswordResetEmail(\$email: String!) {
          customerRecover(email: \$email) {
            customerUserErrors {
              code
              message
            }
            userErrors {
              message
            }
          }
        }
      '''),
        variables: {'email': email.text},
      );

      final QueryResult result = await client.mutate(options);

      if (result.hasException) {
        setState(() {
          error = AppLocalizations.of(context)!.exceedLimit;
          isLoading = false;
        });
      } else {
        final customerUserErrors =
            result.data?['customerRecover']['customerUserErrors'];

        if (customerUserErrors != null && customerUserErrors.isEmpty) {
          setState(() {
            error = "";
            isLoading = false;
          });

          Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.passwordVerification,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 0,
            backgroundColor: Colors.green.shade400,
            textColor: Colors.white,
            fontSize: 16.0,
          );
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

    final login = LoginRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: Text(
            widget.isResetPass == true
                ? AppLocalizations.of(context)!.resetPass
                : AppLocalizations.of(context)!.forgetPass,
          ),
        ),
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
                            padding: const EdgeInsets.only(top: 15, bottom: 0),
                            child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.enterEmail,
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  fontWeight: FontWeight.w600),
                            ))),
                        Padding(
                            padding: const EdgeInsets.only(
                                right: 10, left: 10, top: 20),
                            child: TextFormField(
                              controller: email,
                              validator: (value) {
                                return Validation().emailValidation(value);
                              },
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                  label:  Row(
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
                                        signUp();

                                        _focusNode.unfocus();
                                      }
                                    } else {}
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
                                  child: isLoading == false
                                      ? Text(
                                    AppLocalizations.of(context)!.reqForPass.toUpperCase(),
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
                error: (error, stackTrace) =>  Text(AppLocalizations.of(context)!.oops),
              );
            }))));
  }
}
