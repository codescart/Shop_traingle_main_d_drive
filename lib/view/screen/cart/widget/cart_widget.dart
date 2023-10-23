import 'dart:io';
import 'package:shoptrangle/view/basewidget/my_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoptrangle/data/model/response/cart_model.dart';
import 'package:shoptrangle/helper/price_converter.dart';
import 'package:shoptrangle/localization/language_constrants.dart';
import 'package:shoptrangle/provider/auth_provider.dart';
import 'package:shoptrangle/provider/cart_provider.dart';
import 'package:shoptrangle/provider/splash_provider.dart';
import 'package:shoptrangle/utill/color_resources.dart';
import 'package:shoptrangle/utill/custom_themes.dart';
import 'package:shoptrangle/utill/dimensions.dart';
import 'package:shoptrangle/utill/images.dart';
import 'package:provider/provider.dart';

import '../../../basewidget/animated_custom_dialog.dart';

class CartWidget extends StatefulWidget {
  final CartModel cartModel;
  final int index;
  final int productid;
  final bool fromCheckout;
  const CartWidget({Key key, this.cartModel, @required this.index, @required this.fromCheckout, this.productid});

  @override
  State<CartWidget> createState() => _CartWidgetState();
}
bool _isloading = false;
class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(color: Theme.of(context).highlightColor,

      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment:  MainAxisAlignment.start,
          children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.20),width: 1)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: FadeInImage.assetNetwork(
              placeholder: Images.placeholder, height: 60, width: 60,
              image: '${Provider.of<SplashProvider>(context,listen: false).baseUrls.productThumbnailUrl}/${widget.cartModel.thumbnail}',
              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,fit: BoxFit.cover, height: 60, width: 60),
            ),
          ),
        ),

        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(widget.cartModel.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: titilliumBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_DEFAULT,
                          color: ColorResources.getReviewRattingColor(context),
                        )),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                      !widget.fromCheckout ? InkWell(
                        onTap: () {
                          if(Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
                            Provider.of<CartProvider>(context, listen: false).removeFromCartAPI(context,widget.cartModel.id);
                          }else {
                            Provider.of<CartProvider>(context, listen: false).removeFromCart(widget.index);
                          }
                        },
                        child: Container(width: 20,height: 20,
                            child: Image.asset(Images.delete,scale: .5,)),
                      ) : SizedBox.shrink(),
                    ],

                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Container(
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: filee == null
                                    ? Container()

                                    : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 0.0, right: 15.0, bottom: 8.0),
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color(0xFFF0f0f0),
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ), //Border.all
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,right: 10),
                                      child: Row(
                                        children: [
                                          Text('Image Uploded',
                                            style: TextStyle(color:Colors.black45, ),),
                                          Spacer(),
                                          Icon(Icons.verified_outlined,size: 22,color: Colors.green,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      _choosee();
                                    },
                                    child: Center(
                                      child: Icon(
                                        Icons.add_a_photo

                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      uploadImage();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Processing Data')),);
                                    },
                                    child: Container(
                                      child: filee == null
                                          ? Container()
                                          : Container(
                                        height: 40,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),


                  Row(
                    children: [

                      widget.cartModel.discount>0?
                      Text(
                        PriceConverter.convertPrice(context, widget.cartModel.price),maxLines: 1,overflow: TextOverflow.ellipsis,
                        style: titilliumSemiBold.copyWith(color: ColorResources.getRed(context),
                            decoration: TextDecoration.lineThrough,
                        ),

                      )

                          :SizedBox(),
                      SizedBox(width: Dimensions.FONT_SIZE_DEFAULT,),

                      Text(
                        PriceConverter.convertPrice(context, widget.cartModel.price,
                            discount: widget.cartModel.discount,discountType: 'amount'),
                        maxLines: 1,overflow: TextOverflow.ellipsis,
                        style: titilliumRegular.copyWith(
                            color: ColorResources.getPrimary(context),

                            fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE
                            ),
                      ),
                    ],
                  ),


                  //variation
                  (widget.cartModel.variant != null && widget.cartModel.variant.isNotEmpty) ? Padding(
                    padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                    child: Row(children: [
                      Flexible(child: Text(widget.cartModel.variant,
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
                            color: ColorResources.getReviewRattingColor(context),))),
                    ]),
                  ) : SizedBox(),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),


                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    widget.cartModel.shippingType !='order_wise' && Provider.of<AuthProvider>(context, listen: false).isLoggedIn()?
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      child: Row(children: [
                        Text('${getTranslated('shipping_cost', context)}: ',
                            style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                color: ColorResources.getReviewRattingColor(context))),
                        Text('${PriceConverter.convertPrice(context, widget.cartModel.shippingCost)}',
                            style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,
                          color: Theme.of(context).disabledColor,)),
                      ]),

                    ):SizedBox(),



                    Provider.of<AuthProvider>(context, listen: false).isLoggedIn() ? Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                          child: QuantityButton(isIncrement: false, index: widget.index,
                            quantity: widget.cartModel.quantity,
                            maxQty: widget.cartModel.productInfo.totalCurrentStock,
                            cartModel: widget.cartModel, minimumOrderQuantity: widget.cartModel.productInfo.minimumOrderQty,

                          ),
                        ),

                        Text(widget.cartModel.quantity.toString(), style: titilliumSemiBold),
                        Padding(
                          padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                          child: QuantityButton(index: widget.index, isIncrement: true,
                            quantity: widget.cartModel.quantity,
                            maxQty: widget.cartModel.productInfo.totalCurrentStock,
                            cartModel: widget.cartModel, minimumOrderQuantity: widget.cartModel.productInfo.minimumOrderQty,),
                        ),
                      ],
                    ) : SizedBox.shrink(),
                  ],),

                ],
              ),
          ),
        ),



      ]),
    );
  }

  File filee;

  final pickerr = ImagePicker();

  void _choosee() async {
    final pickedFile = await pickerr.getImage(
      source: ImageSource.gallery,
      // imageQuality: 50,
      // maxHeight: 150,
      // maxWidth: 150,
    );
    setState(() {
      if (pickedFile != null) {
        filee = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImage() async {
    // final prefs = await SharedPreferences.getInstance();
    // final vals = prefs.getString('id') ?? "0";
    // print(vals);
    final prefs= await SharedPreferences.getInstance();
    final usersid=prefs.getString("usersid");
    print("aryman");
    final pid=widget.cartModel.thumbnail;
    print("$pid");

    print("$usersid");
    // print(widget.product.userId);
    // print(widget.product.id);
    var stream = http.ByteStream(filee.openRead());
    stream.cast();
    var length = await filee.length();
    var uri = Uri.parse("https://shoptriangle.in/update.php");
    var request = http.MultipartRequest('POST', uri);
    request.fields['user_id'] = usersid;
    request.fields['image'] ="$pid";
    // request.fields['user_id'] = 40.toString();
    // request.fields['product_id'] = 102.toString();

    var multiport = http.MultipartFile('sendimage', stream, length, filename: (filee.path));
    request.files.add(multiport);
    var response = await request.send();
    print(response);
    if (response.statusCode == 200) {
      showAnimatedDialog(
                    context,
                             MyDialog(
                                  icon: Icons.verified,
                                title: "Image Uploaded Successfully",
                                 ),
                                 dismissible: false,
                                 isFlip: true
                          );
    } else {
      showAnimatedDialog(
          context,
          MyDialog(
            icon: Icons.clear,
            title: "Failed to upload a photo",
          ),
          dismissible: false,
          isFlip: true
      );
      print("abhs");
    }
    // print(respon)
  }
}

class QuantityButton extends StatelessWidget {
  final CartModel cartModel;
  final bool isIncrement;
  final int quantity;
  final int index;
  final int maxQty;
  final int minimumOrderQuantity;
  QuantityButton({@required this.isIncrement, @required this.quantity, @required this.index,
    @required this.maxQty,@required this.cartModel, this.minimumOrderQuantity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print('--qqq-->$quantity/$minimumOrderQuantity');
        if (!isIncrement && quantity > minimumOrderQuantity) {
            Provider.of<CartProvider>(context, listen: false).updateCartProductQuantity(cartModel.id,cartModel.quantity-1, context).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(value.message), backgroundColor: value.isSuccess ? Colors.green : Colors.red,
              ));
            });
        } else if (isIncrement && quantity < maxQty) {
          Provider.of<CartProvider>(context, listen: false).updateCartProductQuantity(cartModel.id, cartModel.quantity+1, context).then((value) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(value.message), backgroundColor: value.isSuccess ? Colors.green : Colors.red,
            ));
          });
        }
      },
      child: Icon(
        isIncrement ? Icons.add_circle : Icons.remove_circle,
        color: isIncrement
            ? quantity >= maxQty ? ColorResources.getGrey(context)
            : ColorResources.getPrimary(context)
            : quantity > 1
            ? ColorResources.getPrimary(context)
            : ColorResources.getGrey(context),
        size: 30,
      ),
    );
  }
}

