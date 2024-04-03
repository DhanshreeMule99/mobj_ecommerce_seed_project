import 'package:mobj_project/module/address/addressListScreen.dart';
import 'package:mobj_project/module/paymentGatways/razorpay/paymentHandler.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../provider/addressProvider.dart';
import '../../utils/currentLocations.dart';

class AddressScreen extends ConsumerStatefulWidget {
  final DefaultAddressModel? address;
  final bool isCheckout;
  final int? amount;
  final String? mobile;
  final String addressId;

  const AddressScreen(
      {super.key,
      required this.addressId,
      this.address,
      required this.isCheckout,
      this.amount,
      this.mobile});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  TextEditingController nickAddressController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  bool loader = false;
  String error = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _locationService = CurrentLocation();
  String address = "";
  int selectedAddressIndex = 0;
  String selectedOption = AppString.home;

  currentAddress() async {
    final permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      _locationService.getCurrentAddress().then((value) {
        if (mounted)
          setState(() {
            address = value;
          });
      });
    } else {
      _showLocationPermissionAlert();
    }
  }

  Future<void> _showLocationPermissionAlert() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.locationReq),
          content: Text(AppLocalizations.of(context)!.grantPermission),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the alert
                await openAppSettings(); // Open app settings
              },
              child: Text(AppLocalizations.of(context)!.openSetting),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the alert
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
          ],
        );
      },
    );
  }

  // Validation function for the address field
  String? validateAddress(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.addressValidationErrorMessage;
    }
    return null;
  }

  // Validation function for the city field
  String? validateCity(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.cityValidationErrorMessage;
    }
    return null;
  }

  // Validation function for the postal code field
  String? validatePostalCode(String value) {
    if (value.isEmpty) {
      return AppLocalizations.of(context)!.postalCodeValidationErrorMessage;
    }
    return null;
  }

  addOrUpdateAddress() async {
    setState(() {
      loader = true;
    });
    List<String> addressParts = address.split(', ');
    String residence = '';
    String city = '';
    String postalCode = '';
    String country = '';

    if (addressParts.length == 4) {
      residence = addressParts[0];
      city = addressParts[1];
      postalCode = addressParts[2];
      country = addressParts[3];
    }

    if ((city.toLowerCase() == 'pune' &&
            country.trim().toLowerCase() == 'india' &&
            selectedAddressIndex == 0) ||
        (countryController.text.trim().toLowerCase() == "india" &&
            cityController.text.trim().toLowerCase() == "pune" &&
            selectedAddressIndex == 1)) {
      final body = {
        "address1":
            selectedAddressIndex == 1 ? addressController.text : residence,
        "address2": "",
        "Company": "",
        "first_name": firstNameController.text,
        "last_name": selectedOption,
        "city": selectedAddressIndex == 1 ? cityController.text : city,

        "phone": phoneController.text,
        "province": "",
        "country": selectedAddressIndex == 1 ? countryController.text : country,
        "zip": selectedAddressIndex == 1 ? zipController.text : postalCode,
        "name": "",
        "province_code": "",
        "country_code": "IN",
        "country_name":
            selectedAddressIndex == 1 ? countryController.text : country,
        "default": true
        // "name":nickAddressController.text
      };
      print('sending this address id ${widget.addressId}');
      AddressRepository()
          .editAddress(
        body,
        widget.address != null ? widget.addressId.toString() : "",
      )
          .then((value) async {
        if (value.runtimeType != String) {
          setState(() {
            error = "";
            loader = false;
          });

          Fluttertoast.showToast(
            msg: widget.address != null
                ? AppLocalizations.of(context)!.updateAddress
                : AppLocalizations.of(context)!.addressAdded,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 0,
            backgroundColor: AppColors.green,
            textColor: AppColors.whiteColor,
            fontSize: 16.0,
          );
          ref.refresh(addressDataProvider);
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  AddressListScreen(
                isCheckout: widget.isCheckout,
                amount: widget.amount,
                mobile: widget.mobile,
              ),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        } else {
          setState(() {
            error = value;
            loader = false;
          });
        }
      });
    } else {
      setState(() {
        error = AppLocalizations.of(context)!.locationError;
        loader = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    if (widget.address != null) {
      selectedOption = widget.address!.lastName;
      firstNameController.text = widget.address!.firstName;
      selectedAddressIndex = 1;
      // lastNameController.text = widget.address!.lastName;
      addressController.text = widget.address!.address1;
      cityController.text = widget.address!.city;
      countryController.text = widget.address!.country;
      zipController.text = widget.address!.zip;
      phoneController.text = widget.address!.phone;
    }
    currentAddress();

    super.initState();
  }

  InputDecoration buildInputDecoration(String labelText) {
    return InputDecoration(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(labelText),
          const Text(
            '*',
            style: TextStyle(color: AppColors.red, fontSize: 20),
          ),
        ],
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimension.buttonRadius),
        ),
        borderSide: BorderSide(
          color: AppColors.blue,
          width: 1.5,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimension.buttonRadius),
        ),
        borderSide: BorderSide(
          color: AppColors.blue,
          width: 1.5,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(AppDimension.buttonRadius),
        ),
        borderSide: BorderSide(
          color: AppColors.blue,
          width: 1.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return appInfoAsyncValue.when(
        data: (appInfo) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context)!
                  .addressLabel
                  .replaceAll(":", "")),
              elevation: 1,
            ),
            body: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // TextFormField(
                          //   controller: nickAddressController,
                          //   decoration: buildInputDecoration(
                          //       AppString.nickAddressLabel),
                          //   validator: (value) {
                          //     if (value!.isEmpty) {
                          //       return AppString.nickAddressValidationMsg;
                          //     }
                          //     return null;
                          //   },
                          // ),
                          Text(
                            AppLocalizations.of(context)!.saveAddress,
                            style: TextStyle(
                              fontSize:
                                  0.05 * MediaQuery.of(context).size.width,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10),
                          Wrap(
                            children: [
                              ChoiceChip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimension.buttonRadius),
                                ),
                                label: Text(
                                  AppLocalizations.of(context)!.home,
                                  style: TextStyle(
                                      color: selectedOption == AppString.home
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor),
                                ),
                                selected: selectedOption == AppString.home,
                                selectedColor: AppColors.green,
                                onSelected: (isSelected) {
                                  setState(() {
                                    selectedOption =
                                        isSelected ? AppString.home : '';
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              ChoiceChip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimension.buttonRadius),
                                ),
                                label: Text(
                                    AppLocalizations.of(context)!.office,
                                    style: TextStyle(
                                        color:
                                            selectedOption == AppString.office
                                                ? AppColors.whiteColor
                                                : AppColors.blackColor)),
                                selected: selectedOption == AppString.office,
                                selectedColor: AppColors.green,
                                onSelected: (isSelected) {
                                  setState(() {
                                    selectedOption =
                                        isSelected ? AppString.office : '';
                                  });
                                },
                              ),
                              SizedBox(width: 10),
                              ChoiceChip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppDimension.buttonRadius),
                                ),
                                label: Text(
                                  AppLocalizations.of(context)!.other,
                                  style: TextStyle(
                                      color: selectedOption == AppString.other
                                          ? AppColors.whiteColor
                                          : AppColors.blackColor),
                                ),
                                selected: selectedOption == AppString.other,
                                selectedColor: AppColors.green,
                                onSelected: (isSelected) {
                                  setState(() {
                                    selectedOption =
                                        isSelected ? AppString.other : '';
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.contactDetails}:',
                            style: TextStyle(
                              fontSize:
                                  0.05 * MediaQuery.of(context).size.width,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 0, right: 0),
                              child: Card(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimension.buttonRadius),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          TextFormField(
                                            controller: firstNameController,
                                            keyboardType: TextInputType.text,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'.*'))
                                            ],
                                            decoration: buildInputDecoration(
                                                AppLocalizations.of(context)!
                                                    .personNameLabel),
                                            validator: (value) {
                                              return Validation()
                                                  .nameValidation(value);
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // TextFormField(
                                          //   controller: lastNameController,
                                          //   keyboardType: TextInputType.text,
                                          //   inputFormatters: [
                                          //     FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                          //   ],
                                          //   decoration:
                                          //       buildInputDecoration(AppString.lastNameLabel),
                                          //   validator: (value) {
                                          //     return Validation().nameValidation(value);
                                          //   },
                                          // ),
                                          // const SizedBox(
                                          //   height: 10,
                                          // ),
                                          TextFormField(
                                            controller: phoneController,
                                            validator: (value) {
                                              return Validation()
                                                  .validateMobileNo(value!);
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            decoration: buildInputDecoration(
                                                AppLocalizations.of(context)!
                                                    .phoneLabel),
                                            keyboardType: TextInputType.phone,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      )))),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${AppLocalizations.of(context)!.useMy}:',
                            style: TextStyle(
                              fontSize:
                                  0.05 * MediaQuery.of(context).size.width,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 0, right: 0),
                              child: Card(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimension.buttonRadius),
                                  ),
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      child: Row(
                                        children: [
                                          Radio(
                                            value: 0,
                                            groupValue: selectedAddressIndex,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedAddressIndex = value!;
                                              });
                                            },
                                          ),
                                          Expanded(
                                              child: Text(address != ""
                                                  ? address
                                                  : AppLocalizations.of(
                                                          context)!
                                                      .loading))
                                        ],
                                      )))),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 10, bottom: 10, right: 0),
                              child: Center(
                                  child: Text(
                                "Or",
                                style: TextStyle(
                                  fontSize:
                                      0.05 * MediaQuery.of(context).size.width,
                                  fontWeight: FontWeight.w700,
                                ),
                              ))),
                          Text(
                            '${AppLocalizations.of(context)!.addAddress}:',
                            style: TextStyle(
                              fontSize:
                                  0.05 * MediaQuery.of(context).size.width,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Card(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    AppDimension.buttonRadius),
                              ),
                              child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(children: [
                                    Radio(
                                      value: 1,
                                      groupValue: selectedAddressIndex,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedAddressIndex = value!;
                                        });
                                      },
                                    ),
                                    Expanded(
                                        child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: addressController,
                                          decoration: buildInputDecoration(
                                              AppLocalizations.of(context)!
                                                  .addressLabel),
                                          validator: (value) {
                                            if (value!.isEmpty &&
                                                selectedAddressIndex == 1) {
                                              return AppString
                                                  .addressValidationMsg;
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: cityController,
                                          decoration: buildInputDecoration(
                                              AppLocalizations.of(context)!
                                                  .cityLabel),
                                          validator: (value) {
                                            if (value!.isEmpty &&
                                                selectedAddressIndex == 1) {
                                              return AppString
                                                  .cityValidationMsg;
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: countryController,
                                          decoration: buildInputDecoration(
                                              AppLocalizations.of(context)!
                                                  .countryLabel),
                                          validator: (value) {
                                            if (value!.isEmpty &&
                                                selectedAddressIndex == 1) {
                                              return AppString
                                                  .countryValidationMsg;
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextFormField(
                                          controller: zipController,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          keyboardType: TextInputType.phone,
                                          decoration: buildInputDecoration(
                                              AppLocalizations.of(context)!
                                                  .zipLabel),
                                          validator: (value) {
                                            if (value!.isEmpty &&
                                                selectedAddressIndex == 1) {
                                              return AppString.zipValidationMsg;
                                            } else if ((value.length != 6 ||
                                                    !RegExp(r'^[0-9]+$')
                                                        .hasMatch(value)) &&
                                                selectedAddressIndex == 1) {
                                              return AppString.validZipCode;
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    )),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ]))),
                          SizedBox(
                            height: 15,
                          ),
                          error != ""
                              ? Center(
                                  child: Text(
                                  error,
                                  style: const TextStyle(
                                    color: AppColors.red,
                                  ),
                                ))
                              : Container(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(5, 35, 5, 10),
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    loader == false) {
                                  addOrUpdateAddress();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appInfo.primaryColorValue,
                                minimumSize: Size.fromHeight(50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        AppDimension.buttonRadius)),
                                textStyle: const TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 10,
                                    fontStyle: FontStyle.normal),
                              ),
                              child: loader == false
                                  ? Text(
                                      widget.address != null
                                          ? AppLocalizations.of(context)!
                                              .updateAddressTitle
                                              .toUpperCase()
                                          : AppLocalizations.of(context)!
                                              .addAddressTitle
                                              .toUpperCase(),
                                      style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const CircularProgressIndicator(
                                      color: AppColors.whiteColor,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ))),
          );
        },
        error: (error, s) => Container(),
        loading: () => Container());
  }
}
