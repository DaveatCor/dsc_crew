import 'package:http/http.dart' as _http;
import 'package:mdw_crew/index.dart';


class GetRequest {

  static String? _api = "https://backend.dangkorsenchey.com/";

  static Future<_http.Response> querydscApiJson() async {
    // print("dotenv.get('DSC_URI') ${dotenv.get('DSC_URI')}");
    // String _api = dotenv.get('DSC_URI');
    return await _http.get(
      Uri.parse("${dotenv.get('DSC_URI')}dsc.json"),
      // headers: conceteHeader(),
    );
  }

  static Future<_http.Response> claimBenefit(String addr) async {
    // print("dotenv.get('DSC_URI') ${dotenv.get('DSC_URI')}");
    // String _api = dotenv.get('DSC_URI');

    // await StorageServices.fetchData("dsc_api").then((api) {

    //   _api = api["api"];
    //   print("dsc_api $_api");
    // });

    // await StorageServices.fetchData("dsc_api_test").then((apiTest) {
    //   if (apiTest['api_test'] != null){
    //     _api = apiTest["api_test"];
    //     print("dsc_api_test $_api");
    //   }
    // });

    return await _http.get(
      Uri.parse("${_api}claim-benefits/$addr"),
      // headers: conceteHeader(),
    );
  }

  Future<void> queryDSCJSON() async {

    await GetRequest.querydscApiJson().then((value) async {
      
      await StorageServices.storeApiFromGithub((await json.decode(value.body)));

      await StorageServices.storeData(
        {
          "api_test": (await json.decode(value.body))['api_test']
        }, 
        'dsc_api_test'
      );

      await StorageServices.storeData(
        {
          "matches": (await json.decode(value.body))['matches']
        }, 
        'matches'
      );

      await StorageServices.storeData(
        {
          "admin_acc": (await json.decode(value.body))['admin_acc']
        }, 
        'admin_acc'
      );

      // Initialize Socket
      // Provider.of<MDWSocketProvider>(context, listen: false).initSocket(json.decode(value.body)['ws']);
    });
  }

  static Future<_http.Response> fetchMatchData() async {
    return await _http.get(
      Uri.parse("${_api}current-match"),
      // headers: conceteHeader(key: 'Authorization', value: _tk!['token']),
      headers: conceteHeader(),
    );
  }
}