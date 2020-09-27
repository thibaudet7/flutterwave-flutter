import 'package:flutter_test/flutter_test.dart';
import 'package:flutterwave/models/requests/bank_transfer/bank_transfer_request.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';

main() {
  group("Bank Transfer Request", () {
    final bankTransferRequest = BankTransferRequest(
        amount: "100",
        currency: FlutterwaveUtils.NGN,
        duration: "3",
        email: "email.com",
        frequency: "3",
        isPermanent: "false",
        narration: "some narration",
        txRef: "some_ref",
        phoneNumber: "12345");

    test("Objects should initialize correctly", () {
      expect("100", bankTransferRequest.amount);
      expect("NGN", bankTransferRequest.currency);
      expect("3", bankTransferRequest.frequency);
    });

    test("toJson() should work correctly", () {
      final json = bankTransferRequest.toJson();

      expect(true, json != null);
      expect("some narration", json["narration"]);
      expect("12345", json["phone_number"]);
      expect("email.com", json["email"]);
    });

    test("should initiate properly fromJson()", () {
      final json = bankTransferRequest.toJson();
      final bt = BankTransferRequest.fromJson(json);

      expect(true, bt.runtimeType == BankTransferRequest().runtimeType);
      expect(bt.narration, json["narration"]);
      expect(bt.phoneNumber, json["phone_number"]);
      expect(bt.email, json["email"]);
    });
  });
}
