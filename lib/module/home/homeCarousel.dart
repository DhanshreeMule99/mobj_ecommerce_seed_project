import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:mobj_project/module/home/productDetailsScreen.dart';
import 'package:mobj_project/utils/cmsConfigue.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/api.dart';

final List<dynamic> imgList = [];
final List<dynamic> productList = [];

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  String extractTextContent(String htmlContent) {
    final document = htmlParser.parse(htmlContent);
    final textElements = document.getElementsByTagName('p');
    final textContent = textElements.map((element) => element.text).join(' ');
    return textContent;
  }

  int activeIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  Future<void> fetchImages() async {
    try {
      log('calling api for carousel');
      String productUrl =
          "${AppConfigure.adminPanelUrl}/api/sliders?populate=*";
      API api = API();
      final response = await api.sendRequest.get(productUrl);

      if (response.statusCode == 200) {
        var body = response.data['data']; // Parse the response body

        // Clear imgList and productList before adding new images
        imgList.clear();
        productList.clear();

        // Loop through each item in the body list
        for (var item in body) {
          // Extract the image URL and product ID from the item's attributes
          String? imageUrl =
              item["attributes"]["image"]["data"][0]["attributes"]["url"];
          String? productId = item["attributes"]["product_id"];

          // Add the image URL and product ID to the respective lists
          if (imageUrl != null && imageUrl.isNotEmpty) {
            imgList.add(imageUrl);
            productList.add(productId);
          }
        }

        // Debug prints
        log('Fetched image URLs: $imgList');
        log('Fetched product IDs: $productList');

        setState(() {});
      } else {
        log('Failed to load images. Status code: ${response.statusCode}');
      }
    } catch (error, stackTrace) {
      debugPrint("error is this $error $stackTrace");
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: imgList.isEmpty
          ? const SizedBox()
          : Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    viewportFraction: 1,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    },
                  ),
                  items: imgList.asMap().entries.map((entry) {
                    int index = entry.key;
                    String imageUrl = entry.value;
                    String? productId = productList[index];

                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: NetworkImage(imageUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: InkWell(
                            onTap: productId != null
                                ? () {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        pageBuilder:
                                            (context, animation1, animation2) =>
                                                ProductDetailsScreen(
                                          sku: productId.toString(),
                                          uid: productId.toString(),
                                        ),
                                        transitionDuration: Duration.zero,
                                        reverseTransitionDuration:
                                            Duration.zero,
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  bottom: 10,
                  right: 150.w,
                  child: AnimatedSmoothIndicator(
                    activeIndex: activeIndex,
                    count: imgList.length,
                  ),
                ),
              ],
            ),
    );
  }
}
