import 'package:mobj_project/utils/cmsConfigue.dart';


final notificationSettingProvider =
    ChangeNotifierProvider((ref) => NotificationProvider());

class NotificationProvider extends ChangeNotifier {
  int userId = 0;
  bool allPreference = false;
  bool emailPreference = false;
  bool interestPreference = false;
  bool cityPreference = false;
  bool radiusPreference = true;
  String radius = "21";
  bool isLoading = false;
//TODO list API integration
  // final apiUrl = APIConstants.NOTIFICATION_SETTING;

  // Future<void> fetchPreferences() async {
  //   isLoading = true;
  //   notifyListeners();
  //
  //   final apiUrl = APIConstants.NOTIFICATION_SETTING;
  //   SharedPreferences sharedPreferences =
  //   await SharedPreferences.getInstance();
  //   final user_id = sharedPreferences.getString("userid") ?? "";
  //   final response =
  //   await ApiManager.get(apiUrl + "/" + user_id.toString());
  //
  //   isLoading = false;
  //   notifyListeners();
  //
  //   if (response.statusCode == 200) {
  //     final jsonResponse = json.decode(response.body);
  //     final data = jsonResponse['data'];
  //
  //     if (data != null && data.isNotEmpty) {
  //
  //       allPreference = data['all_preference'];
  //       emailPreference = data['email_preference'];
  //       interestPreference = data['interest_preference'];
  //       cityPreference = data['city_preference'];
  //       radiusPreference = data['radius_preference'];
  //       radius = data['radius'].toString();
  //     }
  //   } else {
  //     print('Failed to fetch preferences. Error: ${response.reasonPhrase}');
  //   }
  // }

  void updatePreference(bool value, String preferenceName) {
    switch (preferenceName) {
      case 'all':
        allPreference = value;
        if (value == true) {
          // If 'All Preferences' is enabled, enable all other switches
          emailPreference = true;
          interestPreference = true;
          cityPreference = true;
          radiusPreference = true;
        } else {
          emailPreference = false;
          interestPreference = false;
          cityPreference = false;
          radiusPreference = false;
        }
        break;
      case 'email':
        emailPreference = value;
        if (!value) {
          // If 'Email Preference' is disabled, disable 'All Preferences'
          allPreference = false;
        }
        break;
      case 'interest':
        interestPreference = value;
        if (!value) {
          allPreference = false;
        }
        break;
      case 'city':
        cityPreference = value;
        if (!value) {
          allPreference = false;
          radiusPreference = false;
        }
        break;
      case 'radius':
        radiusPreference = value;
        if (!value) {
          // If 'Radius Preference' is disabled, disable 'City Preference'
          // cityPreference = false;
          allPreference = false;
        } else {
          // If 'Radius Preference' is enabled, enable 'City Preference'
          cityPreference = true;
          // allPreference = false;
        }
        break;
    }
    notifyListeners();
  }

  void updateRadius(double value) {
    radius = value.toString();
    notifyListeners();
  }

// Future<void> savePreferences() async {
//   SharedPreferences sharedPreferences =
//   await SharedPreferences.getInstance();
//   final user_id = sharedPreferences.getString("userid") ?? "";
//   final preferences = {
//     'user_id': user_id.toString(),
//     'all_preference': allPreference,
//     'email_preference': emailPreference,
//     'interest_preference': interestPreference,
//     'city_preference': cityPreference,
//     'radius_preference': radiusPreference,
//     'radius': double.parse(radius).round(),
//   };
//
//   isLoading = true;
//   notifyListeners();
//
//   // final response = await ApiManager.post(apiUrl, json.encode(preferences));
//
//   isLoading = false;
//   notifyListeners();
//
//   if (response.statusCode == 200) {
//     Fluttertoast.showToast(
//         msg: "Preferences Saved",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   } else {
//     print('Failed to save preferences. Error: ${response.reasonPhrase}');
//   }
// }
}

class NotificationSettingScreen extends ConsumerStatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  NotificationSettingScreenState createState() =>
      NotificationSettingScreenState();
}

class NotificationSettingScreenState
    extends ConsumerState<NotificationSettingScreen> {
  bool isFetching = true;

  @protected
  @mustCallSuper
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notification = ref.read(notificationSettingProvider);
      // await notification.fetchPreferences();
      setState(() {
        isFetching = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return appInfoAsyncValue.when(
        data: (appInfo) => Scaffold(
              appBar: AppBar(
                elevation: 0,
                actions: [],
                title:  Text(
                  AppLocalizations.of(context)!.notificationSetting,
                ),
              ),
              bottomNavigationBar: MobjBottombar(
                bgcolor: Colors.white,
                selcted_icon_color: AppColors.buttonColor,
                unselcted_icon_color: AppColors.blackColor,
                selectedPage: 3,
                screen1: const HomeScreen(),
                screen2: const SearchWidget(),
                screen3: const HomeScreen(),
                screen4: const ProfileScreen(),
                ref: ref,
              ),
              body: isFetching
                  ? _buildLoader()
                  : _buildPreferencesList(appInfo.primaryColorValue),
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Text('Error: $error'));
  }

  Widget _buildLoader() {
    return Center(
      child: SkeletonLoaderWidget(),
    );
  }

  Widget _buildPreferencesList(Color? color) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Consumer(
        builder: (context, watch, _) {
          final notification = ref.watch(notificationSettingProvider);

          return ListView(
            children: [
              _buildToggleSwitch(
                  'All Preferences',
                  notification.allPreference,
                  (value) => notification.updatePreference(
                        value,
                        'all',
                      ),
                  'Customize your notifications easily with All Preferences! Personalize email, FCM, and interest-based alerts for a personalized experience.'),
              _buildToggleSwitch(
                  'Email Preference',
                  notification.emailPreference,
                  (value) => notification.updatePreference(value, 'email'),
                  'Get mail notifications through notifications only.'),
              _buildToggleSwitch(
                  'Interest Preference',
                  notification.interestPreference,
                  (value) => notification.updatePreference(value, 'interest'),
                  'Receive notifications based on your selected preferences in the Opportunity Preference.'),
              _buildToggleSwitch(
                  'City Preference',
                  notification.cityPreference,
                  (value) => notification.updatePreference(value, 'city'),
                  'Receive notifications based on your preferred city or location.'),
              _buildToggleSwitch(
                  'Radius Preference',
                  notification.radiusPreference,
                  (value) => notification.updatePreference(value, 'radius'),
                  'Select a distance, and receive notifications within that specified range'),
              Slider(
                value: double.parse(notification.radius),
                min: 0.0,
                max: 10000,
                divisions: 100,
                onChanged: notification.radiusPreference
                    ? (value) => notification.updateRadius(value)
                    : null, // Disable the slider if 'Radius Preference' is disabled
              ),
              ListTile(
                title:  Text(AppLocalizations.of(context)!.locRadius),
                trailing: Text(
                  "${double.parse(notification.radius).toStringAsFixed(0)}/KM",
                ),
                onTap: () {
                  // Implement the logic to update the radius
                },
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: ElevatedButton(
                    onPressed: notification.isLoading
                        ? null
                        : () {
                            // notification.savePreferences();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimension.buttonRadius)),
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontStyle: FontStyle.normal),
                    ),
                    child: notification.isLoading
                        ? CircularProgressIndicator()
                        : Text(
                      AppLocalizations.of(context)!.savePref.toUpperCase(),
                            style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold),
                          )),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildToggleSwitch(
      String title, bool value, Function(bool) onChanged, String message) {
    return ListTile(
      title: Tooltip(
        message: message,
        child: Align(
          alignment: Alignment.topLeft,
          child: TextButton(
            // <-- TextButton
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                ),
                const SizedBox(
                  width: 5,
                ),
                const Icon(
                  Icons.info,
                  // color: app_colors.grey_shade,
                ),
              ],
            ),
          ),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
