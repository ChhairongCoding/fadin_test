import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';

class Helper {
  static String convertToKhmerPhoneNumber({required String number}) {
    return number;
  }

  static String connectString(List<String> stringList) {
    String result = "";
    stringList.forEach((element) {
      if (stringList.indexOf(element) == 0) {
        result = (element == "" ? "" : element);
      }
      // else if(stringList.indexOf(element)==(stringList.length-1)){

      // }
      else {
        result = result +
            (element == ""
                ? ""
                : (result.length == 0)
                    ? element
                    : ", $element");
      }
    });
    return result;
  }

  static List<String>? convertStringtoListString({required String data}) {
    return json.decode(data);
  }

  static String convertListStringtoString({required List<String> data}) {
    String result = '"["';
    result += data.join('","');
    result += '"]"';
    return result;
  }

  // static void requiredLoginFuntion(
  //     {required BuildContext context, required Function callBack}) {
  //   if (BlocProvider.of<AuthenticationBloc>(context).state is Authenticated) {
  //     callBack();
  //   } else {
  //     Navigator.pushNamed(context, loginRegister, arguments: true);
  //   }
  // }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  // static void imgFromGallery(onPicked(File image)) async {
  //   final picker = ImagePicker();
  //   PickedFile imageP = (await (picker.getImage(
  //       source: ImageSource.gallery, imageQuality: 50)))!;
  //   final File image = File(imageP.path);
  //   onPicked(image);
  // }

  // static void imgFromCamera(onPicked(File image)) async {
  //   final picker = ImagePicker();
  //   PickedFile imageP = (await (picker.getImage(
  //       source: ImageSource.camera, imageQuality: 50)))!;
  //   final File image = File(imageP.path);
  //   onPicked(image);
  // }

  // static List<Color> randomGradientColor() {
  //   List<Color> colorList;
  //   try {
  //     colorList =
  //         _gradientColorList[random.nextInt(_gradientColorList.length - 1)];
  //   } catch (_) {
  //     colorList = [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)];
  //   }
  //   return colorList;
  // }

  String translate(BuildContext context, String key) {
    try {
      String result = key;
      // AppLocalizations.of(context)!.translate(key)!;
      return result;
    } catch (e) {
      log("Translation is not available for key '$key'");
      return "null";
    }
  }

  // static handleState(
  //     {required ErrorState state, required BuildContext context}) {
  //   print(state.error.runtimeType);

  //   if (state.error == 401) {
  //     print("d");
  //     BlocProvider.of<AuthenticationBloc>(context).add(LogoutPressed());
  //   } else {
  //     print("d2");
  //     return;
  //   }
  // }
}

// Random random = new Random();
// List<List<Color>> _gradientColorList = [
//   [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
//   [Color(0xFFbc4e9c), Color(0xFFf80759)],
//   [Color(0xFF642B73), Color(0xFFC6426E)],
//   [Color(0xFFC33764), Color(0xFF1D2671)],
//   [Color(0xFFcb2d3e), Color(0xFFef473a)],
//   [Color(0xFFec008c), Color(0xFFec008c)],
//   [Color(0xFFf953c6), Color(0xFFb91d73)],
//   [Color(0xFF7F00FF), Color(0xFFE100FF)],
//   [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
//   [Color(0xFFf12711), Color(0xFFf5af19)]
// ];
