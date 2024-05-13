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
          "https://api.bigcommerce.com/stores/zwpg4jmenh/v2/banners";
      API api = API();
      final response = await api.sendRequest.get(productUrl);

      if (response.statusCode == 200) {
        List body = response.data;

        // Clear imgList before adding new images
        imgList.clear();

        // Loop through each item in the body list
        for (var item in body) {
          // Extract the image URL from the item content
          String imageUrl = extractTextContent(item["content"]);

          // Split the content by space
          List<String> content = imageUrl.split(" ");

          // Add the image URL to imgList
          String contentLink = content[0];
          List<String> productid = content[1].split(":");
          log("Productid is ,$productid");
          // log(contentLink);
          imgList.add(contentLink);
          productList.add(productid.last);
        }
        setState(() {});
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
          ? const CircularProgressIndicator()
          : Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    //aspectRatio: 1/.7,
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
                    String productId = productList[index];

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
                              )),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          ProductDetailsScreen(
                                    uid: productId.toString(),
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
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
                )
              ],
            ),
    );
  }
}
