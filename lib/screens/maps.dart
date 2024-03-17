import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  LocationData currentLocation =
      LocationData.fromMap({"latitude": 0.0, "longitude": 0.0});
  final Set<Circle> _circles = <Circle>{};

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  Future<void> retrieveLocation() async {
    var locationService = Location();
    currentLocation = await locationService.getLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(currentLocation.latitude!, currentLocation.longitude!)));

    setState(() {
      _circles.add(
        Circle(
          circleId: const CircleId("0"),
          center: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          radius: 1000,
          fillColor: Colors.blue.withOpacity(0.5),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          zoom: 14.4746,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          retrieveLocation();
        },
        circles: _circles,
      ),
    );
  }
}
