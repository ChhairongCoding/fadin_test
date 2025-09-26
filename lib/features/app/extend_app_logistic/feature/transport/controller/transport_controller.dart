import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport/controller/transport_repository.dart';
import 'package:fardinexpress/features/app/extend_app_logistic/feature/transport/model/transport_model.dart';
import 'package:get/get.dart';

// ProductController productController = ProductController();

class TransportController extends GetxController {
  var isLoading = false.obs;
  // var currentIndex = 0.obs;
  RxString tempTranId = "".obs;
  List<TransportModel> transports = <TransportModel>[].obs;
  TransportRepository transportRepository = TransportRepository();

  TransportController(String type) {
    getTransportType(type);
  }

  void getTransportType(String type) async {
    try {
      isLoading(true);
      var tempTransports =
          await transportRepository.fetchTransportList(type: type);
      transports.addAll(tempTransports);
      if (tempTransports.isNotEmpty) {
        tempTranId.value = tempTransports[0].id.toString();
      }
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }
}
