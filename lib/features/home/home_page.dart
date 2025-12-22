import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:road_sense_app/core/extensions/context_extension.dart';
import 'package:road_sense_app/features/map/map_page.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.loc.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              if (getIt.get<AppStorage>().getLocale() == 'ar') {
                getIt.get<AppStorage>().setLocale('en');
              } else {
                getIt.get<AppStorage>().setLocale('ar');
              }
            },
          ),
          IconButton(
            icon: Icon(
              getIt.get<AppStorage>().getThemeMode() == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              if (getIt.get<AppStorage>().getThemeMode() == ThemeMode.light) {
                getIt.get<AppStorage>().setThemeMode(ThemeMode.dark);
              } else {
                getIt.get<AppStorage>().setThemeMode(ThemeMode.light);
              }
              setState(() {});
            },
          ),
        ],
      ),
      body: MapPage(destination: LatLng(29.31, 30.84), initialZoom: 11),
    );
  }
}
