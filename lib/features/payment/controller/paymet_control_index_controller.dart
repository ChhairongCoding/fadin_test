import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PaymentControlIndexController extends GetxController {
  RxBool isClick = false.obs;
  var selectedBank = 0.obs;
  // Reactive variable for selected payment method index
  var selectedMethod = 0.obs;

  var selectedBankName = "".obs;

  var selectedImage = Rxn<File>();

  void paymentControlIndex() {
    isClick(true);
  }

  void selectBankTransferIndex(int index) {
    selectedBank.value = index;
  }

  // Update the selected method when a choice is clicked
  void selectMethod(int index) {
    selectedMethod.value = index;
  }

  // Function to pick an image from the gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }
}
