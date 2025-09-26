import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductByCategoryShimmer extends StatelessWidget {
  const ProductByCategoryShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 5,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0), color: Colors.white),
            child: Column(
              children: [
                Expanded(
                  flex: 7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12.0),
                        topRight: Radius.circular(12.0)),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.0),
                              topRight: Radius.circular(8.0)),
                          color: Colors.grey[350],
                        ),
                        margin: EdgeInsets.all(6.0),
                        child: Container(
                          width: 400,
                          height: 400,
                        )),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        // color: Colors.red,
                        child: Text(
                          "",
                          textScaleFactor: 1.2,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(),
                      Text(
                        "",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
