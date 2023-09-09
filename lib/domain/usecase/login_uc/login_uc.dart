abstract class LoginUsecase {
  
  void initState();
  void changeShow(bool? value);
  void onChanged(int? index);
  String onSubmit(String value);

  Future<void> cacheCheck();
  Future<void> submitLogin();
  
}