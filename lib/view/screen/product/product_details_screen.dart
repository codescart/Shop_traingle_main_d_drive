import 'dart:io';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shoptrangle/helper/product_type.dart';
import 'package:shoptrangle/provider/auth_provider.dart';
import 'package:shoptrangle/utill/color_resources.dart';
import 'package:shoptrangle/view/basewidget/rating_bar.dart';
import 'package:shoptrangle/view/screen/home/widget/products_view.dart';
import 'package:shoptrangle/view/screen/product/widget/promise_screen.dart';
import 'package:shoptrangle/view/screen/product/widget/seller_view.dart';
import 'package:shoptrangle/data/model/response/product_model.dart';

import 'package:shoptrangle/localization/language_constrants.dart';
import 'package:shoptrangle/provider/product_details_provider.dart';
import 'package:shoptrangle/provider/product_provider.dart';
import 'package:shoptrangle/provider/theme_provider.dart';
import 'package:shoptrangle/provider/wishlist_provider.dart';
import 'package:shoptrangle/utill/custom_themes.dart';
import 'package:shoptrangle/utill/dimensions.dart';
import 'package:shoptrangle/view/basewidget/no_internet_screen.dart';
import 'package:shoptrangle/view/basewidget/title_row.dart';
import 'package:shoptrangle/view/screen/product/widget/bottom_cart_view.dart';
import 'package:shoptrangle/view/screen/product/widget/product_image_view.dart';
import 'package:shoptrangle/view/screen/product/widget/product_specification_view.dart';
import 'package:shoptrangle/view/screen/product/widget/product_title_view.dart';
import 'package:shoptrangle/view/screen/product/widget/related_product_view.dart';
import 'package:shoptrangle/view/screen/product/widget/review_widget.dart';
import 'package:shoptrangle/view/screen/product/widget/youtube_video_widget.dart';
import 'package:provider/provider.dart';

import 'faq_and_review_screen.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  ProductDetails({
    @required this.product,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  // File file;
  // final picker = ImagePicker();
  // final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
  //     GlobalKey<ScaffoldMessengerState>();

  // void _choose() async {
  //   final pickedFile = await picker.pickImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 50,
  //       maxHeight: 500,
  //       maxWidth: 500);
  //   setState(() {
  //     if (pickedFile != null) {
  //       file = File(pickedFile.path);
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }

  _loadData(BuildContext context) async {
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .removePrevReview();
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .initProduct(widget.product, context);
    Provider.of<ProductProvider>(context, listen: false)
        .removePrevRelatedProduct();
    Provider.of<ProductProvider>(context, listen: false)
        .initRelatedProductList(widget.product.id.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getCount(widget.product.id.toString(), context);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .getSharableLink(widget.product.slug.toString(), context);
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<WishListProvider>(context, listen: false)
          .checkWishList(widget.product.id.toString(), context);
    }
    //Provider.of<ProductProvider>(context, listen: false).initSellerProductList(widget.product.userId.toString(), 1, context);
  }

  @override
  Widget build(BuildContext context) {
    // final SharedPreferences sharedPreferences;
    ScrollController _scrollController = ScrollController();
    String ratting = widget.product != null &&
            widget.product.rating != null &&
            widget.product.rating.length != 0
        ? widget.product.rating[0].average.toString()
        : "0";
    _loadData(context);
    return widget.product != null
        ? Consumer<ProductDetailsProvider>(
            builder: (context, details, child) {
              return details.hasConnection
                  ? Scaffold(
                      backgroundColor: Theme.of(context).cardColor,
                      appBar: AppBar(
                        title: Row(children: [
                          InkWell(
                            child: Icon(Icons.arrow_back_ios,
                                color: Theme.of(context).cardColor, size: 20),
                            onTap: () => Navigator.pop(context),
                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          Text(getTranslated('product_details', context),
                              style: robotoRegular.copyWith(
                                  fontSize: 20,
                                  color: Theme.of(context).cardColor)),
                        ]),
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        backgroundColor:
                            Provider.of<ThemeProvider>(context).darkTheme
                                ? Colors.black
                                : null,
                      ),
                      bottomNavigationBar:
                          BottomCartView(product: widget.product),
                      body: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            widget.product != null
                                ? ProductImageView(productModel: widget.product)
                                : SizedBox(),
                            Container(
                              transform:
                                  Matrix4.translationValues(0.0, -25.0, 0.0),
                              padding: EdgeInsets.only(
                                  top: Dimensions.FONT_SIZE_DEFAULT),
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                  ),
                                  topRight: Radius.circular(
                                    Dimensions.PADDING_SIZE_EXTRA_LARGE,
                                  ),
                                ),
                              ),
                              child: Column(
                                children: [
                                  // Text("data"),

                                  // Padding(
                                  //   padding: const EdgeInsets.only(
                                  //     left: 10,
                                  //     right: 10,
                                  //   ),
                                  //   child: Row(
                                  //     children: [
                                  //       Container(
                                  //         alignment: Alignment.center,
                                  //         decoration: BoxDecoration(
                                  //           color: Theme.of(context).cardColor,
                                  //           border: Border.all(
                                  //             color: Colors.white,
                                  //             width: 3,
                                  //           ),
                                  //           shape: BoxShape.circle,
                                  //         ),
                                  //         child: Stack(
                                  //           clipBehavior: Clip.none,
                                  //           children: [
                                  //             Container(
                                  //               height: 50,
                                  //               width: 150,
                                  //               child: file == null
                                  //                   ? FadeInImage.assetNetwork(
                                  //                       placeholder:
                                  //                           Images.placeholder,
                                  //                       width: Dimensions
                                  //                           .profileImageSize,
                                  //                       height: Dimensions
                                  //                           .profileImageSize,
                                  //                       fit: BoxFit.cover,
                                  //                       image:
                                  //                           Images.placeholder,
                                  //                       // image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profile.userInfoModel.image}',
                                  //                       imageErrorBuilder: (
                                  //                         c,
                                  //                         o,
                                  //                         s,
                                  //                       ) =>
                                  //                           Image.asset(
                                  //                         Images.placeholder,
                                  //                         width: Dimensions
                                  //                             .profileImageSize,
                                  //                         height: Dimensions
                                  //                             .profileImageSize,
                                  //                         fit: BoxFit.cover,
                                  //                       ),
                                  //                     )
                                  //                   : Image.file(
                                  //                       file,
                                  //                       width: Dimensions
                                  //                           .profileImageSize,
                                  //                       height: Dimensions
                                  //                           .profileImageSize,
                                  //                       fit: BoxFit.fill,
                                  //                     ),
                                  //             ),
                                  //             Positioned(
                                  //               bottom: 0,
                                  //               right: -10,
                                  //               child: CircleAvatar(
                                  //                 backgroundColor:
                                  //                     ColorResources
                                  //                         .LIGHT_SKY_BLUE,
                                  //                 radius: 14,
                                  //                 child: IconButton(
                                  //                   onPressed: _choose,
                                  //                   padding: EdgeInsets.all(
                                  //                     0,
                                  //                   ),
                                  //                   icon: Icon(
                                  //                     Icons.edit,
                                  //                     color:
                                  //                         ColorResources.WHITE,
                                  //                     size: 18,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       Spacer(),
                                  //       Container(
                                  //         height: 50,
                                  //         width: 150,
                                  //         decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.all(
                                  //             Radius.circular(
                                  //               20,
                                  //             ),
                                  //           ),
                                  //           color: Colors.red,
                                  //         ),
                                  //         child: Center(
                                  //           child: Text(
                                  //             "Upload your image",
                                  //             style: TextStyle(
                                  //               color: Colors.white,
                                  //               fontWeight: FontWeight.bold,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),

                                  ProductTitleView(
                                      productModel: widget.product),
                                  (widget.product.details != null &&
                                          widget.product.details.isNotEmpty)
                                      ? Container(
                                          height: 250,
                                          margin: EdgeInsets.only(
                                              top: Dimensions
                                                  .PADDING_SIZE_SMALL),
                                          padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          child: ProductSpecification(
                                            productSpecification:
                                                widget.product.details ?? '',
                                          ),
                                        )
                                      : SizedBox(),
                                  widget.product.videoUrl != null
                                      ? YoutubeVideoWidget(
                                          url: widget.product.videoUrl,
                                        )
                                      : SizedBox(),
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.PADDING_SIZE_DEFAULT,
                                          horizontal:
                                              Dimensions.FONT_SIZE_DEFAULT),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor),
                                      child: PromiseScreen()),
                                  widget.product.addedBy == 'seller'
                                      ? SellerView(
                                          sellerId:
                                              widget.product.userId.toString())
                                      : SizedBox.shrink(),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(
                                      top: Dimensions.PADDING_SIZE_SMALL,
                                    ),
                                    padding: EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_DEFAULT,
                                    ),
                                    color: Theme.of(context).cardColor,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            getTranslated(
                                                'customer_reviews', context),
                                            style: titilliumSemiBold.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_LARGE),
                                          ),
                                          SizedBox(
                                            height:
                                                Dimensions.PADDING_SIZE_DEFAULT,
                                          ),
                                          Container(
                                            width: 230,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color: ColorResources.visitShop(
                                                  context),
                                              borderRadius: BorderRadius
                                                  .circular(Dimensions
                                                      .PADDING_SIZE_EXTRA_LARGE),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                RatingBar(
                                                  rating: double.parse(ratting),
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                    width: Dimensions
                                                        .PADDING_SIZE_DEFAULT),
                                                Text('${double.parse(ratting).toStringAsFixed(1)}' +
                                                    ' ' +
                                                    '${getTranslated('out_of_5', context)}'),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_DEFAULT),
                                          Text('${getTranslated('total', context)}' +
                                              ' ' +
                                              '${details.reviewList != null ? details.reviewList.length : 0}' +
                                              ' ' +
                                              '${getTranslated('reviews', context)}'),
                                          details.reviewList != null
                                              ? details.reviewList.length != 0
                                                  ? ReviewWidget(
                                                      reviewModel:
                                                          details.reviewList[0])
                                                  : SizedBox()
                                              : ReviewShimmer(),
                                          details.reviewList != null
                                              ? details.reviewList.length > 1
                                                  ? ReviewWidget(
                                                      reviewModel:
                                                          details.reviewList[1])
                                                  : SizedBox()
                                              : ReviewShimmer(),
                                          details.reviewList != null
                                              ? details.reviewList.length > 2
                                                  ? ReviewWidget(
                                                      reviewModel:
                                                          details.reviewList[2])
                                                  : SizedBox()
                                              : ReviewShimmer(),
                                          InkWell(
                                            onTap: () {
                                              if (details.reviewList != null) {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ReviewScreen(
                                                      reviewList:
                                                          details.reviewList,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                            child: details.reviewList != null &&
                                                    details.reviewList.length >
                                                        3
                                                ? Text(
                                                    getTranslated(
                                                        'view_more', context),
                                                    style: titilliumRegular
                                                        .copyWith(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                  )
                                                : SizedBox(),
                                          )
                                        ]),
                                  ),
                                  widget.product.addedBy == 'seller'
                                      ? Padding(
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_DEFAULT),
                                          child: TitleRow(
                                              title: getTranslated(
                                                  'more_from_the_shop',
                                                  context),
                                              isDetailsPage: true),
                                        )
                                      : SizedBox(),
                                  widget.product.addedBy == 'seller'
                                      ? Padding(
                                          padding: EdgeInsets.all(Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                          child: ProductView(
                                              isHomePage: true,
                                              productType:
                                                  ProductType.SELLER_PRODUCT,
                                              scrollController:
                                                  _scrollController,
                                              sellerId: widget.product.userId
                                                  .toString()),
                                        )
                                      : SizedBox(),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: Dimensions.PADDING_SIZE_SMALL),
                                    padding: EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_DEFAULT),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL,
                                              vertical: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          child: TitleRow(
                                              title: getTranslated(
                                                  'related_products', context),
                                              isDetailsPage: true),
                                        ),
                                        SizedBox(height: 5),
                                        RelatedProductView(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Scaffold(
                      body: NoInternetOrDataScreen(
                          isNoInternet: true,
                          child: ProductDetails(product: widget.product)));
            },
          )
        : SizedBox();
  }

// https://shoptriangle.in/update.php
  File filee;
  final pickerr = ImagePicker();

  void _choosee() async {
    final pickedFile = await pickerr.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        filee = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> uploadImage(
    String sendimage,
    String userId,
    String orderId,
    // String date,
  ) async {
    // final prefs = await SharedPreferences.getInstance();
    // final vals = prefs.getString('id') ?? "0";
    // print(vals);

    print("vvvvvvvvv");
    var stream = http.ByteStream(filee.openRead());
    stream.cast();
    var length = await filee.length();
    var uri = Uri.parse("https://shoptriangle.in/update.php");
    var request = http.MultipartRequest('POST', uri);
    // request.fields['mobile'] = "123456789";
    request.fields['user_id'] = 19.toString();
    request.fields['order_id'] = widget.product.id.toString();
    // request.fields['subject'] = subject;
    // request.fields['date'] = date;
    // request.fields["s_id"] = vals;
    var multiport =
        http.MultipartFile('sendimage', stream, length, filename: (filee.path));
    print("bye" + widget.product.id.toString());
    request.files.add(multiport);
    var response = await request.send();
    print(response);
    if (response.statusCode == 200) {
      print("aaaaaaaaaa");
    } else {
      print("bbbb");
    }
  }

  // https://shoptriangle.in/update.php
}
