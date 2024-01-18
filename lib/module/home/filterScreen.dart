// // filterScreen
// import 'package:amazon_like_filter/props/applied_filter_model.dart';
// import 'package:amazon_like_filter/props/filter_item_model.dart';
// import 'package:amazon_like_filter/props/filter_list_model.dart';
// import 'package:amazon_like_filter/props/filter_props.dart';
// import 'package:amazon_like_filter/widgets/filter_widget.dart';
// import 'package:mobj_project/utils/cmsConfigue.dart';
//
// class FilterScreen extends ConsumerStatefulWidget {
//   final bool? logout;
//
//   const FilterScreen({Key? key, this.logout}) : super(key: key);
//
//   @override
//   ConsumerState<FilterScreen> createState() => _FilterScreenState();
// }
//
// class _FilterScreenState extends ConsumerState<FilterScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final user = ref.watch(userDataProvider);
//     final appInfoAsyncValue = ref.watch(appInfoProvider);
//     List<AppliedFilterModel> applied = [];
//
//     return appInfoAsyncValue.when(
//         data: (appInfo) => Scaffold(
//         appBar: AppBar(
//             elevation: 0,
//             backgroundColor: AppColors.whiteColor,
//             title: Text(appInfo.appName,
//                   style: const TextStyle(color: AppColors.blackColor)),
//              ),
//         bottomNavigationBar: MobjBottombar(
//           bgcolor: AppColors.whiteColor,
//           selcted_icon_color: AppColors.buttonColor,
//           unselcted_icon_color: AppColors.blackColor,
//           selectedPage: 1,
//           screen1: HomeScreen(),
//           screen2: SearchWidget(),
//           screen3: HomeScreen(),
//           screen4: ProfileScreen(),
//           ref: ref,
//         ),
//         body: user.when(
//             data: (user) {
//               List<UserModel> userlist = user.map((e) => e).toList();
//               return appInfoAsyncValue.when(
//                   data: (appInfo) => RefreshIndicator(
//                       // Wrap the list in a RefreshIndicator widget
//                       onRefresh: () async {
//                         ref.refresh(userDataProvider);
//                       },
//                       child: FilterWidget(
//                           filterProps: FilterProps(
//                         themeProps: ThemeProps(
//                             checkBoxTileThemeProps: CheckBoxTileThemeProps(
//                               activeCheckBoxColor: AppColors.green,
//                             ),
//                             dividerThickness: 5,
//                             searchBarViewProps: SearchBarViewProps(
//                               filled: false,
//                             )),
//                         onFilterChange: (value) {
//                           setState(() {
//                             applied = value;
//                           });
//                         },
//                         filters: [
//                           const FilterListModel(
//                             filterOptions: [
//                               FilterItemModel(
//                                   filterTitle: 'Education',
//                                   filterKey: 'education'),
//                               FilterItemModel(
//                                 filterTitle: 'Information Technology',
//                                 filterKey: 'it',
//                               ),
//                               FilterItemModel(
//                                   filterTitle: 'Sports', filterKey: 'sports'),
//                               FilterItemModel(
//                                   filterTitle: 'Transport',
//                                   filterKey: 'transport'),
//                             ],
//                             previousApplied: [],
//                             title: 'Industry',
//                             filterKey: 'industry',
//                           ),
//                           const FilterListModel(
//                             filterOptions: [
//                               FilterItemModel(
//                                   filterTitle: 'Utter Pradesh',
//                                   filterKey: 'up'),
//                               FilterItemModel(
//                                 filterTitle: 'Madhya Pradesh',
//                                 filterKey: 'mp',
//                               ),
//                               FilterItemModel(
//                                   filterTitle: 'Hariyana', filterKey: 'hr'),
//                               FilterItemModel(
//                                   filterTitle: 'Bihar', filterKey: 'bihar'),
//                             ],
//                             previousApplied: [],
//                             title: 'State',
//                             filterKey: 'state',
//                           )
//                         ],
//                       ))),
//                   error: (error, s) => SizedBox(),
//                   loading: () => SizedBox());
//             },
//             error: (error, s) => Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Text(error.toString()),
//                     const Center(
//                       child: ErrorHandling(
//                         error_type: "error",
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         primary: AppColors.buttonColor,
//                       ),
//                       onPressed: () {
//                         ref.refresh(userDataProvider);
//                       },
//                       child: const Text(
//                         AppString.refresh,
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: AppColors.whiteColor,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//             loading: () => SkeletonLoaderWidget())), loading: () => Container(),
//       error: (error, stackTrace) => Container(),
//     );
//   }
// }
