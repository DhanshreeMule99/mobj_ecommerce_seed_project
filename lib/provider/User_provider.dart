// User_provider
import 'package:mobj_project/utils/cmsConfigue.dart';

final userDataProvider = FutureProvider<List<UserModel>>((ref) async {
  return ref.watch(usersProvider).getUsers();
});
final userDetailsProvider =
    FutureProvider.family<ProfileModel, String>((ref, uid) async {
  return ref.watch(usersProvider).getUserInfo(uid.toString());
});
final profileDataProvider = FutureProvider<CustomerModel>((ref) async {
  return ref.watch(usersProvider).getProfile();
});
