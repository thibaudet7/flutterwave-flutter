abstract class CardPaymentListener {
  void onRequirePin() {}

  void onRequireOTP() {}

  void onRequireAddress() {}

  void onRedirect(String url) {}

  void onError(String error) {}
}
