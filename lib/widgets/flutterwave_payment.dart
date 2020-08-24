import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave_payment_manager.dart';

class FlutterwaveUI extends StatefulWidget {
  FlutterwaveUI(FlutterwavePaymentManager paymentManager);

  @override
  _FlutterwaveUIState createState() => _FlutterwaveUIState();
}

class _FlutterwaveUIState extends State<FlutterwaveUI> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.lock,
                    size: 5.0,
                    color: Colors.black,
                  ),
                  Text(
                    "SECURED BY FLUTTERWAVE",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
                        height: 10.0,
                        letterSpacing: 3.0),
                  )
                ],
              ),
              SizedBox(
                width: double.infinity,
                height: 50.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Text(
                  "How would you like to pay",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 30.0,
                      height: 10.0,
                      letterSpacing: 3.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
