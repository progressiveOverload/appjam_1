import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlaceDetailsScreen extends StatelessWidget {
  final String placeName;
  final String placeRating;
  final String placePhoto;
  // ignore: non_constant_identifier_names
  final String API;
  final String defaultPhotoURL; // Varsayılan fotoğraf URL'si

  const PlaceDetailsScreen({
    Key? key,
    required this.placeName,
    required this.placePhoto,
    required this.placeRating,
    // ignore: non_constant_identifier_names
    required this.API,
    required this.defaultPhotoURL,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0), // Body'nin üstüne 20 birim padding ekleyelim
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 300, // Fotoğrafın yüksekliği
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(defaultPhotoURL), // Varsayılan fotoğrafı göster
                    fit: BoxFit.cover,
                  ),
                ),
                child: FutureBuilder<http.Response>(
                  future: http.get(Uri.parse(
                      'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$placePhoto&key=$API')),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Container(); // Hata durumunda boş container döndür
                      }
                      if (snapshot.data!.statusCode == 200) {
                        // Fotoğraf başarıyla alındıysa
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(snapshot.data!.bodyBytes), // Fotoğrafı göster
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      } else {
                        // Fotoğraf alınamadı
                        return Container(); // Hata durumunda boş container döndür
                      }
                    } else {
                      // İstek tamamlanmadıysa veya bekleniyorsa
                      return const Center(
                        child: CircularProgressIndicator(), // İlerleme çemberi göster
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  '$placeName\nRating: $placeRating',
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
