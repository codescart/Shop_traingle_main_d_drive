// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';
//
// class Payment extends StatefulWidget {
//   const Payment();
//   @override
//   State<StatefulWidget> createState() {
//     return _MyAppState();
//   }
// }
//
// class _MyAppState extends State<Payment> {
//   _MyAppState();
//   // late Future<Order> futureAlbum;
//
//   static const platform = MethodChannel("Sagar sandwich");
//    Razorpay _razorpay;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         shadowColor: Colors.transparent,
//         title: const Center(
//           child: Text(
//             'Razorpay',
//             style: TextStyle(
//               color: Colors.black,
//             ),
//           ),
//         ),
//         automaticallyImplyLeading: false,
//       ),
//       body: Column(
//         children: [
//           const SizedBox(
//             height: 20,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.white,
//                     backgroundColor:
//                     const Color.fromARGB(255, 233, 168, 244), // foreground
//                     shadowColor: Colors.transparent,),
//                 onPressed: openCheckout,
//                 child: const Text(
//                   'Pay total price:-totalPrice',
//                   style: TextStyle(color: Colors.black),
//                 ),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     //  (UserSimplePref.getTotalPrice() ?? 1) *
//     var prices = 100;
//     print(prices);
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _razorpay.clear();
//   }
//
//   void openCheckout() async {
//     var prices = 100;
//     print(prices);
//     var options = {
//       //  double.parse(something) *
//       'key': 'rzp_live_lHpffukxVooemY',
//       'amount': 100,
//       'name': 'Sagar Sandwich',
//       'description': "dhfjf",
//       'retry': {'enabled': true, 'max_count': 1},
//       'send_sms_hash': true,
//       'prefill': {'contact': '', 'email': ''},
//       'external': {
//         'wallets': ['paytm']
//       }
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: e');
//     }
//   }
//
//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     print('Success Response: $response');
//
//     // postOrder(
//     //   id, price, count, sizee, response.paymentId.toString(), 'upi',
//     //     totalPrice.toString(), 'success', addressid, context);
//     Text(response.paymentId.toString());
//   }
//
//   void _handlePaymentError(PaymentFailureResponse response) {
//     print('Error Response: $response');
//
//     Fluttertoast.showToast(
//         msg: "ERROR: ${response.code} - ${response.message}",
//         toastLength: Toast.LENGTH_SHORT);
//   }
//
//   void _handleExternalWallet(ExternalWalletResponse response) {
//     print('External SDK Response: $response');
//     Fluttertoast.showToast(
//         msg: "EXTERNAL_WALLET: ${response.walletName}",
//         toastLength: Toast.LENGTH_SHORT);
//   }
// }
//
