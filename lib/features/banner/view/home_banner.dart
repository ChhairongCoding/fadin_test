import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/banner/controller/banner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class HomeBanner extends StatelessWidget {
  const HomeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BannerController _bannerCtr = Get.find<BannerController>();

    return Obx(() {
      if (_bannerCtr.isLoading.value) {
        return AspectRatio(
          aspectRatio: 2.01,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              // height: 200,
              // width: double.infinity,
              // height: 500,
              // width: double.infinity,
            ),
          ),
        );
      } else {
        return _bannerCtr.bannerList.isEmpty
            ? Container()
            : Container(
                // margin: EdgeInsets.only(bottom: 15.0),
                child: CarouselSlider.builder(
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeStrategy: CenterPageEnlargeStrategy.scale,
                      aspectRatio: 16 / 6,
                      viewportFraction: 3 / 4,
                      // autoPlayCurve: Curves.fastOutSlowIn,
                      autoPlayCurve: Curves.easeOutQuart,
                      // disableCenter: true,
                      enlargeCenterPage: false,
                      autoPlayInterval: const Duration(seconds: 6)),
                  itemCount: _bannerCtr.bannerList.length,
                  itemBuilder: (context, idx, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0)),
                        // child: Image.network(
                        //   //Image slid show 800x418
                        //   _bannerBloc.banners[idx].image.toString(),
                        //   fit: BoxFit.cover,
                        // ),
                        child: ExtendedImage.network(
                          _bannerCtr.bannerList[idx].image.toString(),
                          // errorWidget: Image.asset("assets/img/shop-hint.jpg"),
                          // enableMemoryCache: true,
                          clearMemoryCacheWhenDispose: true,
                          clearMemoryCacheIfFailed: false,
                          cacheWidth: 1000,
                          cacheHeight: 500,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              );
      }
    });
  }
}
