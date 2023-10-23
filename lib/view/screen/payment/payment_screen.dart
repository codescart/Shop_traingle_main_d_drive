import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoptrangle/localization/language_constrants.dart';
import 'package:shoptrangle/utill/app_constants.dart';
import 'package:shoptrangle/view/basewidget/animated_custom_dialog.dart';
import 'package:shoptrangle/view/basewidget/custom_app_bar.dart';
import 'package:shoptrangle/view/basewidget/custom_loader.dart';
import 'package:shoptrangle/view/basewidget/my_dialog.dart';
import 'package:shoptrangle/view/screen/dashboard/dashboard_screen.dart';
import 'package:shoptrangle/view/screen/checkout/checkout_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final String addressID;
  final String billingId;
  final String orderNote;
  final String customerID;
  final String couponCode;
  final int pay;
  PaymentScreen({
    @required this.addressID,
    @required this.customerID,
    @required this.couponCode,
    @required this.billingId,
    @required this.pay,
    this.orderNote,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {

  static const platform = MethodChannel("Shop Triangle");
  Razorpay _razorpay;
  String selectedUrl;
  double value = 0.0;
  bool _isLoading = true;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController controllerGlobal;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    selectedUrl =
        '${AppConstants.BASE_URL}/customer/payment-mobile?customer_id='
        '${widget.customerID}&address_id=${widget.addressID}&coupon_code='
        '${widget.couponCode}&billing_address_id=${widget.billingId}&order_note=${widget.orderNote}';
    print(selectedUrl);

    openCheckout();
    //print("fjdfkjcn");
    // await launch(selectedUrl);
    // Navigator.pop(context);
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Pay Now'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(height: 30,),
         InkWell(
           onTap: (){Navigator.pop(context);},
           child:  Container(
             height: 100,
             width: 200,
             decoration: BoxDecoration(
               color: Colors.red,
                 border: Border.all(
                   color: Colors.red[500],
                 ),
                 borderRadius: BorderRadius.all(Radius.circular(20))
             ),
             child: Padding(padding: EdgeInsets.all(20),
               child: Text("Please hold on don't \n press back button",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
         ),)


        ],
      ),
    );

    //   WillPopScope(
    //   onWillPop: () => _exitApp(context),
    //   child: Scaffold(
    //     backgroundColor: Theme.of(context).primaryColor,
    //     body: Column(
    //       children: [
    //         CustomAppBar(
    //             title: getTranslated('PAYMENT', context),
    //             onBackPressed: () => _exitApp(context)
    //         ),
    //         Expanded(
    //           child: Stack(
    //             children: [
    //               TextButton(
    //               onPressed: () async {
    //         var url = selectedUrl;
    //
    //         if(await canLaunch(url)){
    //         //forceWebView is true now
    //         }else {
    //         throw 'Could not launch $url';
    //         }
    //         },),
    //               ElevatedButton(
    //                 style: ElevatedButton.styleFrom(
    //                   foregroundColor: Colors.white,
    //                   backgroundColor:
    //                   const Color.fromARGB(255, 233, 168, 244), // foreground
    //                   shadowColor: Colors.transparent,),
    //                 onPressed: openCheckout,
    //                 child: const Text(
    //                   'Pay total price:-totalPrice',
    //                   style: TextStyle(color: Colors.black),
    //                 ),
    //               )
    //               // WebView(
    //               //   javascriptMode: JavascriptMode.unrestricted,
    //               //   initialUrl: selectedUrl,
    //               //   gestureNavigationEnabled: true,
    //               //   userAgent:
    //               //       'Mozilla/5.0 (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Version/9.0 Mobile/13E233 Safari/601.1',
    //               //   onWebViewCreated: (WebViewController webViewController) {
    //               //     _controller.future
    //               //         .then((value) => controllerGlobal = value);
    //               //     _controller.complete(webViewController);
    //               //   },
    //               //   onPageStarted: (String url) {
    //               //     print('Started url: $url');
    //               //     if (url.contains(AppConstants.BASE_URL)) {
    //               //       bool _isSuccess = url.contains('success');
    //               //       bool _isFailed = url.contains('fail');
    //               //       setState(() {
    //               //         _isLoading = true;
    //               //       });
    //               //       if (_isSuccess) {
    //               //         Navigator.of(context).pushAndRemoveUntil(
    //               //             MaterialPageRoute(
    //               //                 builder: (_) => DashBoardScreen()
    //               //             ),
    //               //             (route) => false
    //               //         );
    //               //         showAnimatedDialog(
    //               //             context,
    //               //             MyDialog(
    //               //               icon: Icons.done,
    //               //               title: getTranslated('payment_done', context),
    //               //               description: getTranslated(
    //               //                   'your_payment_successfully_done', context),
    //               //             ),
    //               //             dismissible: false,
    //               //             isFlip: true);
    //               //       } else if (_isFailed) {
    //               //         Navigator.of(context).pushAndRemoveUntil(
    //               //             MaterialPageRoute(
    //               //                 builder: (_) => DashBoardScreen(),
    //               //             ),
    //               //             (route) => false
    //               //         );
    //               //
    //               //         showAnimatedDialog(
    //               //             context,
    //               //             MyDialog(
    //               //               icon: Icons.clear,
    //               //               title: getTranslated('payment_failed', context),
    //               //               description: getTranslated(
    //               //                   'your_payment_failed', context),
    //               //               isFailed: true,
    //               //             ),
    //               //             dismissible: false,
    //               //             isFlip: true
    //               //         );
    //               //       } else if (url == '${AppConstants.BASE_URL}/cancel') {
    //               //         Navigator.of(context).pushAndRemoveUntil(
    //               //             MaterialPageRoute(
    //               //                 builder: (_) => DashBoardScreen()),
    //               //             (route) => false);
    //               //         showAnimatedDialog(
    //               //             context,
    //               //             MyDialog(
    //               //               icon: Icons.clear,
    //               //               title:
    //               //                   getTranslated('payment_cancelled', context),
    //               //               description: getTranslated(
    //               //                   'your_payment_cancelled', context),
    //               //               isFailed: true,
    //               //             ),
    //               //             dismissible: false,
    //               //             isFlip: true
    //        //         );
    //               //       }
    //               //     }
    //               //   },
    //               //   onPageFinished: (String url) {
    //               //     print('Started url: $url');
    //               //     setState(() {
    //               //       _isLoading = false;
    //               //     });
    //               //   },
    //               // ),
    //               // _isLoading
    //               //     ? Center(
    //               //         child: CustomLoader(
    //               //             color: Theme.of(context).primaryColor
    //               //         ),
    //               //       )
    //               //     : SizedBox.shrink(),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }


  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {



    var options = {
      //  double.parse(something) *
      'key': 'rzp_live_6PzrGWFzbKwqUN',
      'amount':widget.pay,
      'name': 'Shop Traingle',
      'description': "dhfjf",
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response)async {
    print('Success Response: $response');
    final res= await http.get(Uri.parse(selectedUrl));
    final data= json.decode(res.body);
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => DashBoardScreen()),
            (route) => false);
    showAnimatedDialog(
        context,
        MyDialog(
          icon: Icons.check,
          title: getTranslated('order_placed', context),
          description: getTranslated('your_order_placed', context),
          isFailed: false,
        ),
        dismissible: false,
        isFlip: true);
    // Navigator.push(context, MaterialPageRoute(builder: (context)=> DashBoardScreen()));
  }

  void _handlePaymentError(PaymentFailureResponse response)async {
    print('Error Response: $response');

    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message}",
        toastLength: Toast.LENGTH_SHORT);

  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: ${response.walletName}",
        toastLength: Toast.LENGTH_SHORT);
  }

}
