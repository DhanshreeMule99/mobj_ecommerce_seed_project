import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/shopifyModel/shared_preferences/SharedPreference.dart';
import '../provider/productProvider.dart';
import '../services/shopifyServices/restAPIServices/product/productRepository.dart';
import 'appColors.dart';
import 'appString.dart';
import 'cmsConfigue.dart';
import 'commonAlert.dart';

class RatingAlert extends StatelessWidget {
  final Function(double rating) onRatingSelected;
  final Function() onsubmit;
  final String pid;
  final double user_rating;
  final review = TextEditingController();
  final header = TextEditingController();
  final WidgetRef ref;
  int rating = 1;
  RatingAlert(
      {Key? key,
      required this.onRatingSelected,
      required this.pid,
      required this.onsubmit,
      required this.user_rating,
      required this.ref})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

     
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.rateUs),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Text(user_rating.toString()),
          TextField(
            controller: header,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.titleReview),
          ),
          TextField(
            controller: review,
            decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.giveReview),
          ),
          // Text(AppString.rateUs),
          const SizedBox(height: 16),
          RatingBar.builder(
            initialRating: user_rating,
            minRating: 1,
            maxRating: 5,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rate) {
              rating = rate.toInt();
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () async {
             String customername = await SharedPreferenceManager().getname();
               String customeremail = await SharedPreferenceManager().getemail();
            String uid = await SharedPreferenceManager().getUserId();
            CommonAlert.show_loading_alert(context);
              Map<String, dynamic> body = AppConfigure.bigCommerce
            ?
            {
              "title": review.text,
              "text": header.text,
              "status": "pending",
              "rating": rating,
              "email": customeremail,
              "name": customername,
              "date_reviewed": "2019-03-24T14:15:22Z"
              }
            
            : {
              "data": {
                "body": review.text,
                "heading": header.text,
                "state": "approved",
                "is_verified": true,
                "customer_id": uid.toString(),
                "external_product_id": pid,
                "rating": rating
              }
            };
            ProductRepository().addProductReview(body, pid ).then((value) async {
              Navigator.of(context).pop();
              if (value == AppString.success) {
                ref.refresh(cartDetailsDataProvider);
                ref.refresh(productDetailsProvider(pid));
                ref.refresh(productReviewsProvider(pid));
                ref.refresh(productRatingProvider(pid));
                Navigator.of(context).pop();

                Fluttertoast.showToast(
                    msg: AppLocalizations.of(context)!.addReviewSuccess,
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 0,
                    backgroundColor: AppColors.green,
                    textColor: AppColors.whiteColor,
                    fontSize: 16.0);
  ref.refresh(productReviewsProvider(pid));

              } else {
                Navigator.of(context).pop();

                Fluttertoast.showToast(
                    msg: value.toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 0,
                    fontSize: 16.0);
              }
            });
          },
          child: Text(AppLocalizations.of(context)!.submit),
        ),
      ],
    );
  }
}
