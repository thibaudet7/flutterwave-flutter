class Authorization {
  static const String AVS = "avs_noauth";
  static const String REDIRECT = "redirect";
  static const String OTP = "otp";
  static const String PIN = "pin";

  String mode;
  String pin;
  String endpoint;
  String redirect;
  List<dynamic> fields;

  Authorization({this.mode, this.endpoint});


  Authorization.fromJson(Map<String, dynamic> json) {
    this.mode = json['mode'];
    this.endpoint = json['endpoint'];
    this.fields = json["fields"];
    this.redirect = json["redirect"];
    this.pin = json["pin"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["mode"] = this.mode;
    data["endpoint"] = this.endpoint;
    data["fields"] = this.fields;
    data["redirect"] = this.redirect;
    data["pin"] = this.pin;
    return data;
  }

}