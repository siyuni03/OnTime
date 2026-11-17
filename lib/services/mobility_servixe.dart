import '../models/schedule.dart';

class MobilityService {
  MobilityService._();

  static Future<int> getTravelMinutes({
    required MobilityMode mobilityMode,
    double? departureLatitude,
    double? departureLongitude,
    double? destinationLatitude,
    double? destinationLongitude,
  }) async {
    // 실제 지도 API 연결 전까지 사용할 임시 이동시간
    switch (mobilityMode) {
      case MobilityMode.walking:
        return 15;

      case MobilityMode.bicycle:
        return 10;

      case MobilityMode.kickboard:
        return 8;

      case MobilityMode.driving:
        return 12;
    }
  }
}