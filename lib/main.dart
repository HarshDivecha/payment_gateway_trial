import 'dart:convert';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:payment_gateway_trial/models/token_response.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: DummyHomepage()
    );
  }
}

class DummyHomepage extends StatefulWidget {
  @override
  _DummyHomepageState createState() => _DummyHomepageState();
}

class _DummyHomepageState extends State<DummyHomepage> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: Text("Generate Token"),
                onPressed: (){generateToken("123",'300');}
                ),
            RaisedButton(
                child: Text("Simulate Payment"),
                onPressed: (){pay();}
            ),
          ],
        ),
      ),
    );
  }



  Future<String> generateToken(String orderId,String amount) async {
    String token;
    await http.post(
        'https://test.cashfree.com/api/v2/cftoken/order',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-client-id': '383799acf2e3fff86aeb130b497383',
          'x-client-secret': '7f662c4add6c116e8566eb917bd1f309c2da2279'
        },
        body: jsonEncode(<String, String>{
          "orderId":orderId,
          "orderCurrency":"INR",
          "orderAmount":amount,
        }),
      ).then( (response){
      TokenResponse tokenObj= TokenResponse.fromJson(jsonDecode(response.body));
      // print(response.body);
      print(tokenObj.cftoken);
      token= tokenObj.cftoken;
    })
        ;
    return token;
  }

  void pay()async{
    String token;
   await generateToken("123", "300").then((value) => token=value);
    if(token!=null) {
      String stage = "TEST";
      String orderId = "123";
      String orderAmount = "300";
      String tokenData = token;
      String customerName = "Customer Name";
      String orderNote = "Order Note";
      String orderCurrency = "INR";
      String appId = "383799acf2e3fff86aeb130b497383";
      String customerPhone = "9999999999";
      String customerEmail = "sample@gmail.com";
      String notifyUrl = "https://test.gocashfree.com/notify";

      Map<String, dynamic> inputParams = {
        "tokenData":tokenData,
        "orderId": orderId,
        "orderAmount": orderAmount,
        "customerName": customerName,
        "orderNote": orderNote,
        "orderCurrency": orderCurrency,
        "appId": appId,
        "customerPhone": customerPhone,
        "customerEmail": customerEmail,
        "stage": stage,
        "notifyUrl": notifyUrl,
      };

      inputParams["paymentOption"] = 'card';
      inputParams["card_number"] = '4434260000000008'; //Replace Card number
      inputParams["card_expiryMonth"] = '05'; // Card Expiry Month in MM
      inputParams["card_expiryYear"] = '2021'; // Card Expiry Year in YYYY
      inputParams["card_holder"] = 'John Doe'; // Card Holder name
      inputParams["card_cvv"] = '123'; // Card CVV

      CashfreePGSDK.doPayment(inputParams)
          .then((value) => value?.forEach((key, value) {
                print("$key : $value");
              }));
    }
  }

}


