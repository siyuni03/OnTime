class LocationResult {
  final double latitude;
  final double longitude;

  const LocationResult({
    required this.latitude,
    required this.longitude,
  });
}

class LocationService {
  LocationService._();

  static Future<LocationResult?> getCoordinates(
    String address,
  ) async {
    // 추후 지도/주소 API 연결
    return null;
  }
}