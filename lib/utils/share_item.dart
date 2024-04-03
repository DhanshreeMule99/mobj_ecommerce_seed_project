import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

class ShareItem {
  buildDynamicLinks(String docId, String image, String itemname) async {
    String url =
        "https://setoo.page.link"; //replace with your firebase genrated link
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('https://www.mobj_project.com?itemIds=$docId'),
      // create new link
      androidParameters: const AndroidParameters(
        packageName: "com.setoo.mobj",
        //give your project package name
        minimumVersion: 0,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: itemname, imageUrl: Uri.parse("$image"), title: "Mobj"),
    );
    final ShortDynamicLink dynamicUrl =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    String? desc = '${dynamicUrl.shortUrl.toString()}';

    await Share.share(desc);
  }
}
