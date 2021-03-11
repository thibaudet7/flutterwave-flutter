class Bank {
  String? id;
  String?name;
  String? code;

  Bank({this.name, this.code, this.id});

  Bank.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    data['id'] = this.id;
    return data;
  }
}