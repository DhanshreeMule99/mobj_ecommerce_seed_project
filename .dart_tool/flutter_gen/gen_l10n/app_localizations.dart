import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('mr')
  ];

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get setting;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'P.Y.Vaidya'**
  String get appName;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading..'**
  String get loading;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @office.
  ///
  /// In en, this message translates to:
  /// **'Office'**
  String get office;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @saveAddress.
  ///
  /// In en, this message translates to:
  /// **'Save Address As'**
  String get saveAddress;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @mobileNo.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get mobileNo;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'REGISTRATION'**
  String get register;

  /// No description provided for @customerReview.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get customerReview;

  /// No description provided for @noReview.
  ///
  /// In en, this message translates to:
  /// **'No reviews'**
  String get noReview;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registerSuccess;

  /// No description provided for @addressAdded.
  ///
  /// In en, this message translates to:
  /// **'Address added successful'**
  String get addressAdded;

  /// No description provided for @updateAddress.
  ///
  /// In en, this message translates to:
  /// **'Address updated successful'**
  String get updateAddress;

  /// No description provided for @verificationCode.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get verificationCode;

  /// No description provided for @exceedLimit.
  ///
  /// In en, this message translates to:
  /// **'Resetting password limit exceeded'**
  String get exceedLimit;

  /// No description provided for @otpInfo.
  ///
  /// In en, this message translates to:
  /// **'We have sent the verification code to your Phone Number'**
  String get otpInfo;

  /// No description provided for @otpInfoEmail.
  ///
  /// In en, this message translates to:
  /// **'We have sent the verification code to your Email ID'**
  String get otpInfoEmail;

  /// No description provided for @passwordVerification.
  ///
  /// In en, this message translates to:
  /// **'We have sent the reset password link to your Email ID'**
  String get passwordVerification;

  /// No description provided for @otpInfoBoth.
  ///
  /// In en, this message translates to:
  /// **'We have sent the verification code to your Email ID and Phone Number'**
  String get otpInfoBoth;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get myProfile;

  /// No description provided for @emptySize.
  ///
  /// In en, this message translates to:
  /// **'Please select the size'**
  String get emptySize;

  /// No description provided for @emptyColor.
  ///
  /// In en, this message translates to:
  /// **'Please select the color'**
  String get emptyColor;

  /// No description provided for @canNotDeleteDefault.
  ///
  /// In en, this message translates to:
  /// **'You can not delete default address'**
  String get canNotDeleteDefault;

  /// No description provided for @checkInternet.
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and Try again.'**
  String get checkInternet;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @userNotRegister.
  ///
  /// In en, this message translates to:
  /// **'User is not yet registered'**
  String get userNotRegister;

  /// No description provided for @reqForPass.
  ///
  /// In en, this message translates to:
  /// **'Request for password'**
  String get reqForPass;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @forgetPass.
  ///
  /// In en, this message translates to:
  /// **'Forgot Your Password?'**
  String get forgetPass;

  /// No description provided for @oops.
  ///
  /// In en, this message translates to:
  /// **'Oops something went wrong'**
  String get oops;

  /// No description provided for @defaultAddressSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your default address has been changed'**
  String get defaultAddressSuccess;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get pleaseWait;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'google'**
  String get google;

  /// No description provided for @googleSignupError.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In Error'**
  String get googleSignupError;

  /// No description provided for @invalidCred.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials. Please check email or password.'**
  String get invalidCred;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get welcome;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @notHaveAcc.
  ///
  /// In en, this message translates to:
  /// **'Does not have account?'**
  String get notHaveAcc;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @signInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Google'**
  String get signInGoogle;

  /// No description provided for @doesNotHaveAcc.
  ///
  /// In en, this message translates to:
  /// **'Does not have account?'**
  String get doesNotHaveAcc;

  /// No description provided for @invalidOtp.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP'**
  String get invalidOtp;

  /// No description provided for @userExists.
  ///
  /// In en, this message translates to:
  /// **'User already exist'**
  String get userExists;

  /// No description provided for @correctData.
  ///
  /// In en, this message translates to:
  /// **'Please enter correct data'**
  String get correctData;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @confirmPass.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPass;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign up with Google'**
  String get signUpWithGoogle;

  /// No description provided for @openSetting.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSetting;

  /// No description provided for @locationPermissionSett.
  ///
  /// In en, this message translates to:
  /// **'Please grant location permission in app settings to use this feature.'**
  String get locationPermissionSett;

  /// No description provided for @locationPermissionReq.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get locationPermissionReq;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please Log In'**
  String get pleaseLogin;

  /// No description provided for @needLogin.
  ///
  /// In en, this message translates to:
  /// **'You need to log in to access this feature.'**
  String get needLogin;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @fcmChannelName.
  ///
  /// In en, this message translates to:
  /// **'mobjappchannel'**
  String get fcmChannelName;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// No description provided for @unAuthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized Access'**
  String get unAuthorized;

  /// No description provided for @alreadyExist.
  ///
  /// In en, this message translates to:
  /// **'Mobile number already exist'**
  String get alreadyExist;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @actualPrice.
  ///
  /// In en, this message translates to:
  /// **'Actual Price'**
  String get actualPrice;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @useMy.
  ///
  /// In en, this message translates to:
  /// **'Use My Location'**
  String get useMy;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @addAddress.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddress;

  /// No description provided for @extraDelivery.
  ///
  /// In en, this message translates to:
  /// **'Above 6 Km away: Extra delivery charges will apply.'**
  String get extraDelivery;

  /// No description provided for @standardDelivery.
  ///
  /// In en, this message translates to:
  /// **'Within 6 Km: Standard delivery charges will apply.'**
  String get standardDelivery;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update profile'**
  String get updateProfile;

  /// No description provided for @updateProfileSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get updateProfileSuccess;

  /// No description provided for @locRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get locRadius;

  /// No description provided for @savePref.
  ///
  /// In en, this message translates to:
  /// **'Save Preferences'**
  String get savePref;

  /// No description provided for @passInc.
  ///
  /// In en, this message translates to:
  /// **'Entered password is incorrect'**
  String get passInc;

  /// No description provided for @oldPass.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPass;

  /// No description provided for @validOTP.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid OTP'**
  String get validOTP;

  /// No description provided for @resendOTP.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOTP;

  /// No description provided for @resetPass.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPass;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @themeChange.
  ///
  /// In en, this message translates to:
  /// **'Theme change'**
  String get themeChange;

  /// No description provided for @notificationSetting.
  ///
  /// In en, this message translates to:
  /// **'Notification Setting'**
  String get notificationSetting;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy And T&C'**
  String get privacyPolicy;

  /// No description provided for @rateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateUs;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @accDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate account'**
  String get accDeactivate;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Logout Confirmation'**
  String get logoutConfirmation;

  /// No description provided for @areYouSurelogout.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to logout?'**
  String get areYouSurelogout;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @deactivateConf.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Confirmation'**
  String get deactivateConf;

  /// No description provided for @areYouSureDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to deactivate your account?'**
  String get areYouSureDeactivate;

  /// No description provided for @deleteAddressConf.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get deleteAddressConf;

  /// No description provided for @areYouSureDeleteAddress.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the address?'**
  String get areYouSureDeleteAddress;

  /// No description provided for @deactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get deactivate;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload image'**
  String get uploadImage;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add To Cart'**
  String get addToCart;

  /// No description provided for @addReview.
  ///
  /// In en, this message translates to:
  /// **'Add review'**
  String get addReview;

  /// No description provided for @giveReview.
  ///
  /// In en, this message translates to:
  /// **'Write your review'**
  String get giveReview;

  /// No description provided for @titleReview.
  ///
  /// In en, this message translates to:
  /// **'Title your review'**
  String get titleReview;

  /// No description provided for @emptyCart.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get emptyCart;

  /// No description provided for @emptyAddress.
  ///
  /// In en, this message translates to:
  /// **'No address added'**
  String get emptyAddress;

  /// No description provided for @emptyProduct.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get emptyProduct;

  /// No description provided for @addToCartSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product added in cart'**
  String get addToCartSuccess;

  /// No description provided for @addReviewSuccess.
  ///
  /// In en, this message translates to:
  /// **'Review added'**
  String get addReviewSuccess;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @selectSize.
  ///
  /// In en, this message translates to:
  /// **'Select Size'**
  String get selectSize;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get color;

  /// No description provided for @orderSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully!'**
  String get orderSuccess;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed!'**
  String get paymentFailed;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @proceedTOPay.
  ///
  /// In en, this message translates to:
  /// **'Proceed to payment'**
  String get proceedTOPay;

  /// No description provided for @thankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for shopping with us.'**
  String get thankYou;

  /// No description provided for @size.
  ///
  /// In en, this message translates to:
  /// **'Size:'**
  String get size;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get next;

  /// No description provided for @myBag.
  ///
  /// In en, this message translates to:
  /// **'My Bag'**
  String get myBag;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @totalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// No description provided for @editAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get editAddressTitle;

  /// No description provided for @addAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get addAddressTitle;

  /// No description provided for @updateAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Address'**
  String get updateAddressTitle;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @nickAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address name'**
  String get nickAddressLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @postalCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCodeLabel;

  /// No description provided for @hintTextAddress.
  ///
  /// In en, this message translates to:
  /// **'123 Main St'**
  String get hintTextAddress;

  /// No description provided for @hintTextCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get hintTextCity;

  /// No description provided for @hintTextPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get hintTextPostalCode;

  /// No description provided for @saveAddressButton.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddressButton;

  /// No description provided for @addressValidationErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Address cannot be empty'**
  String get addressValidationErrorMessage;

  /// No description provided for @cityValidationErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'City cannot be empty'**
  String get cityValidationErrorMessage;

  /// No description provided for @postalCodeValidationErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Postal Code cannot be empty'**
  String get postalCodeValidationErrorMessage;

  /// No description provided for @myOrder.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrder;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetailsTitle;

  /// No description provided for @orderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID: '**
  String get orderId;

  /// No description provided for @orderDate.
  ///
  /// In en, this message translates to:
  /// **'Order Date: '**
  String get orderDate;

  /// No description provided for @customerDetails.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetails;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name:'**
  String get customerName;

  /// No description provided for @customerEmail.
  ///
  /// In en, this message translates to:
  /// **'Email: john.doe@example.com'**
  String get customerEmail;

  /// No description provided for @customerPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone: +1 (123) 456-7890'**
  String get customerPhone;

  /// No description provided for @addressDetails.
  ///
  /// In en, this message translates to:
  /// **'Address Details'**
  String get addressDetails;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address: 123 Main Street'**
  String get address;

  /// No description provided for @addressList.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressList;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City: Anytown'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State: CA'**
  String get state;

  /// No description provided for @zipCode.
  ///
  /// In en, this message translates to:
  /// **'ZIP Code: 12345'**
  String get zipCode;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @paymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get paymentDetails;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method: Credit Card'**
  String get paymentMethod;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card Number: **** **** **** 1234'**
  String get cardNumber;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount:'**
  String get totalAmount;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order Status:'**
  String get orderStatus;

  /// No description provided for @trackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Tracking'**
  String get trackingTitle;

  /// No description provided for @orderStatus1.
  ///
  /// In en, this message translates to:
  /// **'Order Placed'**
  String get orderStatus1;

  /// No description provided for @orderStatus2.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get orderStatus2;

  /// No description provided for @orderStatus3.
  ///
  /// In en, this message translates to:
  /// **'Out for Delivery'**
  String get orderStatus3;

  /// No description provided for @orderStatus4.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatus4;

  /// No description provided for @trackOrder.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get trackOrder;

  /// No description provided for @repeatOrder.
  ///
  /// In en, this message translates to:
  /// **'Repeat Order'**
  String get repeatOrder;

  /// No description provided for @orderPlacedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your order has been successfully placed.'**
  String get orderPlacedMessage;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @myWishList.
  ///
  /// In en, this message translates to:
  /// **'My Wish List'**
  String get myWishList;

  /// No description provided for @myAddressList.
  ///
  /// In en, this message translates to:
  /// **'My Address'**
  String get myAddressList;

  /// No description provided for @paymentOption.
  ///
  /// In en, this message translates to:
  /// **'Payment Options'**
  String get paymentOption;

  /// No description provided for @deliverAt.
  ///
  /// In en, this message translates to:
  /// **'Deliver at:'**
  String get deliverAt;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @noDataError.
  ///
  /// In en, this message translates to:
  /// **'emptyData'**
  String get noDataError;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get error;

  /// No description provided for @searchProduct.
  ///
  /// In en, this message translates to:
  /// **'Search Product'**
  String get searchProduct;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'success'**
  String get success;

  /// No description provided for @alreadyReview.
  ///
  /// In en, this message translates to:
  /// **'You already submitted a review for this product'**
  String get alreadyReview;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// No description provided for @liked.
  ///
  /// In en, this message translates to:
  /// **'liked'**
  String get liked;

  /// No description provided for @successPayment.
  ///
  /// In en, this message translates to:
  /// **'Success payment'**
  String get successPayment;

  /// No description provided for @shipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shipped;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'\'Reset your password\''**
  String get resetPassword;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @addressValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter the address'**
  String get addressValidationMsg;

  /// No description provided for @nickAddressValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter the address name'**
  String get nickAddressValidationMsg;

  /// No description provided for @cityValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter the city'**
  String get cityValidationMsg;

  /// No description provided for @firstNameValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter the first name'**
  String get firstNameValidationMsg;

  /// No description provided for @lastNameValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter the last name'**
  String get lastNameValidationMsg;

  /// No description provided for @phoneValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter the phone number'**
  String get phoneValidationMsg;

  /// No description provided for @phoneInValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter a correct phone number'**
  String get phoneInValidationMsg;

  /// No description provided for @emailValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter a correct email address'**
  String get emailValidationMsg;

  /// No description provided for @countryValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter the country'**
  String get countryValidationMsg;

  /// No description provided for @zipValidationMsg.
  ///
  /// In en, this message translates to:
  /// **'Please enter the ZIP code'**
  String get zipValidationMsg;

  /// No description provided for @validZipCode.
  ///
  /// In en, this message translates to:
  /// **'ZIP code should be 6 digits'**
  String get validZipCode;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstNameLabel;

  /// No description provided for @personNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Person Name'**
  String get personNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastNameLabel;

  /// No description provided for @phoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneLabel;

  /// No description provided for @countryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get countryLabel;

  /// No description provided for @zipLabel.
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipLabel;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @relatedProduct.
  ///
  /// In en, this message translates to:
  /// **'Related Product'**
  String get relatedProduct;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @selectPrice.
  ///
  /// In en, this message translates to:
  /// **'Selected price range'**
  String get selectPrice;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'CLEAR FILTER'**
  String get clear;

  /// No description provided for @applyFilter.
  ///
  /// In en, this message translates to:
  /// **'APPLY FILTER'**
  String get applyFilter;

  /// No description provided for @lowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price Low to High'**
  String get lowToHigh;

  /// No description provided for @highToLow.
  ///
  /// In en, this message translates to:
  /// **'Price High to Low'**
  String get highToLow;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get sortBy;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get readMore;

  /// No description provided for @locationError.
  ///
  /// In en, this message translates to:
  /// **'Product delivery is available only in Pune, India.'**
  String get locationError;

  /// No description provided for @locationReq.
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get locationReq;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @grantPermission.
  ///
  /// In en, this message translates to:
  /// **'Please grant location permission in app settings to use this feature.'**
  String get grantPermission;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'mr': return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
