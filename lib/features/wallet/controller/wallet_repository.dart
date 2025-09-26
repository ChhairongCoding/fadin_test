import 'package:dio/dio.dart';
import 'package:fardinexpress/features/wallet/model/wallet_transaction_model.dart';
import 'package:fardinexpress/services/api_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WalletRepository {
  ApiProvider apiProvider = ApiProvider();

  Future<String?> topupBalance({
    required String note,
    required String paymentMethod,
    required String amount,
    required String image,
  }) async {
    Map<String, dynamic> body = {
      "note": note,
      "payment_method": paymentMethod,
      "amount": amount,
      "image": image,
    };

    String url = '${dotenv.env['baseUrl']}/wallet/topup';
    try {
      Response response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        print("Top up success!");
        return data["message"].toString();
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<String?> withdrawal({
    required String amount,
  }) async {
    Map<String, dynamic> body = {
      "amount": amount,
    };

    String url = '${dotenv.env['baseUrl']}/wallet/withdraw';
    try {
      Response response = (await (apiProvider.post(url, body, null)))!;
      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.data;
        return data["message"].toString();
      } else {
        throw response.data["message"].toString();
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<WalletTransactionModel>> getWalletTran(
      {required int? page, required int? rowPerpage}) async {
    try {
      String baseUrl =
          "${dotenv.env['baseUrl']}/wallet/transactions?page=$page&row_per_page=$rowPerpage";
      String url = baseUrl;
      // Map<String, dynamic> body = {"device_token": deviceToken};
      Response response = (await apiProvider.get(url, null, null))!;
      if (response.statusCode == 200) {
        List<WalletTransactionModel> walletTran = [];
        response.data["data"].forEach((val) {
          walletTran.add(WalletTransactionModel.fromJson(val));
        });
        return walletTran;
      }
      // else if (response.statusCode == 401) {
      //   throw InvalidTokenException();
      // }
      throw response.data["message"].toString();
    } catch (e) {
      throw e;
    }
  }
}
