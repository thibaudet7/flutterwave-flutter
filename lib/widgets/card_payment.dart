import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutterwave/core/interfaces/card_payment_listener.dart';
import 'package:flutterwave/models/responses/charge_card_response/charge_card_response.dart';
import 'package:flutterwave/widgets/request_otp.dart';
import 'package:flutterwave/widgets/request_pin.dart';
import 'package:flutterwave/core/flutterwave_payment_manager.dart';
import 'package:flutterwave/models/requests/charge_card_request.dart';

class CardPayment extends StatefulWidget {

  final FlutterwavePaymentManager _paymentManager;

  CardPayment(this._paymentManager);

  @override
  _CardPaymentState createState() => _CardPaymentState();
}

class _CardPaymentState extends State<CardPayment>
    implements CardPaymentListener {
  final _cardFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final TextEditingController _cardNumberFieldController =
      TextEditingController();
  final TextEditingController _cardMonthFieldController =
      TextEditingController();
  final TextEditingController _cardYearFieldController =
      TextEditingController();
  final TextEditingController _cardCvvFieldController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    this._cardMonthFieldController.dispose();
    this._cardYearFieldController.dispose();
    this._cardCvvFieldController.dispose();
    this._cardNumberFieldController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: this._scaffoldKey,
        body: Form(
          key: this._cardFormKey,
          child: Container(
            margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
            width: double.infinity,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: "Card Number",
//                  labelText: "Card Number",
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                    ),
                    controller: this._cardNumberFieldController,
                    validator: this._validateCardField,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      margin: EdgeInsets.all(20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Month",
                          labelStyle: TextStyle(
                            color: Colors.black26,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        controller: this._cardMonthFieldController,
                        validator: this._validateCardField,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      margin: EdgeInsets.all(20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "Year",
                          labelStyle: TextStyle(
                            color: Colors.black26,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        controller: this._cardYearFieldController,
                        validator: this._validateCardField,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 5,
                      margin: EdgeInsets.fromLTRB(30, 20, 5, 20),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "CVV",
                          labelStyle: TextStyle(
                            color: Colors.black26,
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        autocorrect: false,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                        ),
                        controller: this._cardCvvFieldController,
                        validator: this._validateCardField,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 45,
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: RaisedButton(
                    onPressed: this._onCardFormClick,
                    color: Colors.orangeAccent,
                    child: Text(
                      "PAY",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: 1.0,
                  width: double.infinity,
                  color: Colors.black26,
                  margin: EdgeInsets.fromLTRB(25, 1, 25, 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onCardFormClick() {
    this._hideKeyboard();
    if (this._cardFormKey.currentState.validate()) {
      this.showConfirmPaymentModal();
    }
  }

  void _makeCardPayment() {
    Navigator.of(this.context).pop();
    //TODO show loading indicator
    final ChargeCardRequest chargeCardRequest = ChargeCardRequest(
        cardNumber: this._cardNumberFieldController.value.text,
        cvv: this._cardCvvFieldController.value.text,
        expiryMonth: this._cardMonthFieldController.value.text,
        expiryYear: this._cardYearFieldController.value.text,
        currency: this.widget._paymentManager.currency,
        amount: this.widget._paymentManager.amount,
        email: this.widget._paymentManager.email,
        fullName: this.widget._paymentManager.fullName,
        txRef: this.widget._paymentManager.txRef);
    final client = http.Client();
    this.widget._paymentManager.payWithCard(client, chargeCardRequest, this);
  }

  Future<void> showConfirmPaymentModal() async {
    return showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            content: Text(
              "You will be charged a total of ${this.widget._paymentManager.amount} NGN. Do you wish to continue? ",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            actions: [
              FlatButton(
                onPressed: this._makeCardPayment,
                child: Text("YES, PAY"),
              ),
              FlatButton(
                onPressed: () => {Navigator.of(this.context).pop()},
                child: Text("CANCEL"),
              )
            ],
          );
        });
  }

  String _validateCardField(String value) {
    return value.trim().isEmpty ? "Please fill this" : null;
  }

  void _hideKeyboard() {
    FocusScope.of(this.context).requestFocus(FocusNode());
  }

  Future<dynamic> openAuthModal() async {
    return showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            content: RequestPin(this.widget._paymentManager)
          );
        });
  }

  Future<dynamic> openOTPModal({String message}) async {
    return showDialog(
        context: this.context,
        barrierDismissible: false,
        builder: (BuildContext buildContext) {
          return AlertDialog(
              content: RequestOTP(message)
          );
        });
  }

  @override
  void onRedirect(ChargeCardResponse response, String url) {
    // TODO: implement onRedirect
    print("Redirect called in Widget. URL => $url");
  }

  @override
  void onRequireAddress(ChargeCardResponse response) {
    // TODO: implement onRequireAddress
    print("Require Address called in Widget");
  }

  @override
  void onRequirePin(ChargeCardResponse response) async {
    print("Require pin called in Widget");
    final result = await this.openAuthModal();
    print("Result after opening is $result");
  }

  @override
  void onRequireOTP(ChargeCardResponse response, String message ) async{
    // TODO: open OTP widget
    print("Require OTP called in Widget");
    final otp = await this.openOTPModal(message: message);
    final client = http.Client();
    this.widget._paymentManager.validatePayment(otp, response.data.flwRef, client);
  }

  @override
  void onError(String error) {
    SnackBar snackBar = SnackBar(
      content: Text(
        error,
        textAlign: TextAlign.center,
      ),
    );
    this._scaffoldKey.currentState.showSnackBar(snackBar);
    print("On Error called in Widget => $error");
  }


}
