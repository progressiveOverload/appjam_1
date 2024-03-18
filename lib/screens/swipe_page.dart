// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({
    super.key,
  });

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  final CardSwiperController controller = CardSwiperController();
  List<ExampleCandidateModel> candidates = [];

  bool _isLoading = false; // Yüklenme durumunu izlemek için bir değişken eklendi

  @override
  void initState() {
    super.initState();
    _fetchCandidates();
  }

  Future<void> _fetchCandidates() async {
    setState(() {
      _isLoading = true; // Verilerin yüklenme durumunu başlat
    });

    candidates.clear(); // Liste temizle
    // Kullanıcının konumunu al
    Position position = await _determinePosition();

    // Konum bilgisine göre yerleri çek
    if (position != null) {
      final apiKey = 'AIzaSyC6-1byZsRdCHVXnTDP9pjvmFRuV_kuZAk'; // API anahtarınızı buraya ekleyin
      final radius = 3000; // Mesafeyi metrik sistemde metre cinsinden belirtin
      List<ExampleCandidateModel> allCandidates = []; // Tüm adayları depolamak için bir liste oluşturun

      for (var placeX in ["museum","point_of_interest",  "historical_site"]) {
        final url =
            'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=$radius&type=$placeX&key=$apiKey';

        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> places = data['results'];

          // Rating'e göre sırala ve en yüksek ratinge sahip ilk 1000 yeri al
          List<ExampleCandidateModel> candidatesForPlaceX = places.map((place) {
            return ExampleCandidateModel(
              placeName: place['name'],
              placePhoto: place['photos'] != null && place['photos'].isNotEmpty ? place['photos'][0]['photo_reference'] : '',
              placeRating: place['rating'] != null ? place['rating'].toDouble() : 0.0,
              placeId: place['place_id'],
              API: apiKey,
            );
          }).toList();

          allCandidates.addAll(candidatesForPlaceX); // Her bir döngü işlemi sonucunu tüm adaylar listesine ekleyin
        } else {
          throw Exception('Failed to load nearby places');
        }
      }

      setState(() {
        candidates = allCandidates; // Tüm adayları setState ile güncelleyin
        _isLoading = false; // Verilerin yüklenme durumunu sonlandır
      });
    }
  }

  // Kullanıcının konumunu belirleme fonksiyonu
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Konum servislerinin etkin olup olmadığını kontrol et
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Konum servisleri etkin değilse kullanıcıyı uyar
      throw Exception('Konum servisleri etkin değil.');
    }

    // Konum izni al
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Konum izni verilmediyse kullanıcıyı uyar
        throw Exception('Konum izni verilmedi.');
      }
    }

    // Konum bilgisini al
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Swipe!'),
      ),
      body: SafeArea(
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(), // Yüklenirken dairesel ilerleme göstergesi
        )
            : Column(
          children: [
            Flexible(
              child: candidates.isNotEmpty
                  ? CardSwiper(
                controller: controller,
                cardsCount: candidates.length,
                cardBuilder: (
                    context,
                    index,
                    horizontalThresholdPercentage,
                    verticalThresholdPercentage,
                    ) {
                  return ExampleCard(candidates[index]);
                },
              )
                  : Center(
                child: Text("No place found near you."),
              ), // Eğer adaylar listesi boşsa, kartları gösterme
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: controller.undo,
                    child: const Icon(Icons.rotate_left),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.left),
                    child: const Icon(Icons.keyboard_arrow_left),
                  ),
                  FloatingActionButton(
                    onPressed: () => controller.swipe(CardSwiperDirection.right),
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ExampleCandidateModel {
  final String placeName;
  final double placeRating;
  final String placePhoto;
  final String placeId;
  final String API;


  ExampleCandidateModel({
    required this.placeName,
    required this.placePhoto,
    required this.placeRating,
    required this.placeId,
    required this.API,

  });
}

class ExampleCard extends StatelessWidget {
  final ExampleCandidateModel candidate;

  const ExampleCard(this.candidate, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded( // Değişiklik burada
            child: candidate.placePhoto.isNotEmpty
                ? Image.network(
              'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${candidate.placePhoto}&key=${candidate.API}',
              fit: BoxFit.cover,
            )
                : Image.asset(
                'assets/icon-image-not-found-free-vector.jpg',
                fit: BoxFit.cover,

            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  candidate.placeName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Rating: ${candidate.placeRating}',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

