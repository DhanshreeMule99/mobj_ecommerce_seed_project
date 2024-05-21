import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:image_picker/image_picker.dart';

import '../module/wishlist/wishlishScreen.dart';

class ImageCrop extends ConsumerStatefulWidget {
  const ImageCrop({super.key});

  @override
  _ImageCropState createState() => _ImageCropState();
}

class _ImageCropState extends ConsumerState<ImageCrop> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  String? profilePic;

  @override
  Widget build(BuildContext context) {
    final appInfoAsyncValue = ref.watch(appInfoProvider);

    return Scaffold(
      appBar: AppBar(
          elevation: 2,
          // backgroundColor: app_colors.white_color,
          title: appInfoAsyncValue.when(
            data: (appInfo) => const Text(
              AppString.profile,
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text('Error: $error'),
          )),
      bottomNavigationBar: MobjBottombar(
        bgcolor: Colors.white,
        selcted_icon_color: AppColors.buttonColor,
        unselcted_icon_color: AppColors.blackColor,
        selectedPage: 3,
        screen1: const HomeScreen(),
        screen2: SearchWidget(),
        screen3: WishlistScreen(),
        screen4: const ProfileScreen(),
        ref: ref,
      ),
      body: ref.watch(profileDataProvider).when(
            data: (profile) {
              return appInfoAsyncValue.when(
                  data: (appInfo) => Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (kIsWeb)
                            Padding(
                              padding:
                                  const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
                              child: Text(
                                "Image crop",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium!
                                    .copyWith(
                                        color:
                                            Theme.of(context).highlightColor),
                              ),
                            ),
                          Expanded(child: _body(appInfo.primaryColorValue)),
                        ],
                      ),
                  error: (error, s) => const SizedBox(),
                  loading: () => const SizedBox());
            },
            loading: () => const CircularProgressIndicator(),
            error: (error, stackTrace) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4.2,
                ),
                // Center(
                //   child: Error_handling_screens(
                //     error_type: "error",
                //   ),
                // ),
                // Mobj_elvatedbutton(
                //   radius: AppDimension.buttonRadius,
                //   primary_color: app_colors.button_color,
                //   onPressed: () {
                //     ref.refresh(profileprovider);
                //   },
                //   child: Mobj_text(
                //     string: AppString.refresh,
                //     fontsize: 16,
                //     color: app_colors.white_color,
                //   ),
                // )
              ],
            ),
          ),
    );
  }

  Widget _body(Color? backgroundColor) {
    if (_croppedFile != null || _pickedFile != null) {
      return _imageCard(backgroundColor);
    } else {
      return _uploaderCard(backgroundColor);
    }
  }

  Widget _imageCard(Color? backgroundColor) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
                child: _image(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          _menu(backgroundColor),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height * 0.5;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu(Color? backgroundColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () {
            _clear();
          },
          backgroundColor: Colors.redAccent,
          tooltip: 'Delete',
          child: const Icon(Icons.delete),
        ),
        if (_croppedFile == null)
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              onPressed: () {
                _cropImage(backgroundColor);
              },
              backgroundColor: const Color(0xFFBC764A),
              tooltip: 'Crop',
              child: const Icon(Icons.crop),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 32.0),
          child: FloatingActionButton(
            onPressed: () {
              uploadImage();
            },
            backgroundColor: Colors.green,
            tooltip: 'Upload image',
            child: const Icon(Icons.check),
          ),
        )
      ],
    );
  }

  Widget _uploaderCard(Color? backgroundColor) {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: kIsWeb ? 380.0 : 320.0,
          height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DottedBorder(
                    radius: const Radius.circular(12.0),
                    borderType: BorderType.RRect,
                    dashPattern: const [8, 4],
                    color: Theme.of(context).highlightColor.withOpacity(0.4),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            color: Theme.of(context).highlightColor,
                            size: 80.0,
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            'Upload an image to start',
                            style: kIsWeb
                                ? Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        color: Theme.of(context).highlightColor)
                                : Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color:
                                            Theme.of(context).highlightColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                child: ElevatedButton(
                    onPressed: () {
                      _uploadImage();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: backgroundColor,
                      // minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimension.buttonRadius)),
                      // maximumSize: Size(1330, 500),
                      // minimumSize:Size(1000, 500) ,
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontStyle: FontStyle.normal),
                    ),
                    child: Text(
                      AppString.uploadImage,
                      style: TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage(Color? backgroundColor) async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: backgroundColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
          profilePic = croppedFile.path;
        });
        // await SharedPreferenceManager().setProfile(croppedFile.path!);
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _pickedFile = pickedFile;
      profilePic = pickedFile!.path;
    });
  }

  uploadImage() async {
    await SharedPreferenceManager().setProfile(profilePic!);
    ref.refresh(profileDataProvider);
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const ProfileScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => route.isFirst);
    Fluttertoast.showToast(
        msg: "Image upload successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }
}
