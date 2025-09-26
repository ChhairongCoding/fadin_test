import 'package:fardinexpress/features/app/extend_app_logistic/feature/banner/bloc/banner_bloc.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/banner/bloc/banner_event.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/banner/bloc/banner_state.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/shared/widget/image_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBannerSlider extends StatefulWidget {
  @override
  _BannerSliderState createState() => _BannerSliderState();
}

class _BannerSliderState extends State<HomeBannerSlider> {
  late BannerBloc _bannerBloc;
  @override
  void initState() {
    _bannerBloc = BannerBloc();
    _bannerBloc.add(FetchStarted());
    super.initState();
  }

  @override
  void dispose() {
    _bannerBloc.close();
    super.dispose();
  }

  // var service = AppContentsService();
  @override
  Widget build(BuildContext context) {
    _bannerBloc.add(FetchStarted());
    return AspectRatio(
      aspectRatio: 2.05,
      child: Container(
        color: Colors.white,
        child: BlocBuilder(
          bloc: _bannerBloc,
          builder: (context, dynamic state) {
            if (state is FetchingBanner) {
              Container();
              // return Shimmer(
              //   // duration: Duration(seconds: 5),
              //   // color: Colors.black,
              //   child: AspectRatio(
              //     aspectRatio: 1.91,
              //     child: Container(
              //         //color: Colors.blue,
              //         height: double.infinity,
              //         width: double.infinity),
              //   ),
              // );
            }
            if (state is ErrorFetchingBanner) {
              return Container();
            } else {
              return (_bannerBloc.banners.length == 0)
                  ? Container()
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          child: ImageSlider(
                            fit: BoxFit.cover,
                            aspectRatio: 2.05,
                            duration: 500,
                            images:
                                //  [
                                //   "http://boukaw.anakutjobs.com/assets/uploads/b315ebb36ba1bd3d67e2b0d16e918c02.jpg"
                                // ],
                                _bannerBloc.banners.map((banner) {
                              print(banner.image);
                              return banner.image;
                            }).toList(),
                            autoPlay: true,
                            showDot: true,
                            willCache: true,
                          ),
                        ),
                      ],
                    );
            }
          },
        ),
      ),
    );
  }
}

// return Shimmer(
//   duration: Duration(seconds: 5),
//   color: Colors.black,
//   child: AspectRatio(
//     aspectRatio: 18 / 9,
//     child: Container(
//         //color: Colors.blue,
//         height: double.infinity,
//         width: double.infinity),
//   ),
// );
