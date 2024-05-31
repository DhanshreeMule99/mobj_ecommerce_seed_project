import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobj_project/module/home/homeCarousel.dart';
import 'package:mobj_project/module/wishlist/wishlishScreen.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';

class ContactUs extends ConsumerStatefulWidget {
  final bool? logout;

  const ContactUs({Key? key, this.logout}) : super(key: key);

  @override
  ConsumerState<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends ConsumerState<ContactUs> {
  late Future<Map<String, dynamic>> contactDetails;

  @override
  void initState() {
    super.initState();
    contactDetails = fetchContactDetails();
  }

  Future<Map<String, dynamic>> fetchContactDetails() async {
    String baseUrl = AppConfigure.adminPanelUrl;
    final response = await http.get(Uri.parse("$baseUrl/api/contant-us"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['attributes'];
      log("data from response is $data");
      return {
        'mobile_number': data['mobile_number'],
        'email': data['email'],
        'address': data['address'],
        'instagram_url': data['instagram_url'],
        'facebook_url': data['facebook_url'],
        'twitter_url': data['twitter_url'],
        'whats_app_number': data['whats_app_number'],
      };
    } else {
      throw Exception('Failed to load contact details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        surfaceTintColor: Theme.of(context).colorScheme.secondary,
        title: Text(AppLocalizations.of(context)!.contactUs),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.chevron_left_rounded,
            size: 25.sp,
          ),
        ),
      ),
      bottomNavigationBar: MobjBottombar(
        bgcolor: AppColors.whiteColor,
        selcted_icon_color: AppColors.buttonColor,
        unselcted_icon_color: AppColors.blackColor,
        selectedPage: 4,
        screen1: const HomeScreen(),
        screen2: SearchWidget(),
        screen3: WishlistScreen(),
        screen4: const ProfileScreen(),
        ref: ref,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: FutureBuilder<Map<String, dynamic>>(
            future: contactDetails,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                );
              } else {
                final data = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${AppLocalizations.of(context)!.addressAppBar} : ',
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Text(
                            data['address'],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              _launchPhoneDialer(data['mobile_number']);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.mobileNo} :',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                Text(
                                  data['mobile_number'],
                                  // style: TextStyle(
                                  //   color: Colors.blue,
                                  //   decoration: TextDecoration.underline,
                                  // ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          // GestureDetector(
                          //   onTap: () {
                          //     _launchWhatsApp(data['whats_app_number']);
                          //   },
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Text(
                          //         'WhatsApp Number:',
                          //         style:
                          //             Theme.of(context).textTheme.headlineLarge,
                          //       ),
                          //       Text(
                          //         data['whats_app_number'],
                          //         // style: TextStyle(
                          //         //   color: Colors.blue,
                          //         //   decoration: TextDecoration.underline,
                          //         // ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              _launchEmail(data['email']);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.email} :',
                                  style:
                                      Theme.of(context).textTheme.headlineLarge,
                                ),
                                Text(
                                  data['email'],
                                  // style: TextStyle(
                                  //   color: Colors.blue,
                                  //   decoration: TextDecoration.underline,
                                  // ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            AppLocalizations.of(context)!.followUs,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          Row(
                            children: [
                              IconButton(
                                color: AppColors.buttonColor,
                                icon: const FaIcon(FontAwesomeIcons.facebook),
                                onPressed: () {
                                  _launchURL(data['facebook_url']);
                                },
                              ),
                              IconButton(
                                color: AppColors.buttonColor,
                                icon: const FaIcon(FontAwesomeIcons.instagram),
                                onPressed: () {
                                  _launchURL(data['instagram_url']);
                                },
                              ),
                              IconButton(
                                color: AppColors.buttonColor,
                                icon: const FaIcon(FontAwesomeIcons.twitter),
                                onPressed: () {
                                  _launchURL(data['twitter_url']);
                                },
                              ),
                              IconButton(
                                color: AppColors.buttonColor,
                                icon: const FaIcon(FontAwesomeIcons.whatsapp),
                                onPressed: () {
                                  _launchWhatsApp(data['whats_app_number']);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  void _launchPhoneDialer(String number) async {
    final Uri telUrl = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(telUrl)) {
      await launchUrl(telUrl);
    } else {
      throw 'Could not launch $telUrl';
    }
  }

  void _launchWhatsApp(String number) async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/$number");
    if (await canLaunchUrl(whatsappUrl)) {
      await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  void _launchEmail(String email) async {
    final Uri emailUrl = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Contact&body=Hello',
    );
    if (await canLaunchUrl(emailUrl)) {
      await launchUrl(emailUrl);
    } else {
      throw 'Could not launch $emailUrl';
    }
  }

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
