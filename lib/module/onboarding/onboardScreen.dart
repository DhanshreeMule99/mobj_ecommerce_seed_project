// onboardScreen
// // onboardScreen
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobj_project/user_auth/login/loginScreen.dart';
import 'package:mobj_project/user_auth/login/loginWithOTPScreen.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:onboarding/onboarding.dart';

class onboardScreen extends ConsumerStatefulWidget {
  @override
  onboardScreenState createState() => onboardScreenState();
}

class onboardScreenState extends ConsumerState<onboardScreen> {
  late Material materialButton;
  late int index;

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: defaultSkipButtonColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () async {
          await SharedPreferenceManager().setDeviceId(1);
          Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const HomeScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ));
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            AppString.skip,
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Material get done {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: AppColors.green,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () async {
          await SharedPreferenceManager().setDeviceId(1);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        },
        child: const Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            AppString.done,
            style: defaultProceedButtonTextStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);
    final onboardingPagesList = [
      PageModel(
          widget: appInfoAsyncValue.when(
              data: (appInfo) => DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.blackColor,
                      border: Border.all(
                        width: 0.0,
                        color: AppColors.transparent,
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 45.0,
                              vertical: 90.0,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: appInfo.logoImagePath,
                              placeholder: (context, url) => Container(
                                height: 200,
                                width: 200,
                                color: AppColors.greyShade200,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 45.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Product Insights'.toUpperCase(),
                                style: pageTitleStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 45.0, vertical: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Get to know your desired products inside out. Our comprehensive product descriptions, accompanied by vibrant images, help you make informed decisions. Stay ahead of the curve with the latest trends and tech specs",
                                style: pageInfoStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Container())),
      PageModel(
          widget: appInfoAsyncValue.when(
              data: (appInfo) => DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.blackColor,
                      border: Border.all(
                        width: 0.0,
                        color: AppColors.transparent,
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 45.0,
                              vertical: 90.0,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: appInfo.logoImagePath,
                              placeholder: (context, url) => Container(
                                height: 200,
                                width: 200,
                                color: AppColors.greyShade200,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 45.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Effortless Checkout'.toUpperCase(),
                                style: pageTitleStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 45.0, vertical: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "We believe in a hassle-free checkout process. Enjoy a seamless transaction experience with multiple payment options and a secure payment gateway. Your satisfaction is our top priority.",
                                style: pageInfoStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Container())),
      PageModel(
          widget: appInfoAsyncValue.when(
              data: (appInfo) => DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.blackColor,
                      border: Border.all(
                        width: 0.0,
                        color: AppColors.transparent,
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: ScrollController(),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 45.0,
                              vertical: 90.0,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: appInfo.logoImagePath,
                              placeholder: (context, url) => Container(
                                height: 200,
                                width: 200,
                                color: AppColors.greyShade200,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 45.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Exclusive Deals and Discounts'.toUpperCase(),
                                style: pageTitleStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 45.0, vertical: 10.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Unlock savings galore! Dive into a world of exclusive deals and discounts tailored just for you. Our app keeps you in the loop on the hottest offers, ensuring you never miss a chance to snag your favorite items at unbeatable prices.",
                                style: pageInfoStyle,
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Container())),
    ];
    return SafeArea(
        child: appInfoAsyncValue.when(
            data: (appInfo) => Scaffold(
                  backgroundColor: AppColors.blackColor,
                  body: Onboarding(
                    pages: onboardingPagesList,
                    onPageChange: (int pageIndex) {
                      index = pageIndex;
                    },
                    startPageIndex: 0,
                    footerBuilder:
                        (context, dragDistance, pagesLength, setIndex) {
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          color: AppColors.blackColor,
                          border: Border.all(
                            width: 0.0,
                            color: AppColors.transparent,
                          ),
                        ),
                        child: ColoredBox(
                          color: AppColors.blackColor,
                          child: Padding(
                            padding: const EdgeInsets.all(45.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomIndicator(
                                  netDragPercent: dragDistance,
                                  pagesLength: pagesLength,
                                  indicator: Indicator(
                                    activeIndicator: const ActiveIndicator(
                                        color: AppColors.whiteColor,
                                        borderWidth: 2.5),
                                    closedIndicator: const ClosedIndicator(
                                        color: AppColors.buttonColor,
                                        borderWidth: 2.5),
                                    indicatorDesign: IndicatorDesign.polygon(
                                        polygonDesign: PolygonDesign(
                                            polygon: DesignType.polygon_circle,
                                            polygonRadius: 7)),
                                  ),
                                ),
                                index == pagesLength - 1
                                    ? done
                                    : _skipButton(setIndex: setIndex)
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text('${AppString.error}: $error')));
  }
}
