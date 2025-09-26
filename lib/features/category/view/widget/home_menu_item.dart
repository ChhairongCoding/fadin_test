import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/category/model/categories_model.dart';
import 'package:flutter/material.dart';

class HomeCategoryItem extends StatelessWidget {
  final String colorFont;
  final CategoryModel categoryModel;
  const HomeCategoryItem(
      {Key? key, required this.categoryModel, required this.colorFont})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(8.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(),
                ),
                Expanded(
                  flex: 8,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(8.0),
                          // boxShadow: [
                          //   BoxShadow(
                          //       color: Colors.grey[300]!,
                          //       offset: Offset(0.0, 0.5), //(x,y)
                          //       blurRadius: 2.0,
                          //       spreadRadius: 0.0),
                          // ],
                          color: Colors.white60),
                      child: ExtendedImage.network(
                        categoryModel.image.toString(),
                        // errorWidget:
                        //     Image.asset("assets/img/fardin-logo.png"),
                        cacheWidth: 50,
                        cacheHeight: 50,
                        // enableMemoryCache: true,
                        clearMemoryCacheWhenDispose: true,
                        clearMemoryCacheIfFailed: false,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Center(),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            categoryModel.name!.toString(),
            style: TextStyle(
                height: 1.5,
                color: this.colorFont == "white" ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textScaleFactor: 0.8,
            softWrap: true,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
