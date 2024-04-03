import 'package:mobj_project/utils/cmsConfigue.dart';



class BookmarkedProductNotifier extends StateNotifier<List<ProductModel>> {
  BookmarkedProductNotifier() : super([]);

  void toggleBookmark(ProductModel opp) {
    final index = state.indexWhere((p) => p.id == opp.id);
    if (index >= 0) {
      state = List.of(state)..removeAt(index);
    } else {
      state = List.of(state)..add(opp);
    }
  }
}
