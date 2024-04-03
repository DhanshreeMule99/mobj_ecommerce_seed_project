import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:order_tracker/order_tracker.dart';

import '../../../utils/defaultValues.dart';

class OrderTrackingScreen extends StatefulWidget {
  @override
  _OrderTrackingScreenState createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {

  // Define the steps for the stepper
  List<TextDto> orderList = [
    TextDto(DefaultValues.orderPlaced, DefaultValues.orderPlacedDate),
    TextDto(DefaultValues.orderProcessed, DefaultValues.orderProcessedDate),
    TextDto(DefaultValues.pickedUpByCourier, DefaultValues.pickedUpByCourierDate),
  ];

  List<TextDto> shippedList = [
    TextDto(DefaultValues.orderShipped, DefaultValues.orderShippedDate),
    TextDto(DefaultValues.receivedInHub, null),
  ];

  List<TextDto> outOfDeliveryList = [
    TextDto(DefaultValues.outForDelivery, DefaultValues.outForDeliveryDate),
  ];

  List<TextDto> deliveredList = [
    TextDto(DefaultValues.orderDelivered, DefaultValues.orderDeliveredDate),
  ];

  @override
  void dispose() {
    // TODO: implement dispose
  super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(AppLocalizations.of(context)!.trackingTitle),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: OrderTracker(
          status: Status.order,
          activeColor: AppColors.green,
          inActiveColor: AppColors.greyShade200,
          orderTitleAndDateList: orderList,
          shippedTitleAndDateList: shippedList,
          outOfDeliveryTitleAndDateList: outOfDeliveryList,
          deliveredTitleAndDateList: deliveredList,
        ),
      ),
    );
  }
}
