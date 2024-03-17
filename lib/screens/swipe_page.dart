// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// class SwipePage extends StatefulWidget {
//   const SwipePage({Key? key}) : super(key: key);

//   @override
//   State<SwipePage> createState() => _SwipePageState();
// }

// class _SwipePageState extends State<SwipePage> {
//   List<dynamic> places = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchPlaces();
//   }

//   Future<void> fetchPlaces() async {
//     // Replace with your actual location and API key
//     String url =
//         'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=37.7749,-122.4194&radius=1000&type=restaurant&key=YOUR_API_KEY';
//     final response = await http.get(Uri.parse(url));
//     final Map<String, dynamic> responseData = json.decode(response.body);

//     if (responseData['results'] != null) {
//       setState(() {
//         places = responseData['results'];
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: places.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : Swiper(
//               itemCount: places.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return Card(
//                   child: Column(
//                     children: <Widget>[
//                       Image.network(
//                         'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=${places[index]['photos'][0]['photo_reference']}&key=YOUR_API_KEY',
//                         fit: BoxFit.cover,
//                       ),
//                       Text(places[index]['name']),
//                       Text('Rating: ${places[index]['rating']}'),
//                     ],
//                   ),
//                 );
//               },
//               pagination: SwiperPagination(),
//               control: SwiperControl(),
//             ),
//     );
//   }
// }