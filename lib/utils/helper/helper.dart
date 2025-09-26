import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Helper {
  // static void requiredLoginFuntion(
  //     {required BuildContext context, required Function callBack}) {
  //   if (BlocProvider.of<AuthenticationBloc>(context).state is Authenticated) {
  //     callBack();
  //   } else {
  //     Navigator.pushNamed(context, loginRegister, arguments: true);
  //   }
  // }

  static String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  static void imgFromGallery(onPicked(File image)) async {
    final picker = ImagePicker();
    XFile? imageP =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    final File image = File(imageP!.path);
    onPicked(image);
  }

  static void imgFromCamera(onPicked(File image)) async {
    final picker = ImagePicker();
    XFile? imageP =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    final File image = File(imageP!.path);
    onPicked(image);
  }

  // String translate(BuildContext context, String key) {
  //   try {
  //     String result = AppLocalizations.of(context)!.translate(key)!;
  //     return result;
  //   } catch (e) {
  //     log("Translation is not available for key '$key'");
  //     return "null";
  //   }
  // }

//   static handleState(
//       {required ErrorState state, required BuildContext context}) {
//     print(state.error.runtimeType);

//     if (state.error == 401) {
//       print("d");
//       BlocProvider.of<AuthenticationBloc>(context).add(LogoutPressed());
//     } else {
//       print("d2");
//       return;
//     }
//   }
// }

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
}
