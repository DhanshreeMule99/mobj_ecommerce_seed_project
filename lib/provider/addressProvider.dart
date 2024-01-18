import 'package:mobj_project/utils/cmsConfigue.dart';


final addressDataProvider = FutureProvider<List<DefaultAddressModel>>((ref) async {
  return ref.watch(addressProvider).getAddress();
});