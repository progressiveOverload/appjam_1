  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;

  class PlaceDetailsScreen extends StatelessWidget {
    final String placeName;
    final String placeRating;
    final String placePhoto;
    final String API;
    final String defaultPhotoURL; // Varsayılan fotoğraf URL'si

    const PlaceDetailsScreen({Key? key, required this.placeName, required this.placePhoto, required this.placeRating, required this.API, required this.defaultPhotoURL}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(

        appBar: AppBar(
          title: Text('Place Details'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Fotoğrafı göstermek için Image widget'ı
              FutureBuilder<http.Response>(
                future: http.get(Uri.parse('https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$placePhoto&key=$API')),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Image.network(defaultPhotoURL); // Hata durumunda varsayılan fotoğrafı göster
                    }
                    if (snapshot.data!.statusCode == 200) {
                      // Fotoğraf başarıyla alındıysa
                      return Image.memory(snapshot.data!.bodyBytes); // Fotoğrafı göster
                    } else {
                      // Fotoğraf alınamadı
                      return Image.network(defaultPhotoURL); // Hata durumunda varsayılan fotoğrafı göster
                    }
                  } else {
                    // İstek tamamlanmadıysa veya bekleniyorsa
                    return CircularProgressIndicator(); // İlerleme çemberi göster
                  }
                },
              ),
              SizedBox(height: 20), // Boşluk ekleyelim
              Text(
                'Hello World from $placeName\nrating: $placeRating',
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }
