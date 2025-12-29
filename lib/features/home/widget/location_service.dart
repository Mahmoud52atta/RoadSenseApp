import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationService {
  Location location = Location();

  Future<bool> checkLocationService() async {
    debugPrint('[Location] Checking location service status');
    try {
      var isServiceEnabled = await location.serviceEnabled();

      if (!isServiceEnabled) {
        debugPrint('[Location] Location service disabled, requesting...');
        isServiceEnabled = await location.requestService();

        if (!isServiceEnabled) {
          debugPrint('[Location] User declined to enable location service');
          return false;
        }
      }

      debugPrint('[Location] Location service is enabled');
    } catch (e) {
      debugPrint('[Location] Error checking location service: $e');
    }
    return true;
  }

  Future<bool> checkLocationPermission() async {
    debugPrint('[Location] Checking location permission');
    try {
      var permissionStatus = await location.hasPermission();
      debugPrint('[Location] Current permission status: $permissionStatus');

      if (permissionStatus == PermissionStatus.denied) {
        debugPrint('[Location] Permission denied, requesting...');
        permissionStatus = await location.requestPermission();

        if (permissionStatus != PermissionStatus.granted) {
          debugPrint('[Location] User denied location permission');
          return false;
        }
      }

      if (permissionStatus == PermissionStatus.deniedForever) {
        debugPrint('[Location] Location permission denied forever');
        return false;
      }

      debugPrint('[Location] Location permission granted');
      return permissionStatus == PermissionStatus.granted;
    } catch (e) {
      debugPrint('[Location] Error checking location permission: $e');
      return false;
    }
  }

 

  void getRealTimeLocationUpdates(Function(LocationData) onData) {
    location.onLocationChanged.listen((LocationData currentLocation) {
      debugPrint(
        '[Location] New location: Lat ${currentLocation.latitude}, Lon ${currentLocation.longitude}',
      );
      onData(currentLocation);
    });
  }

  Future<void> getCurrentLocation(void Function(LocationData) onData) async {
    try {
      final currentLocation = await location.getLocation();
      debugPrint(
        '[Location] Current location: Lat ${currentLocation.latitude}, Lon ${currentLocation.longitude}',
      );
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        await _updateMapLocation(
          currentLocation.latitude!,
          currentLocation.longitude!,
          isInitial: true,
          onData: onData,
        );
      }
    } catch (e) {
      debugPrint('[Location] Error getting current location: $e');
    }
  }


   Future<bool> initializeLocation() async {
    final isServiceEnabled = await checkLocationService();
    if (!isServiceEnabled) return false;

    final isPermissionGranted = await checkLocationPermission();
    if (!isPermissionGranted) return false;

    return true;
  }
}

Future<void> _updateMapLocation(
  double latitude,
  double longitude, {
  bool isInitial = false,
  void Function(LocationData)? onData,
}) async {
  final logType = isInitial ? 'initial' : 'updated';
  debugPrint('[Map] Location $logType on map: ($latitude, $longitude)');
}
