import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'dart:async';
import 'package:road_sense_app/core/extensions/context_extension.dart';
import 'package:road_sense_app/features/home/widget/location_service.dart';

import '../../config/app_config.dart';
import '../../core/app_storage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late MapController _mapController;
  late Location location;
  List<Marker> myMarkers = [];
  StreamSubscription<LocationData>? _locationSubscription;

  late LocationService _locationService;

  @override
  void initState() {
    super.initState();
    debugPrint('[HomePage] initState - Initializing map and location');
    _mapController = MapController();
    location = Location();
    _locationService = LocationService();
    // _initializeLocation();
    _updateLocation();
  }

  @override
  void dispose() {
    debugPrint('[HomePage] dispose - Cleaning up resources');

    // Cancel location subscription immediately to prevent memory leaks
    _locationSubscription?.cancel();
    _locationSubscription = null;

    // Dispose map controller with safety
    try {
      _mapController.dispose();
      debugPrint('[HomePage] dispose - Map controller disposed successfully');
    } catch (e) {
      debugPrint('[HomePage] dispose - Error disposing map controller: $e');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _handleLocaleToggle,
          ),
          IconButton(icon: _buildThemeIcon(), onPressed: _handleThemeToggle),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moveCameraToEgypt,
        tooltip: 'Move to Egypt',
        child: const Icon(Icons.map),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: LatLng(30.0444, 31.2357),
          initialZoom: 5,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
        ),
        children: [
          // Network-only tile layer with robust error handling
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.road_sense_app',
            tileProvider: _NetworkOnlyTileProvider(),
            evictErrorTileStrategy: EvictErrorTileStrategy.none,
            maxNativeZoom: 19,
            errorTileCallback: (tile, error, stackTrace) {
              debugPrint(
                '[TileLayer] Tile error for ${tile.coordinates}: $error',
              );
            },
          ),
          // Marker layer for user location
          MarkerLayer(markers: myMarkers),
        ],
      ),
    );
  }

  Icon _buildThemeIcon() {
    final isDarkMode = getIt.get<AppStorage>().getThemeMode() == ThemeMode.dark;
    return Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode);
  }

  void _handleLocaleToggle() {
    try {
      final storage = getIt.get<AppStorage>();
      final currentLocale = storage.getLocale();
      final newLocale = currentLocale == 'ar' ? 'en' : 'ar';
      storage.setLocale(newLocale);
      debugPrint('[HomePage] Locale changed to: $newLocale');
    } catch (e) {
      debugPrint('[HomePage] Error toggling locale: $e');
    }
  }

  void _handleThemeToggle() {
    try {
      final storage = getIt.get<AppStorage>();
      final isDark = storage.getThemeMode() == ThemeMode.dark;
      final newTheme = isDark ? ThemeMode.light : ThemeMode.dark;
      storage.setThemeMode(newTheme);
      if (mounted) {
        setState(() {});
        debugPrint('[HomePage] Theme changed to: $newTheme');
      }
    } catch (e) {
      debugPrint('[HomePage] Error toggling theme: $e');
    }
  }

  void _moveCameraToEgypt() {
    debugPrint('[HomePage] Moving camera to Egypt');
    try {
      if (mounted) {
        // Coordinates: Cairo, Egypt
        _mapController.move(LatLng(29.30921733330813, 30.846589518024246), 12);
      }
    } catch (e) {
      debugPrint('[HomePage] Error moving map to Egypt: $e');
    }
  }

  Future<void> _startLocationTracking() async {
    debugPrint('[Location] Starting location tracking');

    _locationService.getCurrentLocation((LocationData currentLocation) {
      try {
        if (!mounted) {
          debugPrint('[Map] Widget disposed, skipping location update');
          return;
        }

        _mapController.move(
          LatLng(currentLocation.latitude!, currentLocation.longitude!),
          15,
        );

        if (mounted) {
          setState(() {
            myMarkers = [
              Marker(
                width: 50,
                height: 50,
                point: LatLng(
                  currentLocation.latitude!,
                  currentLocation.longitude!,
                ),
                child: const Icon(
                  Icons.location_on,
                  size: 40,
                  color: Colors.blue,
                ),
              ),
            ];
          });
        }
      } catch (e) {
        debugPrint('[Map] Error updating location on map: $e');
      }
    });

    // Cancel previous subscription
    await _locationSubscription?.cancel();
    location.changeSettings(distanceFilter: 2);

    _locationService.getRealTimeLocationUpdates((LocationData updatedLocation) {
      _onLocationUpdated(updatedLocation);
    });
  }

  void _onLocationUpdated(LocationData loc) {
    // Prevent updates after widget disposal
    if (!mounted) {
      debugPrint('[Location] Ignoring location update after dispose');
      return;
    }

    if (loc.latitude == null || loc.longitude == null) {
      debugPrint('[Location] Received location with null coordinates');
      return;
    }

    debugPrint(
      '[Location] Location updated: (${loc.latitude}, ${loc.longitude})',
    );

    try {
      _mapController.move(LatLng(loc.latitude!, loc.longitude!), 15);

      if (mounted) {
        setState(() {
          myMarkers = [
            Marker(
              width: 50,
              height: 50,
              point: LatLng(loc.latitude!, loc.longitude!),
              child: const Icon(
                Icons.location_on,
                size: 40,
                color: Colors.blue,
              ),
            ),
          ];
        });
      }
    } catch (e) {
      debugPrint('[Location] Error updating map with location: $e');
    }
  }

  Future<void> _updateLocation() async {
    debugPrint('[Location] Starting location update flow');
    try {
      // Check location service
      await _locationService.checkLocationService();

      // Check permissions
      final hasPermission = await _locationService.checkLocationPermission();
      if (!hasPermission) {
        debugPrint('[Location] Cannot proceed - no permission granted');
        return;
      }

      // Start tracking location
      await _startLocationTracking();
    } catch (e) {
      debugPrint('[Location] Error in location update flow: $e');
    }
  }
}

/// Pure network-only tile provider without disk cache dependency
/// Uses NetworkImage which has built-in image caching but no problematic file I/O
/// This prevents PathNotFoundException errors from missing or corrupted cache files
class _NetworkOnlyTileProvider extends TileProvider {
  @override
  ImageProvider<Object> getImage(TileCoordinates coordinates, TileLayer layer) {
    final url = getTileUrl(coordinates, layer);
    debugPrint('[TileProvider] Loading tile from network: $url');

    // NetworkImage handles caching in memory, avoiding file I/O issues
    return NetworkImage(url);
  }

  /// Converts tile coordinates to OSM URL format
  String getTileUrl(TileCoordinates coords, TileLayer layer) {
    final urlTemplate =
        layer.urlTemplate ?? 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
    return urlTemplate
        .replaceAll('{z}', coords.z.toString())
        .replaceAll('{x}', coords.x.toString())
        .replaceAll('{y}', coords.y.toString());
  }
}
