import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'quotes.dart';
import 'constants.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List? imageList;
  int imgnumber = 0;
  List<bool> likedQuotes = List.filled(quotesList.length, false);

  @override
  void initState() {
    super.initState();
    getImagesFromUnsplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: imageList != null
          ? Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: BlurHash(
              key: ValueKey(
                imageList?[imgnumber!]['blur_hash'],
              ),
              hash: imageList![imgnumber!]['blur_hash'],
              duration: const Duration(microseconds: 500),
              image: imageList![imgnumber!]['urls']['regular'],
              curve: Curves.easeInOut,
              imageFit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black54.withOpacity(0.6),
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SafeArea(
              child: CarouselSlider.builder(
                itemCount: quotesList.length,
                itemBuilder: (context, index1, index2) {
                  return Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              quotesList[index1][kQuote],
                              style: kQuoteTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "-${quotesList[index1][kAuthor]}-",
                            style: kAuthorTextStyle,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 70,
                            width: 70,
                            child: IconButton(
                              icon: Icon(
                                likedQuotes[index1]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: likedQuotes[index1]
                                    ? Colors.red
                                    : Colors.white,
                                size: 50,
                              ),
                              onPressed: () {
                                setState(() {
                                  likedQuotes[index1] =
                                  !likedQuotes[index1];
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
                options: CarouselOptions(
                    scrollDirection: Axis.vertical,
                    pageSnapping: true,
                    initialPage: 1,
                    enlargeCenterPage: true,
                    onPageChanged: (index, value) {
                      HapticFeedback.lightImpact();
                      imgnumber = index;
                      if (imgnumber >= 42) {
                        imgnumber = 15;
                      }
                      print(imgnumber);
                      setState(() {});
                    }),
              ),
            ),
          ),
          Positioned(
            top: 50,
            right: 30,
            child: Row(
              children: [
                Text(
                  '${imageList![imgnumber!]['user']['username']}',
                  style: kAuthorTextStyle,
                ),
                Text(' On ', style: kAuthorTextStyle),
                Text('Unsplash', style: kAuthorTextStyle)
              ],
            ),
          ),
        ],
      )
          : Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.6),
        child: const SizedBox(
            width: 100,
            height: 100,
            child: SpinKitFadingCircle(color: Colors.white)),
      ),
    );
  }

  void getImagesFromUnsplash() async {
    var url =
        'https://api.unsplash.com/search/photos?per_page=30&query=nature&order_by=relevant&client_id=$accesskey';
    var uri = Uri.parse(url);
    var response = await http.get(uri);
    print(response.statusCode);
    var unsplashData = json.decode(response.body);
    imageList = unsplashData['results'];
    setState(() {});
  }
}
