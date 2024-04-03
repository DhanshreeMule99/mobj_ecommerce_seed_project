import 'package:mobj_project/utils/cmsConfigue.dart';

import '../models/shopifyModel/product/collectionProductModel.dart';
import '../models/shopifyModel/product/productReviewWiseModel.dart';
import '../models/shopifyModel/product/recommendedProduct.dart';
import '../module/home/collectionWiseProductScreen.dart';

final productDataProvider = FutureProvider<List<ProductModel>>((ref) async {
  return ref.watch(productsProvider).getProducts();
});

final orderDataProvider = FutureProvider<List<OrderModel>>((ref) async {
  return ref.watch(productsProvider).getOrder();
});
final cartDetailsDataProvider = FutureProvider<DraftOrderModel>((ref) async {
  return ref.watch(productsProvider).getCartDetails();
});
final productDetailsProvider =
    FutureProvider.family<ProductModel, String>((ref, pid) async {
  return ref.watch(productsProvider).getProductInfo(pid.toString());
});
final productRatingProvider =
    FutureProvider.family<ProductRatingModel, String>((ref, pid) async {
  return ref.watch(productsProvider).getProductRating(pid.toString());
});
final repeatOrderProvider =
    FutureProvider.family<DraftOrderModel, String>((ref, pid) async {
  return ref.watch(productsProvider).getRepeatOrderDetails(pid.toString());
});
final productReviewsProvider =
    FutureProvider.family<ReviewProductModels, String>((ref, pid) async {
  return ref.watch(productsProvider).getProductReviews(pid.toString());
});
final productRecommendedDataProvider =
    FutureProvider.family<List<RecommendedProductModel>, String>(
        (ref, pid) async {
  return ref.watch(productsProvider).getRecommendedProductInfo(pid.toString());
});
final productImageDataProvider =
    FutureProvider.family<List<ProductImage>, String>((ref, pid) async {
  return ref.watch(productsProvider).getProductImage(pid.toString());
});
final orderDetailsProvider =
    FutureProvider.family<OrderModel, String>((ref, pid) async {
  return ref.watch(productsProvider).getOrderInfo(pid.toString());
});
final productDataByCollectionProvider =
    FutureProvider.family<List<ProductModel>, String>((ref, cid) async {
  return ref.watch(productsProvider).getProductsByCollection(cid.toString());
});
