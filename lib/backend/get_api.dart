import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as _http;
import 'package:mdw_crew/service/storage.dart';

class GetRequest {

  static String? _api;

  static Future<_http.Response> querydscApiJson() async {
    // print("dotenv.get('DSC_URI') ${dotenv.get('DSC_URI')}");
    // String _api = dotenv.get('DSC_URI');
    return await _http.get(
      Uri.parse("${dotenv.get('DSC_URI')}dsc.json"),
      // headers: conceteHeader(),
    );
  }

  static Future<_http.Response> claimBenefit(String addr) async {
  print("claimBenefit $addr");
    // print("dotenv.get('DSC_URI') ${dotenv.get('DSC_URI')}");
    // String _api = dotenv.get('DSC_URI');

    await StorageServices.fetchData("dsc_api").then((api) {

      _api = api["api"];
      print("dsc_api $_api");
    });

    await StorageServices.fetchData("dsc_api_test").then((apiTest) {

      if (apiTest != null){
        _api = apiTest["api_test"];
        print("dsc_api_test $_api");
      }
    });

    return await _http.get(
      Uri.parse("${_api}claim-benefits/$addr"),
      // headers: conceteHeader(),
    );
  }
}