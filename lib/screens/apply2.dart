import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:cool_alert/cool_alert.dart';

import '../ad_helper.dart';
//import 'dart:js' as js;

class ImageView extends StatefulWidget {
  ImageView({this.imgPath});
  final String imgPath;
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  var filePath;
  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  // TODO: Add _interstitialAd
  InterstitialAd _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isInterstitialAdReady = false;
  @override
  void initState() {
    super.initState();
    // TODO: Initialize _interstitialAd
    _interstitialAd = InterstitialAd(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
          ad.dispose();
        },
        onAdClosed: (_) {},
      ),
    );
    _interstitialAd.load();
    // status();
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    // TODO: Dispose an InterstitialAd object
    _interstitialAd.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgPath,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: kIsWeb
                  ? Image.network(widget.imgPath, fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: widget.imgPath,
                      placeholder: (context, url) => Container(
                        color: Color(0xfff5f8fd),
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InkWell(
                    onTap: () {
                      if (kIsWeb) {
                        _launchURL(widget.imgPath);
                        //js.context.callMethod('downloadUrl',[widget.imgPath]);
                        //response = await dio.download(widget.imgPath, "./xx.html");
                      } else {
                        _save();
                      }
                      //Navigator.pop(context);
                    },
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Color(0xff1C1B1B).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(40),
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white24, width: 1),
                                borderRadius: BorderRadius.circular(40),
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0x36FFFFFF),
                                      Color(0x0FFFFFFF)
                                    ],
                                    begin: FractionalOffset.topLeft,
                                    end: FractionalOffset.bottomRight)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Set Wallpaper",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  kIsWeb
                                      ? "Image will open in new tab to download"
                                      : "",
                                  style: TextStyle(
                                      fontSize: 8, color: Colors.white70),
                                ),
                              ],
                            )),
                      ],
                    )),
                SizedBox(
                  height: 16,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _save() async {
    // await _askPermission();
    // var response = await Dio().get(widget.imgPath,
    //     options: Options(responseType: ResponseType.bytes));
    // final result =
    //     await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    // print(Uint8List.fromList(response.data));

    int location = WallpaperManager.BOTH_SCREENS;
    var file = await DefaultCacheManager().getSingleFile(widget.imgPath);
    String result2;
    try {
      result2 =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      print('applied');
      CoolAlert.show(
        context: context,
        type: CoolAlertType.success,
        text: "Wallpaper applied successfully!",
      );
      if (_isInterstitialAdReady) {
        _interstitialAd.show();
      }
    } on PlatformException {
      result2 = 'Failed to get wallpaper.';
    }
    // final String result =
  }

  void _getPermission() async {
    // final PermissionHandler _permissionHandler = PermissionHandler();
    // var result =
    //     await _permissionHandler.requestPermissions([PermissionGroup.storage]);
    // if (result[PermissionGroup.storage] == PermissionStatus.denied) {
    //   CoolAlert.show(
    //     context: context,
    //     type: CoolAlertType.error,
    //     text:
    //         "You Cannot Save The Wallpapers plz enable storage permision first",
    //   );

    //   // permission was granted
    // }
  }

  _askPermission() async {
    if (Platform.isIOS) {
      /*Map<PermissionGroup, PermissionStatus> permissions =
          */
      //await PermissionHandler().requestPermissions([PermissionGroup.photos]);
    } else {
      _getPermission();
    }
  }
}
