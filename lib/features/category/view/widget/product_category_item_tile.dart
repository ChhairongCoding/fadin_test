import 'package:extended_image/extended_image.dart';
import 'package:fardinexpress/features/category/model/categories_model.dart';
import 'package:flutter/material.dart';

class ProductCategoryItemTile extends StatelessWidget {
  final String colorFont;
  final CategoryModel categoryModel;
  const ProductCategoryItemTile(
      {Key? key, required this.categoryModel, required this.colorFont})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          // shape: BoxShape.circle,
          borderRadius: BorderRadius.circular(8.0)),
      child:  Text(
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
    );
  }
}
