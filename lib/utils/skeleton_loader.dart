// skeleton_loader

import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'appColors.dart';

class SkeletonLoaderWidget extends StatefulWidget {
  const SkeletonLoaderWidget({super.key});

  @override
  State<SkeletonLoaderWidget> createState() => _SkeletonLoaderWidgetState();
}

class _SkeletonLoaderWidgetState extends State<SkeletonLoaderWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: SkeletonLoader(
      builder: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          children: <Widget>[
            const CircleAvatar(
              backgroundColor: AppColors.whiteColor,
              radius: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: AppColors.whiteColor,
                  ),
                  const SizedBox(height: 10),
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
      period: const Duration(seconds: 2),
      highlightColor: AppColors.grey,
      direction: SkeletonDirection.ltr,
    ));
  }
}
