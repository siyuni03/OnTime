import 'dart:async';

import 'package:flutter/material.dart';

import '../models/schedule.dart';
import '../services/notification_service.dart';
import 'past_schedules_screen.dart';
import 'notification_history_screen.dart';
import '../widgets/ontime_logo.dart';
import '../widgets/time_news_panel.dart';
import '../widgets/schedule_card.dart';
import '../widgets/schedule_detail_sheet.dart';
import '../widgets/empty_schedule_card.dart';
import '../widgets/flow_card.dart';
import 'schedule_add_screen.dart';
import 'all_schedules_screen.dart';

// ============================================================
// 색상
// ============================================================

class OnTimeColors {
  static const background = Color(0xFFF8F5EF);
  static const primary = Color(0xFF8B5E3C);
  static const darkBrown = Color(0xFF5C4033);
  static const text = Color(0xFF3E3028);
  static const card = Colors.white;
  static const border = Color(0xFFE5DED5);
  static const lightBrown = Color(0xFFFFF3E8);
  static const green = Color(0xFF6FA36F);
}

// ============================================================
// 홈 화면
// ============================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;

  DateTime _now = DateTime.now();

  final List<Schedule> _savedSchedules = [];

  // ==========================================================
  // 일정 등록
  // ==========================================================

  void _addSchedule(
    String title,
    String location,
    String departureLocation,
    DateTime date,
    String startTime,
    int bufferMinutes,
    MobilityMode mobilityMode,
    String memo,
  ) {
    final newSchedule = Schedule(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      location: location,
      departureLocation: departureLocation,
      startTime: startTime,
      departureTime: _calculateDepartureTime(startTime, bufferMinutes),
      travelMinutes: 0,
      bufferMinutes: bufferMinutes,
      memo: memo,
      mobilityMode: mobilityMode,
      date: date,
    );

    setState(() {
      _savedSchedules.add(newSchedule);
    });

    // 일정 등록 시 알림 3개 예약
    _scheduleDepartureNotifications(newSchedule);
  }

  // ==========================================================
  // 일정 수정
  // ==========================================================

  void _updateSchedule(
    String id,
    String title,
    String location,
    String departureLocation,
    DateTime date,
    String startTime,
    int bufferMinutes,
    MobilityMode mobilityMode,
    String memo,
  ) {
    final notificationId = _notificationIdFor(id);

    // 기존 알림 3개 취소
    unawaited(NotificationService.cancelDepartureNotifications(notificationId));

    final savedIndex = _savedSchedules.indexWhere((item) => item.id == id);

    // 직접 등록한 일정 수정
    if (savedIndex != -1) {
      late Schedule updatedSchedule;

      setState(() {
        final oldSchedule = _savedSchedules[savedIndex];

        updatedSchedule = Schedule(
          id: oldSchedule.id,
          title: title,
          location: location,
          departureLocation: departureLocation,
          startTime: startTime,
          departureTime: _calculateDepartureTime(startTime, bufferMinutes),
          travelMinutes: oldSchedule.travelMinutes,
          bufferMinutes: bufferMinutes,
          memo: memo,
          mobilityMode: mobilityMode,
          date: date,
          icon: oldSchedule.icon,
          status: oldSchedule.status,
        );

        _savedSchedules[savedIndex] = updatedSchedule;
      });

      // 수정된 일정의 알림 3개 재예약
      _scheduleDepartureNotifications(updatedSchedule);

      return;
    }

    // 샘플 일정 수정
    final sampleIndex = schedules.indexWhere((item) => item.id == id);

    if (sampleIndex != -1) {
      final oldSchedule = schedules[sampleIndex];

      late Schedule updatedSchedule;

      setState(() {
        updatedSchedule = Schedule(
          id: oldSchedule.id,
          title: title,
          location: location,
          departureLocation: departureLocation,
          startTime: startTime,
          departureTime: _calculateDepartureTime(startTime, bufferMinutes),
          travelMinutes: oldSchedule.travelMinutes,
          bufferMinutes: bufferMinutes,
          memo: memo,
          mobilityMode: mobilityMode,
          date: date,
          icon: oldSchedule.icon,
          status: oldSchedule.status,
        );

        _savedSchedules.add(updatedSchedule);
      });

      // 수정된 일정의 알림 3개 재예약
      _scheduleDepartureNotifications(updatedSchedule);
    }
  }

  // 현재 선택된 캘린더 날짜
  late DateTime _selectedDate;

  // 현재 보고 있는 캘린더의 월
  late DateTime _calendarMonth;

  // true = 목록형
  // false = 아이콘형
  bool isListView = true;

  // 사용 방법 펼침 여부
  bool showHowToUse = false;

  // 소리 켜짐 여부
  bool soundEnabled = true;

  @override
  void initState() {
    super.initState();

    _selectedDate = DateTime(_now.year, _now.month, _now.day);

    _calendarMonth = DateTime(_now.year, _now.month, 1);

    // 1초마다 실제 현재 시간 갱신
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ==========================================================
  // 샘플 일정
  // ==========================================================

  List<Schedule> get schedules {
    return [
      Schedule(
        id: 'sample_1',
        title: '캡스톤 AI 수업',
        location: '진실관 301호',
        startTime: '14:00',
        departureTime: '13:45',
        travelMinutes: 10,
        bufferMinutes: 5,
        memo: '발표 자료와 노트북을 준비하기',
        date: DateTime(_now.year, _now.month, 5),
        icon: Icons.school_outlined,
      ),
      Schedule(
        id: 'sample_2',
        title: '정보윤리 수업',
        location: '교육관 204호',
        startTime: '16:00',
        departureTime: '15:40',
        travelMinutes: 15,
        bufferMinutes: 5,
        memo: '지난 시간 과제 제출',
        date: DateTime(_now.year, _now.month, 5),
        icon: Icons.menu_book_outlined,
      ),
      Schedule(
        id: 'sample_3',
        title: '팀 프로젝트 회의',
        location: '도서관 스터디룸',
        startTime: '18:30',
        departureTime: '18:10',
        travelMinutes: 15,
        bufferMinutes: 5,
        memo: '회의 자료 확인',
        date: DateTime(_now.year, _now.month, 5),
        icon: Icons.groups_outlined,
      ),
      Schedule(
        id: 'sample_4',
        title: '자료구조 수업',
        location: '공학관 402호',
        startTime: '10:00',
        departureTime: '09:40',
        travelMinutes: 15,
        bufferMinutes: 5,
        memo: '실습 코드 확인',
        date: DateTime(_now.year, _now.month, 7),
        icon: Icons.code_outlined,
      ),
      Schedule(
        id: 'sample_5',
        title: '개발팀 회의',
        location: '온라인 Zoom',
        startTime: '19:00',
        departureTime: '18:50',
        travelMinutes: 0,
        bufferMinutes: 10,
        memo: '이번 주 개발 진행상황 공유',
        date: DateTime(_now.year, _now.month, 7),
        icon: Icons.video_camera_front_outlined,
      ),
    ];
  }

  // ==========================================================
  // 현재 선택된 날짜의 일정
  // ==========================================================

  List<Schedule> get selectedSchedules {
    final savedIds = _savedSchedules.map((schedule) => schedule.id).toSet();

    return [
      ...schedules.where((schedule) => !savedIds.contains(schedule.id)),
      ..._savedSchedules,
    ].where((schedule) {
      return _isSameDate(schedule.date, _selectedDate);
    }).toList();
  }

  // ==========================================================
  // 날짜 비교
  // ==========================================================

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // ==========================================================
  // 현재 시간
  // ==========================================================

  String getCurrentTime() {
    return '${_twoDigits(_now.hour)}:'
        '${_twoDigits(_now.minute)}:'
        '${_twoDigits(_now.second)}';
  }

  String _twoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  // ==========================================================
  // 출발 시간 계산
  // ==========================================================

  String _calculateDepartureTime(String startTime, int bufferMinutes) {
    final parts = startTime.split(':');

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final start = DateTime(2000, 1, 1, hour, minute);

    final departure = start.subtract(Duration(minutes: bufferMinutes));

    return '${_twoDigits(departure.hour)}:'
        '${_twoDigits(departure.minute)}';
  }

  // ==========================================================
  // 일정별 고유 알림 ID 생성
  // ==========================================================

  int _notificationIdFor(String scheduleId) {
    int hash = 2166136261;

    for (final codeUnit in scheduleId.codeUnits) {
      hash ^= codeUnit;
      hash = (hash * 16777619) & 0x7fffffff;
    }

    return (hash % 100000000) + 1;
  }

  // ==========================================================
  // 일정의 출발 시각을 기준으로 알림 3개 예약
  // ==========================================================

  void _scheduleDepartureNotifications(Schedule schedule) {
    final departureParts = schedule.departureTime.split(':');

    final departureDateTime = DateTime(
      schedule.date.year,
      schedule.date.month,
      schedule.date.day,
      int.parse(departureParts[0]),
      int.parse(departureParts[1]),
    );

    unawaited(
      NotificationService.scheduleDepartureNotifications(
        id: _notificationIdFor(schedule.id),
        departureTime: departureDateTime,
        title: schedule.title,
      ),
    );
  }

  // ==========================================================
  // 요일
  // ==========================================================

  String getWeekday() {
    const weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];

    return weekdays[_selectedDate.weekday - 1];
  }

  // ==========================================================
  // 설정 화면
  // ==========================================================

  void openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          soundEnabled: soundEnabled,
          onSoundChanged: (value) {
            setState(() {
              soundEnabled = value;
            });
          },
        ),
      ),
    );
  }

  // ==========================================================
  // 오른쪽 사이드 메뉴
  // ==========================================================

  void openSideMenu() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '메뉴 닫기',
      barrierColor: Colors.black.withOpacity(0.52),
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: SideMenu(
            schedules: [...schedules, ..._savedSchedules],

            onClose: () {
              Navigator.pop(context);
            },

            onSettings: () {
              Navigator.pop(context);
              openSettings();
            },

            onDelete: (schedule) {
              setState(() {
                _savedSchedules.removeWhere((item) => item.id == schedule.id);
              });
            },
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  // ==========================================================
  // 이전 달
  // ==========================================================

  void previousMonth() {
    setState(() {
      _calendarMonth = DateTime(
        _calendarMonth.year,
        _calendarMonth.month - 1,
        1,
      );

      _selectedDate = DateTime(_calendarMonth.year, _calendarMonth.month, 1);
    });
  }

  // ==========================================================
  // 다음 달
  // ==========================================================

  void nextMonth() {
    setState(() {
      _calendarMonth = DateTime(
        _calendarMonth.year,
        _calendarMonth.month + 1,
        1,
      );

      _selectedDate = DateTime(_calendarMonth.year, _calendarMonth.month, 1);
    });
  }

  // ==========================================================
  // 연도 / 월 선택
  // ==========================================================

  void showMonthYearPicker() {
    int selectedYear = _calendarMonth.year;
    int selectedMonth = _calendarMonth.month;

    final monthController = FixedExtentScrollController(
      initialItem: selectedMonth - 1,
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: OnTimeColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      '연도 / 월 선택',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: OnTimeColors.text,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 연도
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setModalState(() {
                              selectedYear--;
                            });
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                          color: OnTimeColors.primary,
                        ),

                        Text(
                          '$selectedYear년',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: OnTimeColors.darkBrown,
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            setModalState(() {
                              selectedYear++;
                            });
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          color: OnTimeColors.primary,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // 월 Wheel Picker
                    SizedBox(
                      height: 150,
                      child: ListWheelScrollView.useDelegate(
                        controller: monthController,
                        itemExtent: 42,
                        perspective: 0.002,
                        diameterRatio: 1.4,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setModalState(() {
                            selectedMonth = index + 1;
                          });
                        },
                        childDelegate: ListWheelChildLoopingListDelegate(
                          children: List.generate(12, (index) {
                            final month = index + 1;

                            final selected = month == selectedMonth;

                            return Center(
                              child: Text(
                                '$month월',
                                style: TextStyle(
                                  fontSize: selected ? 20 : 16,
                                  fontWeight: selected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: selected
                                      ? OnTimeColors.primary
                                      : Colors.grey,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _calendarMonth = DateTime(
                              selectedYear,
                              selectedMonth,
                              1,
                            );

                            _selectedDate = DateTime(
                              selectedYear,
                              selectedMonth,
                              1,
                            );
                          });

                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: OnTimeColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('선택 완료'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // 화면
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: OnTimeColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        titleSpacing: 20,

        title: Row(
          children: [
            const OnTimeLogo(size: 38),

            const SizedBox(width: 10),

            const Text(
              'OnTime',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: OnTimeColors.darkBrown,
              ),
            ),
          ],
        ),

        actions: [
          // 소리
          IconButton(
            tooltip: soundEnabled ? '소리 끄기' : '소리 켜기',
            onPressed: () {
              setState(() {
                soundEnabled = !soundEnabled;
              });
            },
            icon: Icon(
              soundEnabled
                  ? Icons.volume_up_outlined
                  : Icons.volume_off_outlined,
              color: OnTimeColors.darkBrown,
            ),
          ),

          // 설정
          IconButton(
            tooltip: '설정',
            onPressed: openSettings,
            icon: const Icon(
              Icons.settings_outlined,
              color: OnTimeColors.darkBrown,
            ),
          ),

          // 메뉴
          IconButton(
            tooltip: '메뉴',
            onPressed: openSideMenu,
            icon: const Icon(Icons.menu, color: OnTimeColors.darkBrown),
          ),

          const SizedBox(width: 8),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 현재 시간 + 뉴스
              TimeNewsPanel(
                currentTime: getCurrentTime(),
                dateText: '${_now.month}월 ${_now.day}일 ${getWeekday()}',
              ),

              const SizedBox(height: 18),

              // 작은 월간 캘린더
              CalendarPanel(
                calendarMonth: _calendarMonth,
                selectedDate: _selectedDate,
                schedules: [...schedules, ..._savedSchedules],
                onPreviousMonth: previousMonth,
                onNextMonth: nextMonth,
                onDateSelected: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                },
                onMonthYearTap: showMonthYearPicker,
              ),

              const SizedBox(height: 22),

              // 선택된 날짜 일정 제목
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      _isSameDate(
                            _selectedDate,
                            DateTime(_now.year, _now.month, _now.day),
                          )
                          ? '오늘의 이동 일정'
                          : '${_selectedDate.month}월 ${_selectedDate.day}일 일정',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: OnTimeColors.text,
                      ),
                    ),
                  ),

                  // 목록 / 아이콘 전환
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: OnTimeColors.border),
                    ),
                    child: Row(
                      children: [
                        ViewModeButton(
                          icon: Icons.view_list_rounded,
                          selected: isListView,
                          onPressed: () {
                            setState(() {
                              isListView = true;
                            });
                          },
                        ),
                        ViewModeButton(
                          icon: Icons.grid_view_rounded,
                          selected: !isListView,
                          onPressed: () {
                            setState(() {
                              isListView = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // 일정
              if (selectedSchedules.isEmpty)
                EmptyScheduleCard()
              else if (isListView)
                Column(
                  children: selectedSchedules
                      .map(
                        (schedule) => ListScheduleCard(
                          schedule: schedule,
                          onTap: () {
                            showScheduleDetail(
                              context,
                              schedule,
                              onDelete: () {
                                setState(() {
                                  _savedSchedules.removeWhere(
                                    (item) => item.id == schedule.id,
                                  );
                                });
                              },
                              onEdit: () {
                                print('수정 버튼 연결됨');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScheduleAddScreen(
                                      initialSchedule: schedule,
                                      onSave:
                                          (
                                            title,
                                            location,
                                            departureLocation,
                                            date,
                                            startTime,
                                            bufferMinutes,
                                            mobilityMode,
                                            memo,
                                          ) {
                                            _updateSchedule(
                                              schedule.id,
                                              title,
                                              location,
                                              departureLocation,
                                              date,
                                              startTime,
                                              bufferMinutes,
                                              mobilityMode,
                                              memo,
                                            );

                                            Navigator.pop(context);
                                          },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                      .toList(),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: selectedSchedules.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.88,
                  ),
                  itemBuilder: (context, index) {
                    final schedule = selectedSchedules[index];

                    return GridScheduleCard(
                      schedule: schedule,
                      onTap: () {
                        showScheduleDetail(
                          context,
                          schedule,
                          onDelete: () {
                            setState(() {
                              _savedSchedules.removeWhere(
                                (item) => item.id == schedule.id,
                              );
                            });
                          },
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ScheduleAddScreen(
                                  initialSchedule: schedule,
                                  onSave:
                                      (
                                        title,
                                        location,
                                        departureLocation,
                                        date,
                                        startTime,
                                        bufferMinutes,
                                        mobilityMode,
                                        memo,
                                      ) {
                                        _updateSchedule(
                                          schedule.id,
                                          title,
                                          location,
                                          departureLocation,
                                          date,
                                          startTime,
                                          bufferMinutes,
                                          mobilityMode,
                                          memo,
                                        );

                                        Navigator.pop(context);
                                      },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),

              const SizedBox(height: 24),

              // OnTime 사용 방법
              GestureDetector(
                onTap: () {
                  setState(() {
                    showHowToUse = !showHowToUse;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 17,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(color: OnTimeColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.help_outline_rounded,
                        color: OnTimeColors.primary,
                      ),

                      const SizedBox(width: 10),

                      const Expanded(
                        child: Text(
                          'OnTime 사용 방법',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: OnTimeColors.text,
                          ),
                        ),
                      ),

                      AnimatedRotation(
                        turns: showHowToUse ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: OnTimeColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 사용 방법
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: showHowToUse
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Column(
                    children: const [
                      FlowCard(
                        number: '01',
                        title: '일정 등록',
                        description: '도착해야 하는 시간과 장소를 입력합니다.',
                        icon: Icons.event_note,
                      ),
                      FlowCard(
                        number: '02',
                        title: '이동시간 계산',
                        description: '이동시간과 여유시간을 계산합니다.',
                        icon: Icons.calculate_outlined,
                      ),
                      FlowCard(
                        number: '03',
                        title: '출발 알림',
                        description: '출발할 시간이 되면 알려줍니다.',
                        icon: Icons.notifications_active_outlined,
                      ),
                      FlowCard(
                        number: '04',
                        title: '도착 확인',
                        description: '도착 후 버튼을 눌러 일정을 완료합니다.',
                        icon: Icons.check_circle_outline,
                      ),
                    ],
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),

      // 일정 등록
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScheduleAddScreen(
                onSave:
                    (
                      title,
                      location,
                      departureLocation,
                      date,
                      startTime,
                      bufferMinutes,
                      mobilityMode,
                      memo,
                    ) {
                      _addSchedule(
                        title,
                        location,
                        departureLocation,
                        date,
                        startTime,
                        bufferMinutes,
                        mobilityMode,
                        memo,
                      );

                      Navigator.pop(context);
                    },
              ),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('일정 등록'),
      ),
    );
  }
}

// ============================================================
// 캘린더
// ============================================================

class CalendarPanel extends StatelessWidget {
  final DateTime calendarMonth;
  final DateTime selectedDate;
  final List<Schedule> schedules;

  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final VoidCallback onMonthYearTap;

  final ValueChanged<DateTime> onDateSelected;

  const CalendarPanel({
    super.key,
    required this.calendarMonth,
    required this.selectedDate,
    required this.schedules,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onMonthYearTap,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(calendarMonth.year, calendarMonth.month, 1);

    final lastDay = DateTime(calendarMonth.year, calendarMonth.month + 1, 0);

    final firstWeekday = firstDay.weekday;
    final totalDays = lastDay.day;

    final cells = <DateTime?>[];

    // 월요일부터 시작
    for (int i = 1; i < firstWeekday; i++) {
      cells.add(null);
    }

    for (int day = 1; day <= totalDays; day++) {
      cells.add(DateTime(calendarMonth.year, calendarMonth.month, day));
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: OnTimeColors.border),
      ),
      child: Column(
        children: [
          // 연도 / 월 + 이전 / 다음
          Row(
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onPreviousMonth,
                icon: const Icon(Icons.chevron_left_rounded),
                color: OnTimeColors.darkBrown,
              ),

              Expanded(
                child: GestureDetector(
                  onTap: onMonthYearTap,
                  child: Column(
                    children: [
                      Text(
                        '${calendarMonth.year}년',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 1),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${calendarMonth.month}월',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: OnTimeColors.darkBrown,
                            ),
                          ),

                          const SizedBox(width: 3),

                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: OnTimeColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: onNextMonth,
                icon: const Icon(Icons.chevron_right_rounded),
                color: OnTimeColors.darkBrown,
              ),
            ],
          ),

          const SizedBox(height: 7),

          // 요일
          Row(
            children: const [
              CalendarWeekday(title: '월'),
              CalendarWeekday(title: '화'),
              CalendarWeekday(title: '수'),
              CalendarWeekday(title: '목'),
              CalendarWeekday(title: '금'),
              CalendarWeekday(title: '토'),
              CalendarWeekday(title: '일'),
            ],
          ),

          const SizedBox(height: 4),

          // 날짜
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cells.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.25,
            ),
            itemBuilder: (context, index) {
              final date = cells[index];

              if (date == null) {
                return const SizedBox.shrink();
              }

              final isSelected = _isSameDate(date, selectedDate);

              final hasSchedule = schedules.any(
                (schedule) => _isSameDate(schedule.date, date),
              );

              return GestureDetector(
                onTap: () {
                  onDateSelected(date);
                },
                child: CalendarDayCell(
                  date: date,
                  isSelected: isSelected,
                  hasSchedule: hasSchedule,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

// ============================================================
// 캘린더 요일
// ============================================================

class CalendarWeekday extends StatelessWidget {
  final String title;

  const CalendarWeekday({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: title == '일'
                ? Colors.red.shade300
                : title == '토'
                ? Colors.blueGrey
                : Colors.grey,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 캘린더 날짜 셀
// ============================================================

class CalendarDayCell extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool hasSchedule;

  const CalendarDayCell({
    super.key,
    required this.date,
    required this.isSelected,
    required this.hasSchedule,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 31,
        height: 31,
        decoration: BoxDecoration(
          color: isSelected ? OnTimeColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : OnTimeColors.text,
              ),
            ),

            if (hasSchedule && !isSelected)
              Positioned(
                bottom: 2,
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: OnTimeColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 상세 정보 Row
// ============================================================

class DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const DetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 21, color: OnTimeColors.primary),

          const SizedBox(width: 12),

          SizedBox(
            width: 88,
            child: Text(
              title,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: OnTimeColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 목록 / 아이콘 전환 버튼
// ============================================================

class ViewModeButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  const ViewModeButton({
    super.key,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 42,
        height: 38,
        decoration: BoxDecoration(
          color: selected ? OnTimeColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: selected ? Colors.white : OnTimeColors.primary,
        ),
      ),
    );
  }
}

// ============================================================
// 오른쪽 사이드 메뉴
// ============================================================

class SideMenu extends StatelessWidget {
  final List<Schedule> schedules;
  final VoidCallback onClose;
  final VoidCallback onSettings;
  final ValueChanged<Schedule> onDelete;

  const SideMenu({
    super.key,
    required this.schedules,
    required this.onClose,
    required this.onSettings,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        widthFactor: 0.34,
        child: Material(
          color: OnTimeColors.background,
          elevation: 12,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 메뉴 상단
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 22, 10, 18),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '메뉴',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: OnTimeColors.darkBrown,
                        ),
                      ),
                    ),

                    IconButton(
                      onPressed: onClose,
                      icon: const Icon(Icons.close, size: 20),
                      color: OnTimeColors.darkBrown,
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: OnTimeColors.border),

              const SizedBox(height: 12),

              // 메뉴 목록
              SideMenuItem(
                icon: Icons.home_outlined,
                title: '홈',
                onTap: onClose,
              ),

              SideMenuItem(
                icon: Icons.calendar_month_outlined,
                title: '전체 일정',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllSchedulesScreen(
                        schedules: schedules,
                        onDelete: onDelete,
                      ),
                    ),
                  );
                },
              ),

              SideMenuItem(
                icon: Icons.history,
                title: '지난 일정',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PastSchedulesScreen(schedules: schedules),
                    ),
                  );
                },
              ),

              SideMenuItem(
                icon: Icons.notifications_none_outlined,
                title: '알림 기록',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationHistoryScreen(),
                    ),
                  );
                },
              ),

              const Spacer(),

              const Divider(height: 1, color: OnTimeColors.border),

              SideMenuItem(
                icon: Icons.settings_outlined,
                title: '설정',
                onTap: onSettings,
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// 사이드 메뉴 항목
// ============================================================

class SideMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SideMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 21, color: OnTimeColors.darkBrown),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: OnTimeColors.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// 설정 화면
// ============================================================

class SettingsScreen extends StatefulWidget {
  final bool soundEnabled;
  final ValueChanged<bool> onSoundChanged;

  const SettingsScreen({
    super.key,
    required this.soundEnabled,
    required this.onSoundChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool soundEnabled;

  double notificationVolume = 0.7;

  bool routineEnabled = false;

  @override
  void initState() {
    super.initState();
    soundEnabled = widget.soundEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnTimeColors.background,
      appBar: AppBar(
        backgroundColor: OnTimeColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          '설정',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: OnTimeColors.darkBrown,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            '앱 설정',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: OnTimeColors.darkBrown,
            ),
          ),

          const SizedBox(height: 10),

          SettingsSection(
            children: [
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: const Text('알림 소리'),
                subtitle: const Text('출발 및 일정 관련 알림 소리'),
                value: soundEnabled,
                activeColor: OnTimeColors.primary,
                onChanged: (value) {
                  setState(() {
                    soundEnabled = value;
                  });

                  widget.onSoundChanged(value);
                },
              ),

              const Divider(height: 1, color: OnTimeColors.border),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '알림 음량',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: OnTimeColors.text,
                      ),
                    ),

                    Slider(
                      value: notificationVolume,
                      activeColor: OnTimeColors.primary,
                      onChanged: soundEnabled
                          ? (value) {
                              setState(() {
                                notificationVolume = value;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: OnTimeColors.border),

              ListTile(
                title: const Text('알림 소리 종류'),
                subtitle: const Text('기본 알림음'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),

              const Divider(height: 1, color: OnTimeColors.border),

              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                title: const Text('루틴 설정'),
                subtitle: const Text('반복되는 일정을 관리합니다.'),
                value: routineEnabled,
                activeColor: OnTimeColors.primary,
                onChanged: (value) {
                  setState(() {
                    routineEnabled = value;
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 26),

          const Text(
            '화면 설정',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: OnTimeColors.darkBrown,
            ),
          ),

          const SizedBox(height: 10),

          SettingsSection(
            children: [
              ListTile(
                title: const Text('배경 색'),
                subtitle: const Text('OnTime 기본 크림색'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),

              const Divider(height: 1, color: OnTimeColors.border),

              ListTile(
                title: const Text('기타 앱 설정'),
                subtitle: const Text('향후 추가될 앱 설정'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 설정 섹션
// ============================================================

class SettingsSection extends StatelessWidget {
  final List<Widget> children;

  const SettingsSection({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: OnTimeColors.border),
      ),
      child: Column(children: children),
    );
  }
}
