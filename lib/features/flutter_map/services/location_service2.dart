// import 'package:geolocator/geolocator.dart';

// /// LocationService handles permission requests and provides the current
// /// position. It encapsulates Geolocator logic so the UI code stays clean.
// class LocationService {
//   /// Request permission if needed and return current position.
//   /// Throws a [PermissionDeniedException] or [PermissionDeniedForeverException]
//   /// (from Geolocator) if permission is not granted.
//   Future<Position> getCurrentPosition() async {
//     LocationPermission permission = await Geolocator.checkPermission();

//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     if (permission == LocationPermission.denied) {
//       throw PermissionDeniedException('Location permission denied');
//     }

//     if (permission == LocationPermission.deniedForever) {
//       throw PermissionDeniedException(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//     return await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.best,
//     );
//   }

//   /// A convenience method to listen to position updates.
//   Stream<Position> getPositionStream({
//     LocationAccuracy accuracy = LocationAccuracy.best,
//     int distanceFilterMeters = 10,
//   }) {
//     return Geolocator.getPositionStream(
//       locationSettings: LocationSettings(
//         accuracy: accuracy,
//         distanceFilter: distanceFilterMeters,
//       ),
//     );
//   }
// }

// class PermissionDeniedException implements Exception {
//   final String message;
//   PermissionDeniedException(this.message);

//   @override
//   String toString() => 'PermissionDeniedException: $message';
// }
