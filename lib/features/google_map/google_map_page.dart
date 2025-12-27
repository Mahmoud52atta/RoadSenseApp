import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapPage extends StatefulWidget {
  const GoogleMapPage({super.key});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  late CameraPosition initialCameraPosition;
  late GoogleMapController _mapController;

  @override
  void initState() {
    initialCameraPosition = const CameraPosition(
      target: LatLng(30.044177731378973, 31.239582562114464),
      zoom: 3,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      onMapCreated: (controller) {
        _mapController = controller;
      },
    );
  }
}
