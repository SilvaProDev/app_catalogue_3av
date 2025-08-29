import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/constants.dart';
import '../controllers/finance_controller.dart';
import '../model/carousel_slider.dart';
import '../pages/article_detail_page.dart';

class NewsScreem extends StatefulWidget {
  const NewsScreem({super.key});

  @override
  State<NewsScreem> createState() => _NewsScreemState();
}

class _NewsScreemState extends State<NewsScreem> {
  final FinanceController _financeController = Get.put(FinanceController());
  int activeIndex = 0;
  
  late Future<List<CarouselSliderModel>> _slidersFuture;

  @override
  void initState() {
    super.initState();
    _slidersFuture = _loadSliders();
  }

  Future<List<CarouselSliderModel>> _loadSliders() async {
    await _financeController.getListeActualite();
    return _financeController.actualites;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.2,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Actualités des "),
            Text(
              "3AV",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<CarouselSliderModel>>(
        future: _slidersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("Aucune actualité disponible."));
          }

          final sliders = snapshot.data!;

          return Column(
            children: [
              // Partie carrousel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Images d'actualités",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              CarouselSlider.builder(
                itemCount: sliders.length,
                itemBuilder: (context, index, realIndex) {
                  final item = sliders[index];
                  return buildImage(item.fichier ?? '', item.title ?? '', () {
                    print('Image tapée: ${item.id}');
                    // par exemple : Navigator.push(...) ou autre action
                  });
                },
                options: CarouselOptions(
                  height: 240,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  enlargeStrategy: CenterPageEnlargeStrategy.height,
                  onPageChanged: (index, reason) {
                    setState(() => activeIndex = index);
                  },
                ),
              ),
              SizedBox(height: 10),
              buildIndicator(sliders.length),
              SizedBox(height: 15),

              // Partie liste des actualités
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Liste d'actualités !",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: sliders.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = sliders[index];
                    return _buildNewsItem(item);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget buildImage(String image, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              '$imageUrl/$image',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade200,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder:
                  (context, error, stackTrace) => Container(
                    color: Colors.grey,
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                color: Colors.black45,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem(CarouselSliderModel item) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ArticleDetailPage(article: item)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  '$imageUrl/${item.fichier}',
                  height: 120,
                  width: 120,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey.shade200,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey,
                        child: Icon(Icons.broken_image, color: Colors.white),
                      ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      item.description ?? '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator(int count) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: count,
      effect: SlideEffect(
        dotHeight: 10,
        dotWidth: 10,
        activeDotColor: Colors.blue,
      ),
    );
  }
}
