class BankTransferRequest {
  String amount;
  String currency;
  int duration;
  String email;
  int frequency;
  bool isPermanent;
  String narration;
  String txRef;

  BankTransferRequest({
    this.amount,
    this.currency,
    this.duration,
    this.email,
    this.frequency,
    this.isPermanent,
    this.narration,
    this.txRef,
  });

  BankTransferRequest.fromJson(Map<String, dynamic> json) {
    this.amount = json['amount'];
    this.currency = json['currency'];
    this.duration = json['duration'];
    this.email = json['email'];
    this.frequency = json['frequency'];
    this.isPermanent = json['is_permanent'];
    this.narration = json['narration'];
    this.txRef = json['tx_ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['currency'] = this.currency;
    data['duration'] = this.duration;
    data['email'] = this.email;
    data['frequency'] = this.frequency;
    data['is_permanent'] = this.isPermanent;
    data['narration'] = this.narration;
    data['tx_ref'] = this.txRef;
    return data;
  }
}
