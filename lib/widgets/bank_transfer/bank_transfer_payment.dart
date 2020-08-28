import 'package:flutter/material.dart';
import 'package:flutterwave/models/requests/bank_transfer/bank_transfer_request.dart';
import 'package:flutterwave/models/responses/bank_transfer_response/bank_transfer_response.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:flutterwave/widgets/bank_transfer/show_transfer_details.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutterwave/core/bank_transfer_manager/bank_transfer_payment_manager.dart';
import 'package:flutterwave/widgets/bank_transfer/pay_with_account_button.dart';

class BankTransfer extends StatefulWidget {

  final BankTransferPaymentManager _paymentManager;

  BankTransfer(this._paymentManager);

  @override
  _BankTransferState createState() => _BankTransferState();
}

class _BankTransferState extends State<BankTransfer> {

  BankTransferResponse _bankTransferResponse;
  bool hasInitiatedPay = false;
  bool hasVerifiedPay = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Hexcolor("#fff1d0"),
            title: RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: "Pay with ",
                style: TextStyle(fontSize: 17, color: Colors.black),
                children: [
                  TextSpan(
                    text: "Bank Transfer",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black),
                  )
                ],
              ),
            ),
          ),
          body: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  width: double.infinity,
                  child: this._getHomeView()))),
    );
  }

  Widget _getHomeView() {
    return this.hasInitiatedPay
        ? AccountDetails(this._bankTransferResponse, this._verifyTransfer)
        : PayWithTransferButton(this._initiateBankTransfer);
  }

  void _initiateBankTransfer() async {
    //todo show initiating payment loader
    final http.Client client = http.Client();
    final BankTransferRequest request = BankTransferRequest(
        amount: this.widget._paymentManager.amount,
        currency: this.widget._paymentManager.currency,
        duration: this.widget._paymentManager.duration.toString(),
        email: this.widget._paymentManager.email,
        frequency: this.widget._paymentManager.frequency.toString(),
        isPermanent: this.widget._paymentManager.isPermanent.toString(),
        narration: this.widget._paymentManager.narration,
        phoneNumber: this.widget._paymentManager.phoneNumber,
        txRef: this.widget._paymentManager.txRef);

    try {
      final BankTransferResponse response =
      await this.widget._paymentManager.payWithBankTransfer(request, client);
      //
      if (FlutterwaveUtils.SUCCESS == response.status) {
        //todo hide loader
        this._afterChargeInitiated(response);
        //todo show other screen for payment verification
      }
    } catch(error) {

    }
  }

  void _verifyTransfer() {
    if (this._bankTransferResponse != null) {
      //todo show loader
      print("Should start verification");
    }

  }

  void _afterChargeInitiated(BankTransferResponse response) {
    this.setState(() {
      this._bankTransferResponse = response;
      this.hasInitiatedPay = true;
    });
  }
}
