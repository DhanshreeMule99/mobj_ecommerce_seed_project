import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobj_project/module/checkout/CheckoutScreen.dart';
import 'package:mobj_project/module/home/homeScreen.dart';
import 'package:mobj_project/module/profile/profileScreen.dart';
import 'package:mobj_project/module/wishlist/wishlishScreen.dart';
import 'package:mobj_project/provider/User_provider.dart';
import 'package:mobj_project/utils/themeProvider.dart';
import '../models/shared_preferences/SharedPreference.dart';
import '../module/categorie_screen/categorie_screen.dart';
import 'appColors.dart';
import 'commonAlert.dart';

class MobjBottombar extends StatefulWidget {
  final Color? bgcolor;
  final Color? selcted_icon_color;
  final Color? unselcted_icon_color;
  final int selectedPage;
  final Widget screen1;
  final Widget screen2;
  final Widget screen3;
  final Widget screen4;
  final WidgetRef? ref;

  const MobjBottombar(
      {Key? key,
      this.bgcolor,
      required this.selectedPage,
      this.selcted_icon_color,
      this.unselcted_icon_color,
      required this.screen1,
      required this.screen2,
      required this.screen3,
      required this.screen4,
      this.ref})
      : super(key: key);

  @override
  State<MobjBottombar> createState() => _Mobj_bottombarstate();
}

class _Mobj_bottombarstate extends State<MobjBottombar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String jwt_token = "";
  String userid = "";

  Future<bool> isLogin() async {
    final jwt = await SharedPreferenceManager().getToken();
    jwt_token = jwt;
    final uid = await SharedPreferenceManager().getUserId();
    final did = await SharedPreferenceManager().getDeviceId();
    userid = uid;

    if (jwt_token != '' || userid != '') {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.ref!.watch(themeProvider);

    return BottomNavigationBar(
      // selectedItemColor: widget.,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
            icon: FaIcon(
              FontAwesomeIcons.house,
              color: widget.selectedPage == 1
                  ? widget.selcted_icon_color
                  : theme.toString() == "true"
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
              size: 20.sp,
            ),
            label: ""),
        BottomNavigationBarItem(
          label: "",
          icon: Icon(
            Ionicons.grid,
            color: widget.selectedPage == 2
                ? widget.selcted_icon_color
                : theme.toString() == "true"
                    ? AppColors.whiteColor
                    : AppColors.blackColor,
            size: 20.sp,
          ),
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Ionicons.heart,
              color: widget.selectedPage == 3
                  ? widget.selcted_icon_color
                  : theme.toString() == "true"
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
              size: 24.sp,
            ),
            label: ""),
        BottomNavigationBarItem(
            icon: Icon(
              Ionicons.person,
              color: widget.selectedPage == 4
                  ? widget.selcted_icon_color
                  : theme.toString() == "true"
                      ? AppColors.whiteColor
                      : AppColors.blackColor,
              size: 20.sp,
            ),
            label: ""),
      ],
      showUnselectedLabels: false,
      showSelectedLabels: false,
      elevation: 0,
      onTap: (int tabIndex) {
        switch (tabIndex) {
          case 0:
            if (widget.selectedPage != 1) {
              Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const HomeScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                  (route) => route.isCurrent);
            } else {
              widget.ref!.refresh(userDataProvider);

              Navigator.pushAndRemoveUntil(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const HomeScreen(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                  (route) => route.isCurrent);
            }
            break;
          case 1:
            // isLogin().then((value) {
            //   if (value == true) {
            //     if (widget.selectedPage != 2) {
            Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const CategoriesScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                (route) => route.isFirst);
            //     }
            //   } else {
            //     CommonAlert.showAlertAndNavigateToLogin(context);
            //   }
            // });

            break;
          case 2:
            // if (widget.selectedPage != 3) {
            Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      WishlistScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
                (route) => route.isFirst);
            // }

            break;
          case 3:
            isLogin().then((value) {
              if (value == true) {
                if (widget.selectedPage != 3) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const ProfileScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                      (route) => route.isFirst);
                } else {
                  widget.ref!.refresh(profileDataProvider);

                  Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const ProfileScreen(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                      (route) => route.isFirst);
                }
              } else {
                CommonAlert.showAlertAndNavigateToLogin(context);
              }
            });
        }
      },
    );
  }
}
