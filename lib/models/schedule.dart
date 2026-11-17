import 'package:flutter/material.dart';

class Schedule {
  final String id;
  final String title;
  final String location;
  final String departureLocation;
  final String startTime;
  final String departureTime;
  final int travelMinutes;
  final int bufferMinutes;
  final String memo;
  final DateTime date;
  final IconData icon;
  final ScheduleStatus status;
  final MobilityMode mobilityMode;
  final double? departureLatitude;
  final double? departureLongitude;
  final double? destinationLatitude;
  final double? destinationLongitude;

  const Schedule({
    this.id = '',
    required this.title,
    required this.location,
    this.departureLocation = '',
    required this.startTime,
    required this.departureTime,
    required this.travelMinutes,
    required this.bufferMinutes,
    required this.memo,
    required this.date,
    this.icon = Icons.event_note_outlined,
    this.status = ScheduleStatus.upcoming,
    this.mobilityMode = MobilityMode.walking,
    this.departureLatitude,
    this.departureLongitude,
    this.destinationLatitude,
    this.destinationLongitude,
  });

  // 기존 문자열 시간을 DateTime 형태로 사용할 수 있도록 제공
  DateTime get startAt {
    final parts = startTime.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  DateTime get departureAt {
    final parts = departureTime.split(':');
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  Schedule copyWith({
    String? id,
    String? title,
    String? location,
    String? departureLocation,
    String? startTime,
    String? departureTime,
    int? travelMinutes,
    int? bufferMinutes,
    String? memo,
    DateTime? date,
    IconData? icon,
    ScheduleStatus? status,
    MobilityMode? mobilityMode,
  }) {
    return Schedule(
      id: id ?? this.id,
      title: title ?? this.title,
      location: location ?? this.location,
      departureLocation: departureLocation ?? this.departureLocation,
      startTime: startTime ?? this.startTime,
      departureTime: departureTime ?? this.departureTime,
      travelMinutes: travelMinutes ?? this.travelMinutes,
      bufferMinutes: bufferMinutes ?? this.bufferMinutes,
      memo: memo ?? this.memo,
      date: date ?? this.date,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      mobilityMode: mobilityMode ?? this.mobilityMode,
      departureLatitude: departureLatitude ?? this.departureLatitude,
      departureLongitude: departureLongitude ?? this.departureLongitude,
      destinationLatitude: destinationLatitude ?? this.destinationLatitude,
      destinationLongitude: destinationLongitude ?? this.destinationLongitude,
    );
  }
}

enum ScheduleStatus { upcoming, completed, cancelled }

enum MobilityMode { walking, bicycle, kickboard, driving }
