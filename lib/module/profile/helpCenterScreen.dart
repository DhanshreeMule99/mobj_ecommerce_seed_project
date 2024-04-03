// helpCenterScreen
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:mobj_project/utils/defaultValues.dart';

class HelpCenterScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              elevation: 0,
              title: IconButton(
                icon: const Icon(
                  Icons.close,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              automaticallyImplyLeading: false,
            ),

            body: WillPopScope(
              onWillPop: () async {
                // Disable the back button
                return false;
              },
              child: ref.watch(productDataProvider).when(
                data: (profile) {
                  return appInfoAsyncValue.when(
                      data: (appInfo) => Tawk(
                    directChatLink:
                    appInfo.tawkURL,
                    visitor: TawkVisitor(
                      name: "${DefaultValues.defaultCustomerName} ",
                      email: DefaultValues.defaultCustomerEmail,
                    ),
                    onLoad: () {
                    },
                    onLinkTap: (String url) {
                    },
                    placeholder:  Center(
                      child: Text(AppLocalizations.of(context)!.pleaseWait),
                    ),
                  ),  error: (error, s) => const SizedBox(),
                      loading: () => const SizedBox());
                },
                  error: (error, s) =>
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        children: [
                          // Text(error.toString()),
                          const Center(
                            child: ErrorHandling(
                              error_type: "error",
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: AppColors.buttonColor,),

                            onPressed: () {
                            },
                            child:  Text(
                              AppLocalizations.of(context)!.refresh,
                              style: TextStyle(fontSize: 16,
                                color: AppColors.whiteColor,),

                            ),
                          )
                        ],
                      ),
                  loading: () => SkeletonLoaderWidget())
              ),
            ));
  }
}
