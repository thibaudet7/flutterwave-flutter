
import 'bank_transfer_meta.dart';

class BankTranferResponse {
  String status;
  String message;
  BankTransferMeta meta;

  BankTranferResponse({this.status, this.message, this.meta});

  BankTranferResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    meta = json['meta'] != null ? new BankTransferMeta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    return data;
  }
}
