// skeleton_loader

import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'appColors.dart';

class SkeletonLoaderWidget extends StatefulWidget {
  @override
  State<SkeletonLoaderWidget> createState() => _SkeletonLoaderWidgetState();
}

class _SkeletonLoaderWidgetState extends State<SkeletonLoaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SkeletonLoader(
      builder: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: AppColors.whiteColor,
              radius: 30,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: AppColors.whiteColor,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 12,
                    color: AppColors.whiteColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      items: 10,
      period: Duration(seconds: 2),
      highlightColor: AppColors.grey,
      direction: SkeletonDirection.ltr,
    ));
  }
}
