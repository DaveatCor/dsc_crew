import 'package:http/http.dart' as _http;
import 'package:mdw_crew/index.dart';

class PostRequest {

  static String? _api;

  static String? _body;

  static Map<String, dynamic>? _tk;
  
  static final Map<String, dynamic> _dscApi = {
    "api": "https://backend.dangkorsenchey.com/"
  };

  static Future<_http.Response> login(final String email, final String password) async {
    print("login $email $password");
    // json.decode(await SecureStorage.readSecure('dsc_api').then((value) !){
    //   print("value $value");
    //   _dscApi = value;
    // });

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
    
    _tk = json.decode(await SecureStorage.readSecure(dotenv.get('REGISTRAION'))!);
    
    // _dscApi = json.decode(await SecureStorage.readSecure('dsc_api')!);
    
    _body = json.encode({
      "eventId": '637ff7274903dd71e36fd4e5',//eventId,
      "qrcodeData": qrcodeData
    });

    return await _http.post(
      Uri.parse("${_dscApi['MDW_API']}admissions/check"),
      headers: conceteHeader(key: 'Authorization', value: _tk!['token']),
      body: _body
    );
  }

  // Second Check To Redeem QR
  static Future<_http.Response> addmissionFunc({String? eventId, required String qrcodeData}) async {
    
    print("addmissionFunc backend $qrcodeData");
    String tk = json.decode(await SecureStorage.readSecure(dotenv.get('REGISTRAION'))!);
    print("_tk $tk");

    // _dscApi = json.decode(await SecureStorage.readSecure('dsc_api')!);

    dynamic decode = json.decode(qrcodeData);
    
    _body = json.encode({
      "qrcode": decode
    });
    
    return await _http.post(
      Uri.parse("${_dscApi["api"]}ticket/redeem"),
      headers: conceteHeader(
        key: 'Authorization', 
        value: tk
      ),
      body: _body
    );
  }

  // Check Out
  // static Future<_http.Response> checkOutFunc(final String eventId, final String qrcodeData) async {
    
  //   _tk = json.decode(await SecureStorage.readSecure(dotenv.get('REGISTRAION'))!);

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
    // _tk = json.decode(await SecureStorage.readSecure(dotenv.get('REGISTRAION'))!);

    // json.decode(await SecureStorage.readSecure("dsc_api").then((api) !){
      
    //   _api = api["api"];
    // });

    // json.decode(await SecureStorage.readSecure("dsc_api_test").then((apiTest) !){

    //   if (apiTest['api_test'] != null){
    //     _api = apiTest["api_test"];
    //   }
    // });

    _body = json.encode({
      "_id": id,
      "claim_benefits": benefits
    });

    return await _http.post(
      Uri.parse("https://backend.dangkorsenchey.com/update-claim-benefits"),
      // headers: conceteHeader(key: 'Authorization', value: _tk!['token']),
      headers: conceteHeader(),
      body: _body
    );
  }

  static Future<_http.Response> scanMovieTicket(String code) async {
    
    // json.decode(await SecureStorage.readSecure("dsc_api").then((api) !){
      
    //   _api = api["api"];
    // });

    // json.decode(await SecureStorage.readSecure("dsc_api_test").then((apiTest) !){

    //   if (apiTest['api_test'] != null){
    //     _api = apiTest["api_test"];
    //   }
    // });
    return await _http.post(
      Uri.parse("${_api}movie_ticket/scan_ticket?ticketId=$code"),
      // headers: conceteHeader(key: 'Authorization', value: _tk!['token']),
      headers: conceteHeader(),
    );
  }


  static Future<_http.Response> userAsset(String id) async {

    _body = json.encode({
      "id": id,
    });

    return await _http.post(
      Uri.parse("${_dscApi["api"]}user/asset"),
      // headers: conceteHeader(key: 'Authorization', value: _tk!['token']),
      headers: conceteHeader(),
      body: _body
    );
  }

}