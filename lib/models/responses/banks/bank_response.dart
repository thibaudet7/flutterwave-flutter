import 'bank.dart';

class GetBanksResponse {
  String status;
  String message;
  List<Bank> banks;

  GetBanksResponse({this.status, this.message, this.banks});

  GetBanksResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      banks = List<Bank>();
      json['data'].forEach((bank) {
        banks.add(Bank.fromJson(bank));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.banks != null) {
      data['data'] = this.banks.map((bank) => bank.toJson()).toList();
    }
    return data;
  }
}
