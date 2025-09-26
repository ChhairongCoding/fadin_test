import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyDataWidget extends StatelessWidget {
  const EmptyDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/extend_assets/icons/empty-box.png",
              height: 120,
              width: 120,
              fit: BoxFit.cover,
              color: Colors.grey[400],
            ),
            // const SizedBox(height: 16),
            // const Text(
            //   'Product Not Found.',
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.w500,
            //     color: Colors.black87,
            //   ),
            // ),
            const SizedBox(height: 18),
            Text(
              "no_data".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
