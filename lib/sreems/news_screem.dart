import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../model/carousel_slider.dart';
import '../pages/article_detail_page.dart';
import '../services/slider_data.dart';
// ... autres imports

class NewsScreem extends StatefulWidget {
  const NewsScreem({super.key});

  @override
  State<NewsScreem> createState() => _NewsScreemState();
}

class _NewsScreemState extends State<NewsScreem> {
  List<CarouselSilderModel> sliders = [];
  int activeIndex = 0;
  
  @override
  void initState() {
    sliders = getCarouselSlider();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 5.2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Actualités des "),
            Text(
              "3AV",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Partie supérieure fixe (carrousel et indicateur)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Images d'actualités",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              CarouselSlider.builder(
                itemCount: sliders.length,
                itemBuilder: (context, index, realIndex) {
                  return buildImage(sliders[index].image!, index, sliders[index].name!);
                },
                options: CarouselOptions(
                  height: 240,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              Center(child: buildIndicator()),
              SizedBox(height: 15),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Liste d'actualités !",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          // Partie défilante (liste d'actualités)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < sliders.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == sliders.length - 1 ? 0 : 10),
              child: _buildNewsItem(
                context,
                sliders[i].image!,
                sliders[i].name!,
                sliders[i].description!,
                sliders[i],
              ),
            ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(BuildContext context, String image, String title, String description, CarouselSilderModel article) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Material(
        elevation: 3.0,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArticleDetailPage(article: article),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    image,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        description,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildImage(String image, int index, String name) => Container(
    margin: EdgeInsets.symmetric(horizontal: 5.0),
    child: Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            image,
            height: 250,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Container(
          height: 250,
          padding: EdgeInsets.only(left: 10),
          margin: EdgeInsets.only(top: 170),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Text(
            name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );

  Widget buildIndicator() => AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: sliders.length,
    effect: SlideEffect(
      dotHeight: 15,
      dotWidth: 15,
      activeDotColor: Colors.blue,
    ),
  );
}