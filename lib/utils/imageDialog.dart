import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:photo_view/photo_view.dart';

class ImageDialog extends StatefulWidget {
  final String imageUrl;

  const ImageDialog({super.key, required this.imageUrl});

  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        color: AppColors.whiteColor,
        child: PhotoView(
          imageProvider: NetworkImage(widget.imageUrl),
        ),
      ),
    );
  }
}