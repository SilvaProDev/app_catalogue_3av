import 'package:carousel_slider/carousel_slider.dart';
import 'package:catalogue_3av/model/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants/constants.dart';
import '../controllers/finance_controller.dart';

class ArticleDetailPage extends StatefulWidget {
  final CarouselSliderModel article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  final FinanceController _financeController = Get.put(FinanceController());
  int activeIndex = 0;

  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    // Charger les détails de l'actualité une seule fois au démarrage
    _loadFuture = _financeController.getDetailActualite(widget.article.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.2,
        title: const Text("Détails de l'article"),
      ),
      body: FutureBuilder(
        future: _loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // En cours de chargement
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          // Maintenant on observe les données réactives
          return Obx(() {
            final sliders = _financeController.detailActualite;
            if (sliders.isEmpty) {
              return const Center(child: Text("Aucune actualité disponible."));
            }

            return Column(
              children: [
                const SizedBox(height: 20),
                CarouselSlider.builder(
                  itemCount: sliders.length,
                  itemBuilder: (context, index, realIndex) {
                    final item = sliders[index];
                    return buildImage(item.fichier ?? '');
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
                const SizedBox(height: 10),
                buildIndicator(sliders.length),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    widget.article.title ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.article.description ?? '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            );
          });
        },
      ),
    );
  }

  Widget buildImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        '$imageUrl/$image',
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey,
          child: const Icon(Icons.broken_image, color: Colors.white, size: 50),
        ),
      ),
    );
  }

  Widget buildIndicator(int count) {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: count,
      effect: const SlideEffect(
        dotHeight: 10,
        dotWidth: 10,
        activeDotColor: Colors.blue,
      ),
    );
  }
}
