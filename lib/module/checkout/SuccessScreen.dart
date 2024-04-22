// SuccessScreen

import 'package:mobj_project/utils/cmsConfigue.dart';


class SuccessScreen extends ConsumerStatefulWidget {
  final String status;

  const SuccessScreen(this.status, {super.key});

  @override
  ConsumerState<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends ConsumerState<SuccessScreen> {
  @override
  void initState() {
    super.initState();
  }

  void redirectToDashboard() {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => const HomeScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => route.isCurrent);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => const HomeScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
              (route) => route.isCurrent);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
              elevation: 2,
              title: const Text(
                ""
              )),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.status == AppString.success
                          ? AppColors.green
                          : AppColors.red),
                  child: Icon(
                    widget.status == AppString.success
                        ? Icons.check
                        : Icons.close,
                    size: 150,
                    color: AppColors.whiteColor,
                  ),
                )),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.status == AppString.success
                      ? AppString.orderSuccess
                      : AppString.paymentFailed,
                  style: const TextStyle(
                      fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                widget.status == AppString.success
                    ?  Text(
                  AppLocalizations.of(context)!.thankYou,
                        style: const TextStyle(fontSize: 16.0),
                      )
                    : Container(),
                const SizedBox(height: 20.0),
                widget.status == AppString.success
                    ? ElevatedButton(
                        onPressed: () {
                          redirectToDashboard();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  AppDimension.buttonRadius)),
                          textStyle: const TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 10,
                              fontStyle: FontStyle.normal),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.continueShopping.toUpperCase(),
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                              fontWeight: FontWeight.bold),
                        ))
                    : Container()
              ]),
        ));
  }
}
