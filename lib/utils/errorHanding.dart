// skeleton_loader

import 'package:flutter/material.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

import 'appString.dart';

class ErrorHandling extends StatefulWidget {
  final String error_type;

  const ErrorHandling({
    Key? key,
    required this.error_type,
  });

  @override
  State<ErrorHandling> createState() => _ErrorHandlingState();
}

class _ErrorHandlingState extends State<ErrorHandling> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.error_type==AppString.noDataError?Image.asset(
           "assets/Nodata.png",
          width: MediaQuery.of(context).size.height/3,
        ):Image.asset(
           "assets/server_error.png",
          width: MediaQuery.of(context).size.height/3,
        ),
      ],
    );
  }
}
