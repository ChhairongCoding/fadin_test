import 'package:fardinexpress/features/app/extend_app_logistic/feature/blog/models/info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../info_detail_page.dart';

class InfoTile extends StatelessWidget {
  final Info info;
  InfoTile({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InfoDetailPageWrapper(info: info)));
        },
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            backgroundColor: Colors.grey[200]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(info.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .primaryTextTheme
                          .titleMedium!
                          .copyWith(
                              color: Colors.green,
                              fontWeight: FontWeight.w600)),
                  Html(
                      data: info.link,
                      style: {
                        "body": Style(
                            color: Colors.black,
                            fontSize: FontSize(16),
                            fontWeight: FontWeight.w500),
                      },
                      onLinkTap: ((url, attributes, element) async {
                        if (url != null) {
                          await launchUrl(Uri.parse(url));
                        }
                      }))
                ],
              ),
            ),
            // Icon(Icons.arrow_forward_ios_outlined, color: Colors.black)
          ],
        ),
      ),
    );
  }
}
