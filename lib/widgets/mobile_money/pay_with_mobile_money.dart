import 'package:flutter/material.dart';
import 'package:flutterwave/core/utils/flutterwave_api_utils.dart';
import 'package:flutterwave/widgets/card_payment/authorization_webview.dart';
import 'package:http/http.dart' as http;
import 'package:flutterwave/core/mobile_money/mobile_money_payment_manager.dart';
import 'package:flutterwave/models/requests/mobile_money/mobile_money_request.dart';
import 'package:flutterwave/utils/flutterwave_utils.dart';
import 'package:hexcolor/hexcolor.dart';

class PayWithMobileMoney extends StatefulWidget {
  final MobileMoneyPaymentManager _paymentManager;

  PayWithMobileMoney(this._paymentManager);

  @override
  _PayWithMobileMoneyState createState() => _PayWithMobileMoneyState();
}

class _PayWithMobileMoneyState extends State<PayWithMobileMoney> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController networkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext loadingDialogContext;

  String selectedNetwork;

  @override
  Widget build(BuildContext context) {
    final String initialPhoneNumber = this.widget._paymentManager.phoneNumber;
    this._phoneNumberController.text =
    initialPhoneNumber != null ? initialPhoneNumber : "";

    final String currency = this.widget._paymentManager.currency;
    return MaterialApp(
      home: Scaffold(
        key: this._scaffoldKey,
        appBar: AppBar(
          backgroundColor: Hexcolor("#fff1d0"),
          title: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: "Pay with ",
              style: TextStyle(fontSize: 20, color: Colors.black),
              children: [
                TextSpan(
                  text: this._getPageTitle(currency),
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
            margin: EdgeInsets.fromLTRB(20, 35, 20, 20),
            width: double.infinity,
            child: Form(
              key: this._formKey,
              child: ListView(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      hintText: "Phone Number",
                    ),
                    controller: this._phoneNumberController,
                    validator: (value) =>
                    value.isEmpty ? "Phone number is required" : null,
                  ),
                  Visibility(
                    visible: currency.toUpperCase() == FlutterwaveUtils.GHS,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      width: double.infinity,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Network",
                          hintText: "Network",
                        ),
                        controller: this.networkController,
                        readOnly: true,
                        onTap: this._showBottomSheet,
                        validator: (value) =>
                        value.isEmpty ? "Network is required" : null,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(0, 40, 0, 20),
                    child: RaisedButton(
                      onPressed: this._onPayPressed,
                      color: Colors.orange,
                      child: Text(
                        "Pay with ${this._getPageTitle(currency)}",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPayPressed() {
    if (this._formKey.currentState.validate()) {
      this._handlePayment();
    }
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        this.loadingDialogContext = context;
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(
                backgroundColor: Colors.orangeAccent,
              ),
              SizedBox(
                width: 40,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        );
      },
    );
  }

  void closeDialog() {
    if (this.loadingDialogContext != null) {
      Navigator.of(this.loadingDialogContext).pop();
      this.loadingDialogContext = null;
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return this._getNetworksThatAllowMobileMoney();
        });
  }

  Widget _getNetworksThatAllowMobileMoney() {
    final networks = FlutterwaveUtils.getAllowedMobileMoneyNetworksByCurrency(
        this.widget._paymentManager.currency);
    return Container(
      height: 150,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: networks
            .map((network) =>
            ListTile(
              onTap: () => {this._handleNetworkTap(network)},
              title: Column(
                children: [
                  Text(
                    network,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(height: 4),
                  Divider(height: 1)
                ],
              ),
            ))
            .toList(),
      ),
    );
  }

  void _handleNetworkTap(final String selectedNetwork) {
    this._removeFocusFromView();
    this.setState(() {
      this.selectedNetwork = selectedNetwork;
      this.networkController.text = selectedNetwork;
    });
    Navigator.pop(this.context);
  }

  void _removeFocusFromView() {
    FocusScope.of(this.context).requestFocus(FocusNode());
  }

  String _getPageTitle(final String currency) {
    switch (currency.toUpperCase()) {
      case FlutterwaveUtils.GHS:
        return "Ghana Mobile Money";
      case FlutterwaveUtils.RWF:
        return "Rwanda Mobile Money";
      case FlutterwaveUtils.ZMW:
        return "Zambia Mobile Money";
      case FlutterwaveUtils.UGX:
        return "Uganda Mobile Money";
    }
    return "";
  }

  void showSnackBar(String message) {
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
    );
    this._scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void _handlePayment() async {
    //todo show loading
    this.showLoading("initiating payment...");
    final MobileMoneyPaymentManager mobileMoneyPaymentManager =
        this.widget._paymentManager;
    final MobileMoneyRequest request = MobileMoneyRequest(
        amount: mobileMoneyPaymentManager.amount,
        currency: mobileMoneyPaymentManager.currency,
//        network: mobileMoneyPaymentManager.network,
        network: this.selectedNetwork,
        txRef: mobileMoneyPaymentManager.txRef,
        fullName: mobileMoneyPaymentManager.fullName,
        email: mobileMoneyPaymentManager.email,
        phoneNumber: this._phoneNumberController.text);

    final http.Client client = http.Client();
    try {
      final response =
      await mobileMoneyPaymentManager.payWithMobileMoney(request, client);
      if (FlutterwaveUtils.SUCCESS == response.status &&
          FlutterwaveUtils.CHARGE_INITIATED == response.message) {
        print("successs");
        print("Mobile Money URL is ${response.meta.authorization.redirect}");
        this.closeDialog();
        this.openOtpScreen(response.meta.authorization.redirect);
        client.close();
      }
    } catch (error) {} finally {
      //todo close dialog
      this.closeDialog();
    }
  }

  Future<dynamic> openOtpScreen(String url) async {
    final result = await Navigator.push(
      this.context,
      MaterialPageRoute(
          builder: (context) => AuthorizationWebview(Uri.encodeFull(url))),
    );
    if (result != null) {
      if (result.runtimeType == " ".runtimeType) {
        this._verifyPayment(result);
      } else {
        this.showSnackBar(result["message"]);
      }
    } else {
      // show error
      print("Transaction not completed.");
    }
  }

  void _verifyPayment(final String flwRef) async {
    this.showLoading("verifying payment...");
    print("FLW Ref in Mobile Money is $flwRef");
    final client = http.Client();
    try {
      final response = await FlutterwaveAPIUtils.verifyPayment(
          flwRef, client, this.widget._paymentManager.publicKey,
          this.widget._paymentManager.isDebugMode);
      if (response.data.status == FlutterwaveUtils.SUCCESS &&
          response.data.amount == this.widget._paymentManager.amount &&
          response.data.flwRef == flwRef) {
        this.showSnackBar("Payment complete.");
        Navigator.pop(this.context, response);
      } else {
        this.closeDialog();
        this.showSnackBar(response.message);
      }
    } catch (error) {
      this.showSnackBar(error.toString());
    } finally {
      client.close();
    }
  }
}
