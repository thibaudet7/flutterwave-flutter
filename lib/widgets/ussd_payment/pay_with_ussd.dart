import 'package:flutter/material.dart';
import 'package:flutterwave/core/ussd_payment_manager/ussd_manager.dart';
import 'package:flutterwave/models/bank_with_ussd.dart';
import 'package:flutterwave/models/responses/charge_card_response.dart';
import 'package:flutterwave/widgets/ussd_payment/pay_with_ussd_button.dart';
import 'package:flutterwave/widgets/ussd_payment/ussd_details.dart';
import 'package:hexcolor/hexcolor.dart';

class PayWithUssd extends StatefulWidget {
  final USSDPaymentManager _paymentManager;

  PayWithUssd(this._paymentManager);

  @override
  _PayWithUssdState createState() => _PayWithUssdState();
}

class _PayWithUssdState extends State<PayWithUssd> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  BuildContext loadingDialogContext;
  TextEditingController controller = TextEditingController();

  ChargeResponse _chargeResponse;
  bool hasInitiatedPay = false;
  bool hasVerifiedPay = false;
  bool isBottomSheetOpen = false;

  final FocusNode focusNode = FocusNode();
  BanksWithUssd selectedBank;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: this._scaffoldKey,
        appBar: AppBar(
          backgroundColor: Hexcolor("#fff1d0"),
          title: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: "Pay with ",
              style: TextStyle(fontSize: 17, color: Colors.black),
              children: [
                TextSpan(
                  text: "USSD",
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
            child: this._getHomeView(),
          ),
        ),
      ),
    );
  }

  Widget _getHomeView() {
    return this.hasInitiatedPay
        ? USSDDetails(this._chargeResponse, this._verifyTransfer)
        : PayWithUssdButton(this._initiateUSSDPayment, this.controller, this._showBottomSheet);
  }

  Widget _getBanksThatAllowsUssd() {
    final banks = BanksWithUssd.getBanks();
    return Container(
      height: 250,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: banks
            .map((bank) => ListTile(
                  onTap: () => {this._handleBankTap(bank)},
                  title: Column(
                    children: [
                      Text(
                        bank.bankName,
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

  void _handleBankTap(final BanksWithUssd selectedBank) {
    this._removeFocusFromView();
    this.setState(() {
      this.selectedBank = selectedBank;
      this.controller.text = selectedBank.bankName;
    });
    Navigator.pop(this.context);
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return this._getBanksThatAllowsUssd();
        });
    this.setState(() {
      this.isBottomSheetOpen = true;
    });
  }

  void _removeFocusFromView() {
    FocusScope.of(this.context).requestFocus(FocusNode());
  }

  void _initiateUSSDPayment() async {
    if (this.selectedBank != null) {
      print("selected bank is ${this.selectedBank.bankName}");
//      this.setState(() {
//        this.controller.text = this.selectedBank.bankName;
//
//      });
    } else {
      print("selected bank is null");
    }
//    this.showLoading("initiating payment...");
//     final USSDPaymentManager ussdPaymentManager = this.widget._paymentManager;
//    final request = USSDRequest(
//        amount: ussdPaymentManager.amount,
//        currency: ussdPaymentManager.currency,
//        email: ussdPaymentManager.email,
//        txRef: ussdPaymentManager.txRef,
//        fullName: ussdPaymentManager.fullName,
//        accountBank: "058",
//        phoneNumber: ussdPaymentManager.phoneNumber);
//
//    try {
//      final ChargeResponse response = await this
//          .widget
//          ._paymentManager
//          .payWithUSSD(request, http.Client());
//      if (FlutterwaveUtils.SUCCESS == response.status) {
//        this._afterChargeInitiated(response);
//        print("USSD payment from widget ${response.toJson()}");
//      } else {
//        this.showSnackBar(response.message);
//      }
//    } catch (error) {
//      this.showSnackBar(error.toString());
//    } finally {
//      this.closeDialog();
//    }
  }

  void _verifyTransfer() async {
    if (this._chargeResponse != null) {
      this.showLoading("verifying payment...");
//      final client = http.Client();
//      try {
//        final response = await this.widget._paymentManager.verifyPayment(
//            this._bankTransferResponse.meta.authorization.transferReference,
//            client);
//        if (response.data.status == FlutterwaveUtils.SUCCESS &&
//            response.data.amount ==
//                this._bankTransferResponse.meta.authorization.transferAmount
//                    .toString()) {
//          this.closeDialog();
//          print("ref from transfer => ${this._bankTransferResponse.meta.authorization.transferReference}");
//          print("ref from Verification => ${response.data.flwRef}");
//          print("verification successfulin verify => ${response.toJson()}");
//          this.showSnackBar("Payment received");
//        } else {
//          this.showSnackBar(response.message);
//          print("response => ${response.toJson()}");
//        }
//      } catch (error) {
//        this.closeDialog();
//        this.showSnackBar(error.toString());
//      }
    }
  }

  void _afterChargeInitiated(ChargeResponse response) {
    this.setState(() {
      this._chargeResponse = response;
      this.hasInitiatedPay = true;
    });
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
}
