import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as _http;
import 'package:mdw_crew/backend/backend.dart';
import 'package:mdw_crew/service/storage.dart';

class PostRequest {

  static String? _api;

  static String? _body;

  static Map<String, dynamic>? _tk;
  
  static Map<String, dynamic>? _dscApi;

  static Future<_http.Response> login(final String email, final String password) async {
    print("login $email $password");
    await StorageServices.fetchData('dsc_api').then((value) {
      print("value $value");
      _dscApi = value;
    });

    print("_dscApi $_dscApi");
    
    _body = json.encode({
      "email": email,
      "password": password
    });

    return await _http.post(
      Uri.parse("${_dscApi!["api"]}admin/login"),
      headers: conceteHeader(),
      body: _body
    );
  }

  // Check QR Valid Or Not
  static Future<_http.Response> checkFunc(final String eventId, final String qrcodeData) async {
    
    _tk = await StorageServices.fetchData(dotenv.get('REGISTRAION'));
    
    _dscApi = await StorageServices.fetchData('dsc_api');
    
    _body = json.encode({
      "eventId": '637ff7274903dd71e36fd4e5',//eventId,
      "qrcodeData": qrcodeData
    });

    return await _http.post(
      Uri.parse("${_dscApi!['MDW_API']}admissions/check"),
      headers: conceteHeader(key: 'Authorization', value: _tk!['token']),
      body: _body
    );
  }

  // Second Check To Redeem QR
  static Future<_http.Response> addmissionFunc({String? eventId, required String qrcodeData}) async {
    
    print("addmissionFunc backend $qrcodeData");
    String tk = await StorageServices.fetchData(dotenv.get('REGISTRAION'));
    print("_tk $tk");

    _dscApi = await StorageServices.fetchData('dsc_api');

    dynamic decode = json.decode(qrcodeData);
    
    _body = json.encode({
      "qrcode": decode
    });
    
    // ({
    //   "eventId": "637ff7274903dd71e36fd4e5",
    //   "qrcodeData": qrcodeData
    // });
// 
    print(tk.replaceAll(" ", '%20'));
    return await _http.post(
      Uri.parse("${_dscApi!["api"]}ticket/redeem"),
      headers: conceteHeader(
        key: 'Authorization', 
        value: tk
      ),
      body: _body
    );
  }

  // Check Out
  // static Future<_http.Response> checkOutFunc(final String eventId, final String qrcodeData) async {
    
  //   _tk = await StorageServices.fetchData(dotenv.get('REGISTRAION'));

  //   _body = json.encode({
  //     "eventId": eventId,
  //     "qrcodeData": qrcodeData
  //   });

  //   return await _http.post(
  //     Uri.parse("${dotenv.get('MDW_API')}admissions/enter"),
  //     headers: conceteHeader(key: 'Authorization', value: _tk!['token']),
  //     body: _body
  //   );
  // }

  // Check Out
  static Future<_http.Response> claimBenefits(final String id, List<Map<String, dynamic>> benefits) async {
    // _tk = await StorageServices.fetchData(dotenv.get('REGISTRAION'));

    await StorageServices.fetchData("dsc_api").then((api) {
      
      _api = api["api"];
    });

    await StorageServices.fetchData("dsc_api_test").then((apiTest) {

      if (apiTest['api_test'] != null){
        _api = apiTest["api_test"];
      }
    });

    _body = json.encode({
      "_id": id,
      "claim_benefits": benefits
    });

    return await _http.post(
      Uri.parse("${_api}update-claim-benefits"),
      // headers: conceteHeader(key: 'Authorization', value: _tk!['token']),
      headers: conceteHeader(),
      body: _body
    );
  }

  static Future<_http.Response> scanMovieTicket(String code) async {
    
    await StorageServices.fetchData("dsc_api").then((api) {
      
      _api = api["api"];
    });

    await StorageServices.fetchData("dsc_api_test").then((apiTest) {

      if (apiTest['api_test'] != null){
        _api = apiTest["api_test"];
      }
    });
    return await _http.post(
      Uri.parse("${_api}movie_ticket/scan_ticket?ticketId=$code"),
      // headers: conceteHeader(key: 'Authorization', value: _tk!['token']),
      headers: conceteHeader(),
    );
  }

}