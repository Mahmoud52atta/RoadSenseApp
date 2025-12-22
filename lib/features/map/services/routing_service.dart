import 'dart:convert';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

/// RoutingService is responsible for calling OSRM and decoding the polyline
/// into a list of [LatLng]. It is pure network + decode logic so it can be
/// unit-tested separately.
class RoutingService {
  final String _baseUrl = 'https://router.project-osrm.org';

  /// Get a driving route between [start] and [end]. Returns a list of LatLng
  /// that represent the route polyline. Throws an exception on network or
  /// parsing errors.
  Future<List<LatLng>> getRoute({
    required LatLng start,
    required LatLng end,
  }) async {
    final coords = '${start.longitude},${start.latitude};${end.longitude},${end.latitude}';
    final url = '$_baseUrl/route/v1/driving/$coords?overview=full&geometries=polyline';

    final resp = await http.get(Uri.parse(url));
    if (resp.statusCode != 200) {
      throw Exception('Routing request failed: ${resp.statusCode}');
    }

    final body = json.decode(resp.body) as Map<String, dynamic>;
    if (body['routes'] == null || (body['routes'] as List).isEmpty) {
      throw Exception('No route found');
    }

    final route = body['routes'][0] as Map<String, dynamic>;
    final polyline = route['geometry'] as String;

    return _decodePolyline(polyline);
  }

  /// Decodes an encoded polyline string (Google / OSRM polyline encoding)
  /// into a list of [LatLng].
  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> coordinates = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      final point = LatLng(lat / 1e5, lng / 1e5);
      coordinates.add(point);
    }

    return coordinates;
  }
}
