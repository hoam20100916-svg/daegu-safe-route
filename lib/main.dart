import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() => runApp(const DaeguSafeRouteApp());

class DaeguSafeRouteApp extends StatelessWidget {
  const DaeguSafeRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '대구 안심길',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF176B5B)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7F6),
      ),
      home: const RouteHomePage(),
    );
  }
}

enum FacilityType { police, fire, cctv, light }

class DemoFacility {
  final String name;
  final FacilityType type;
  final LatLng point;
  const DemoFacility(this.name, this.type, this.point);
}

class RouteHomePage extends StatefulWidget {
  const RouteHomePage({super.key});

  @override
  State<RouteHomePage> createState() => _RouteHomePageState();
}

class _RouteHomePageState extends State<RouteHomePage> {
  final MapController _mapController = MapController();
  bool _showFacilities = true;
  bool _showFast = true;
  bool _showSafer = true;
  int _selectedRoute = 1;

  // Daegu city-centre demo coordinates. These are illustrative paths, not
  // live pedestrian navigation results.
  static const LatLng _start = LatLng(35.8714, 128.6014);
  static const LatLng _destination = LatLng(35.8580, 128.5900);

  final List<LatLng> _fastRoute = const [
    LatLng(35.8714, 128.6014),
    LatLng(35.8698, 128.5998),
    LatLng(35.8679, 128.5970),
    LatLng(35.8657, 128.5948),
    LatLng(35.8625, 128.5926),
    LatLng(35.8580, 128.5900),
  ];

  final List<LatLng> _saferRoute = const [
    LatLng(35.8714, 128.6014),
    LatLng(35.8720, 128.5975),
    LatLng(35.8700, 128.5940),
    LatLng(35.8668, 128.5915),
    LatLng(35.8630, 128.5890),
    LatLng(35.8600, 128.5885),
    LatLng(35.8580, 128.5900),
  ];

  // Demonstration markers only. Replace with verified public datasets before
  // presenting this as a real safety map.
  final List<DemoFacility> _facilities = const [
    DemoFacility('경찰시설 예시', FacilityType.police, LatLng(35.8688, 128.6000)),
    DemoFacility('소방시설 예시', FacilityType.fire, LatLng(35.8638, 128.5960)),
    DemoFacility('CCTV 예시', FacilityType.cctv, LatLng(35.8690, 128.5930)),
    DemoFacility('가로등 예시', FacilityType.light, LatLng(35.8650, 128.5885)),
    DemoFacility('CCTV 예시', FacilityType.cctv, LatLng(35.8608, 128.5945)),
    DemoFacility('가로등 예시', FacilityType.light, LatLng(35.8720, 128.5910)),
  ];

  Color _facilityColor(FacilityType type) {
    switch (type) {
      case FacilityType.police:
        return const Color(0xFF2767C7);
      case FacilityType.fire:
        return const Color(0xFFE46D32);
      case FacilityType.cctv:
        return const Color(0xFF7B61A8);
      case FacilityType.light:
        return const Color(0xFFD39A19);
    }
  }

  IconData _facilityIcon(FacilityType type) {
    switch (type) {
      case FacilityType.police:
        return Icons.local_police;
      case FacilityType.fire:
        return Icons.fire_truck;
      case FacilityType.cctv:
        return Icons.videocam;
      case FacilityType.light:
        return Icons.lightbulb;
    }
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[
      Marker(
        point: _start,
        width: 44,
        height: 44,
        child: const _Pin(color: Color(0xFF176B5B), icon: Icons.my_location, label: '출발'),
      ),
      Marker(
        point: _destination,
        width: 44,
        height: 44,
        child: const _Pin(color: Color(0xFFCA4C45), icon: Icons.flag, label: '도착'),
      ),
    ];

    if (_showFacilities) {
      for (final facility in _facilities) {
        markers.add(
          Marker(
            point: facility.point,
            width: 38,
            height: 38,
            child: Tooltip(
              message: facility.name,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: _facilityColor(facility.type), width: 2),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Icon(_facilityIcon(facility.type),
                    color: _facilityColor(facility.type), size: 19),
              ),
            ),
          ),
        );
      }
    }
    return markers;
  }

  void _fitRoutes() {
    _mapController.fitCamera(
      CameraFit.coordinates(
        coordinates: [..._fastRoute, ..._saferRoute],
        padding: const EdgeInsets.fromLTRB(38, 110, 38, 290),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _start,
              initialZoom: 14.5,
              interactionOptions: InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.daegu_safe_route_demo',
              ),
              if (_showFast)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _fastRoute,
                      strokeWidth: _selectedRoute == 0 ? 8 : 5,
                      color: const Color(0xFF2584D8).withOpacity(_selectedRoute == 0 ? 1 : 0.65),
                    ),
                  ],
                ),
              if (_showSafer)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _saferRoute,
                      strokeWidth: _selectedRoute == 1 ? 8 : 5,
                      color: const Color(0xFF15966F).withOpacity(_selectedRoute == 1 ? 1 : 0.65),
                    ),
                  ],
                ),
              MarkerLayer(markers: _buildMarkers()),
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    '© OpenStreetMap contributors',
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_moon, color: Color(0xFF176B5B), size: 27),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('대구 안심길', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                                Text('빠른 길과 안심 요소가 많은 길 비교', style: TextStyle(fontSize: 11, color: Colors.black54)),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: '경로 전체 보기',
                            onPressed: _fitRoutes,
                            icon: const Icon(Icons.center_focus_strong),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_outlined, color: Color(0xFF176B5B)),
                          SizedBox(width: 8),
                          Expanded(child: Text('대구 중구 · 시연용 출발지', style: TextStyle(fontWeight: FontWeight.w600))),
                          Icon(Icons.swap_vert, color: Colors.black45),
                          SizedBox(width: 8),
                          Expanded(child: Text('대구 남구 방향 · 시연용 목적지', style: TextStyle(fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 14,
            top: 175,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'layers',
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF176B5B),
                  onPressed: () => setState(() => _showFacilities = !_showFacilities),
                  child: Icon(_showFacilities ? Icons.layers : Icons.layers_outlined),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'zoom',
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF176B5B),
                  onPressed: _fitRoutes,
                  child: const Icon(Icons.route),
                ),
              ],
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: SafeArea(
              top: false,
              child: _routePanel(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _routePanel() {
    return Material(
      elevation: 9,
      borderRadius: BorderRadius.circular(22),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('추천 경로 비교', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3D9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('DEMO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF946400))),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _routeOption(
              index: 0,
              title: '가장 빠른 경로',
              subtitle: '시연용 경로 · 실제 보행시간 아님',
              time: '약 12분',
              color: const Color(0xFF2584D8),
            ),
            const SizedBox(height: 8),
            _routeOption(
              index: 1,
              title: '안심 요소가 많은 경로',
              subtitle: '시설 표시 예시를 반영한 시연 경로',
              time: '약 15분',
              color: const Color(0xFF15966F),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                const Expanded(
                  child: Text(
                    '지도 경로·시설 위치·시간은 모두 예시입니다. 실제 안전도나 길찾기 정보가 아닙니다.',
                    style: TextStyle(fontSize: 10, color: Colors.black54, height: 1.35),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _routeOption({
    required int index,
    required String title,
    required String subtitle,
    required String time,
    required Color color,
  }) {
    final selected = _selectedRoute == index;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _selectedRoute = index),
      child: Container(
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? color : const Color(0xFFE5E9E7), width: selected ? 1.7 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 10)),
                ],
              ),
            ),
            Text(time, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(width: 5),
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? color : Colors.black38, size: 19),
          ],
        ),
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  const _Pin({required this.color, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
          child: Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800)),
        ),
      ],
    );
  }
}
