import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'services/location_service2.dart';
import 'services/routing_service.dart';
import 'widgets/user_location_marker.dart';
import 'widgets/destination_marker.dart';

/// MapPage demonstrates a clean separation between UI and services.
///
/// Usage: Provide a [destination] LatLng and the page will attempt to fetch
/// the user's location, center the map, show a user marker, and draw a route
/// from the user to the destination using OSRM.
class MapPage extends StatefulWidget {
  final LatLng destination;
  final double initialZoom;
  const MapPage({required this.destination, this.initialZoom = 14, super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  // final LocationService _locationService = LocationService();
  final RoutingService _routingService = RoutingService();

  LatLng? _userLocation;
  List<LatLng> _routePoints = [];
  StreamSubscription? _positionSub;

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // _initLocationAndRoute();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    super.dispose();
  }

  // Future<void> _initLocationAndRoute() async {
  //   setState(() {
  //     _loading = true;
  //     _error = null;
  //   });

  //   try {
  //     // final pos = await _locationService.getCurrentPosition();
  //     _userLocation = LatLng(pos.latitude, pos.longitude);

  //     // center map to user location
  //     _moveTo(_userLocation!, zoom: widget.initialZoom);

  //     // subscribe to updates (optional)
  //     // _positionSub = _locationService
  //         .getPositionStream(distanceFilterMeters: 15)
  //         .listen((p) {
  //           setState(() {
  //             _userLocation = LatLng(p.latitude, p.longitude);
  //           });
  //         });

  //     // fetch route
  //     _routePoints = await _routingService.getRoute(
  //       start: _userLocation!,
  //       end: widget.destination,
  //     );
  //   } catch (e) {
  //     _error = e.toString();
  //   }

  //   setState(() {
  //     _loading = false;
  //   });
  // }
  //
  void _moveTo(LatLng target, {double? zoom}) {
    // A small helper that moves the map smoothly.
    // Move the map to target (non-animated in this version of flutter_map).
    _mapController.move(target, zoom ?? widget.initialZoom);
  }

  Future<void> _onMyLocationPressed() async {
    if (_userLocation == null) {
      setState(() => _error = 'User location unknown');
      return;
    }
    _moveTo(_userLocation!, zoom: 16);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tileUrl = isDark
        ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
        : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _userLocation ?? widget.destination,
              initialZoom: widget.initialZoom,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.road_sense_app',
                // Attribution is handled by the app's legal footer or a custom widget.
              ),

              // route polyline layer
              if (_routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: Theme.of(context).colorScheme.primary,
                      strokeWidth: 5.0,
                    ),
                  ],
                ),

              // markers
              MarkerLayer(
                markers: [
                  if (_userLocation != null)
                    Marker(
                      width: 56,
                      height: 56,
                      point: _userLocation!,
                      child: const UserLocationMarker(),
                    ),

                  Marker(
                    width: 80,
                    height: 80,
                    point: widget.destination,
                    child: const DestinationMarker(label: 'Destination'),
                  ),
                ],
              ),
            ],
          ),

          // Loading / error overlays
          if (_loading)
            const Positioned(
              top: 24,
              left: 24,
              right: 24,
              child: Card(
                color: Colors.black54,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Loading location...',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),

          if (_error != null)
            Positioned(
              top: 24,
              left: 24,
              right: 24,
              child: Card(
                color: Colors.redAccent,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onMyLocationPressed,
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
