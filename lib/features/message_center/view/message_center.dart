import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MessageCenterPage extends StatefulWidget {
  const MessageCenterPage({Key? key}) : super(key: key);

  @override
  State<MessageCenterPage> createState() => _MessageCenterPageState();
}

class _MessageCenterPageState extends State<MessageCenterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message"),
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            // color: Colors.green[100]
          ),
          child: ListTile(
            leading: Container(
                // margin: const EdgeInsets.symmetric(vertical: 10.0),
                // padding: EdgeInsets.symmetric(vertical: 6.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(width: 1.0, color: Colors.white)),
                child: Container(
                  child: CircleAvatar(
                    radius: 30.0,
                    child: ClipOval(
                        child: ExtendedImage.network(
                      "assets/img/fardin-logo.png",
                      // errorWidget: Image.asset("assets/img/fardin-logo.png"),
                      cacheWidth: 300,
                      cacheHeight: 300,
                      // enableMemoryCache: true,
                      clearMemoryCacheWhenDispose: true,
                      clearMemoryCacheIfFailed: false,
                      fit: BoxFit.cover,
                      // width: double.infinity,
                      // height: double.infinity,
                    )),
                    backgroundColor: Colors.transparent,
                  ),
                )),
            isThreeLine: true,
            title: Text("Fardin Express"),
            subtitle: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Fardin Express New Year Promotion is here!"),
                Text("2022-04-04")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
