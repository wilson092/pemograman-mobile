import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:pemob/project/app/core/constants/app_dimensions.dart';
import 'package:pemob/project/app/data/models/weather_data.dart';
import 'package:pemob/project/app/data/providers.dart';
import 'package:pemob/project/app/data/repositories/mock_weather_repository.dart';
import 'package:pemob/project/app/data/risk_rules.dart';
import 'package:pemob/project/app/features/map/widgets/map_controls.dart';
import 'package:pemob/project/app/features/map/widgets/map_marker_widget.dart';
import 'package:pemob/project/app/features/map/widgets/map_search_bar.dart';
import 'package:pemob/project/app/features/map/widgets/map_weather_card.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late final MapController _mapController;
  final TextEditingController _searchController = TextEditingController();
  WeatherData? _selectedCity;

  static const LatLng _initialCenter = LatLng(-6.2088, 106.8456);
  static const double _initialZoom = 7.5;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _selectedCity = MockWeatherRepository.seedCities.firstWhere(
      (c) => c.city == 'Jakarta',
      orElse: () => MockWeatherRepository.seedCities.first,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onCityTap(WeatherData city) {
    setState(() => _selectedCity = city);
    _mapController.move(LatLng(city.latitude, city.longitude), 9.0);
  }

  void _searchLocation(String query) {
    if (query.trim().isEmpty) return;
    const cities = MockWeatherRepository.seedCities;
    final found = cities.where(
      (c) => c.city.toLowerCase() == query.trim().toLowerCase(),
    );

    if (found.isNotEmpty) {
      _onCityTap(found.first);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lokasi tidak ditemukan di peta')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final rules = ref.watch(weatherRulesProvider);
    const cities = MockWeatherRepository.seedCities;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: _initialZoom,
              onTap: (_, __) {
                if (_selectedCity != null) {
                  setState(() => _selectedCity = null);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.pemob',
              ),
              MarkerLayer(
                markers: cities.map((city) {
                  final risk = RiskRuleHelper.calculateRisk(
                    city.temperature,
                    rules,
                    override: city.riskOverride,
                  );
                  return Marker(
                    point: LatLng(city.latitude, city.longitude),
                    width: 100,
                    height: 54,
                    child: MapMarkerWidget(
                      cityName: city.city,
                      temperature: city.temperature,
                      riskLevel: risk,
                      isSelected: _selectedCity?.city == city.city,
                      onTap: () => _onCityTap(city),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Floating Search Bar
          Positioned(
            top: AppDimensions.space16,
            left: AppDimensions.screenPaddingH,
            right: AppDimensions.screenPaddingH,
            child: MapSearchBar(
              controller: _searchController,
              onSubmitted: _searchLocation,
              onClear: () {
                _searchController.clear();
                setState(() {});
              },
            ),
          ),

          // Floating Controls
          Positioned(
            right: AppDimensions.screenPaddingH,
            top: 80,
            child: MapControls(
              onZoomIn: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom + 1,
              ),
              onZoomOut: () => _mapController.move(
                _mapController.camera.center,
                _mapController.camera.zoom - 1,
              ),
              onRecenter: () => _mapController.move(_initialCenter, _initialZoom),
            ),
          ),

          // Floating Bottom Weather Card
          if (_selectedCity != null)
            Positioned(
              left: AppDimensions.screenPaddingH,
              right: AppDimensions.screenPaddingH,
              bottom: AppDimensions.space16,
              child: MapWeatherCard(
                weather: _selectedCity!,
                riskLevel: RiskRuleHelper.calculateRisk(
                  _selectedCity!.temperature,
                  rules,
                  override: _selectedCity!.riskOverride,
                ),
                onClose: () => setState(() => _selectedCity = null),
              ),
            ),
        ],
      ),
    );
  }
}

