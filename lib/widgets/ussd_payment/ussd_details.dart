import 'package:flutter/material.dart';
import 'package:flutterwave/models/requests/authorization.dart';
import 'package:flutterwave/models/responses/charge_card_response.dart';

class USSDDetails extends StatelessWidget {
  final Function _onPaymentMade;
  final ChargeResponse _chargeResponse;

  USSDDetails(this._chargeResponse, this._onPaymentMade);

  @override
  Widget build(BuildContext context) {
    final Authorization authorization = this._chargeResponse.meta.authorization;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20, 40, 20, 20),
      child: Column(
        children: [
          Text(
            "Dial the code below to complete the payment:",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          SizedBox(height: 80),
          Text(
            authorization.note,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 80),
          Container(
            height: 40,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(5, 10, 20, 5),
            child: RaisedButton(
              onPressed: this._onPaymentMade,
              color: Colors.orange,
              child: Text(
                "I have made the transfer",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
