import 'dart:convert';
import 'dart:io';
import 'package:flutterwave/models/responses/charge_card_response/charge_card_response.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutterwave/models/requests/charge_card_request.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';

class FlutterwavePaymentManager {
  String publicKey;
  String encryptionKey;
  String currency;
  String amount;
  String email;
  String fullName;
  String txRef;
  String redirectUrl;
  bool isDebugMode;
  ChargeCardRequest chargeCardRequest;

  FlutterwavePaymentManager({
    @required this.publicKey,
    @required this.encryptionKey,
    @required this.currency,
    @required this.amount,
    @required this.email,
    @required this.fullName,
    @required this.txRef,
    @required this.isDebugMode,
    this.redirectUrl,
  });

  Future<dynamic> payWithCard(final http.Client client,
      final ChargeCardRequest chargeCardRequest) async {
    this.chargeCardRequest = chargeCardRequest;

    final Map<String, String> encryptedPayload =
        this._prepareRequest(chargeCardRequest);

    final url = FlutterwaveUtils.BASE_URL + FlutterwaveUtils.CHARGE_CARD_URL;
    final http.Response response = await client.post(
      url,
      headers: {HttpHeaders.authorizationHeader: this.publicKey},
      body: encryptedPayload,
    );
    try {
      final responseBody =
          ChargeCardResponse.fromJson(jsonDecode(response.body));

      print("Response code is ${response.statusCode}");
      print("Response body is ${responseBody.meta.authorization.mode}");
      print("Parsed response is ${responseBody.toJson()}");
    } catch (e) {
      print("Error is ${e.toString()}");
    }
  }

  Map<String, String> _prepareRequest(
      final ChargeCardRequest chargeCardRequest) {
    final String encryptedChargeRequest = FlutterwaveUtils.TripleDESEncrypt(
        jsonEncode(chargeCardRequest.toJson()), encryptionKey);
    return FlutterwaveUtils.encryptRequest(encryptedChargeRequest);
  }
}
