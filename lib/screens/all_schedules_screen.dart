import 'package:flutter/material.dart';

import '../models/schedule.dart';
import '../theme/app_theme.dart';
import '../widgets/schedule_card.dart';
import '../widgets/schedule_detail_sheet.dart';

class AllSchedulesScreen extends StatefulWidget {
  final List<Schedule> schedules;
  final void Function(Schedule schedule) onDelete;

  const AllSchedulesScreen({
    super.key,
    required this.schedules,
    required this.onDelete,
  });
  @override
  State<AllSchedulesScreen> createState() => _AllSchedulesScreenState();
}

class _AllSchedulesScreenState extends State<AllSchedulesScreen> {
  bool isMonthlyView = true;

  late DateTime _currentMonth;
  late DateTime _currentWeek;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();

    _currentMonth = DateTime(now.year, now.month, 1);

    _currentWeek = _startOfWeek(now);
  }

  // ============================================================
  // 주의 시작일
  // ============================================================

  DateTime _startOfWeek(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    ).subtract(Duration(days: date.weekday - 1));
  }

  // ============================================================
  // 월 이동
  // ============================================================

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  // ============================================================
  // 주 이동
  // ============================================================

  void _previousWeek() {
    setState(() {
      _currentWeek = _currentWeek.subtract(const Duration(days: 7));
    });
  }

  void _nextWeek() {
    setState(() {
      _currentWeek = _currentWeek.add(const Duration(days: 7));
    });
  }

  // ============================================================
  // 월별 일정
  // ============================================================

  List<Schedule> get _monthlySchedules {
    return widget.schedules
        .where(
          (schedule) =>
              schedule.date.year == _currentMonth.year &&
              schedule.date.month == _currentMonth.month,
        )
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  // ============================================================
  // 주별 일정
  // ============================================================

  List<Schedule> get _weeklySchedules {
    final weekEnd = _currentWeek.add(const Duration(days: 6));

    return widget.schedules
        .where(
          (schedule) =>
              !schedule.date.isBefore(_currentWeek) &&
              !schedule.date.isAfter(weekEnd),
        )
        .toList()
      ..sort((a, b) => a.startAt.compareTo(b.startAt));
  }

  // ============================================================
  // 날짜 표시
  // ============================================================

  String _formatDate(DateTime date) {
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];

    return '${date.month}월 ${date.day}일 '
        '(${weekdays[date.weekday - 1]})';
  }

  // ============================================================
  // 일정 카드
  // ============================================================

  Widget _scheduleCard(BuildContext context, Schedule schedule) {
    return ListScheduleCard(
      schedule: schedule,
      onTap: () {
        showScheduleDetail(
          context,
          schedule,
          onDelete: () {
            widget.onDelete(schedule);
          },
          onEdit: () {},
        );
      },
    );
  }

  // ============================================================
  // 월별 화면
  // ============================================================

  Widget _buildMonthlyView(BuildContext context) {
    final schedules = _monthlySchedules;

    if (schedules.isEmpty) {
      return const Center(
        child: Text(
          '등록된 일정이 없습니다.',
          style: TextStyle(fontSize: 15, color: OnTimeColors.secondaryText),
        ),
      );
    }

    final grouped = <String, List<Schedule>>{};

    for (final schedule in schedules) {
      final key =
          '${schedule.date.year}-'
          '${schedule.date.month}-'
          '${schedule.date.day}';

      grouped.putIfAbsent(key, () => []);

      grouped[key]!.add(schedule);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        for (final entry in grouped.entries) ...[
          Builder(
            builder: (context) {
              final date = entry.value.first.date;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Text(
                  _formatDate(date),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: OnTimeColors.darkBrown,
                  ),
                ),
              );
            },
          ),

          for (final schedule in entry.value) ...[
            _scheduleCard(context, schedule),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }

  // ============================================================
  // 주별 화면
  // ============================================================

  Widget _buildWeeklyView(BuildContext context) {
    final schedules = _weeklySchedules;

    if (schedules.isEmpty) {
      return const Center(
        child: Text(
          '등록된 일정이 없습니다.',
          style: TextStyle(fontSize: 15, color: OnTimeColors.secondaryText),
        ),
      );
    }

    final grouped = <String, List<Schedule>>{};

    for (final schedule in schedules) {
      final key =
          '${schedule.date.year}-'
          '${schedule.date.month}-'
          '${schedule.date.day}';

      grouped.putIfAbsent(key, () => []);

      grouped[key]!.add(schedule);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      children: [
        for (final entry in grouped.entries) ...[
          Builder(
            builder: (context) {
              final date = entry.value.first.date;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Text(
                  _formatDate(date),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: OnTimeColors.darkBrown,
                  ),
                ),
              );
            },
          ),

          for (final schedule in entry.value) ...[
            _scheduleCard(context, schedule),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = isMonthlyView
        ? '${_currentMonth.year}년 ${_currentMonth.month}월'
        : '${_formatDate(_currentWeek)} ~ '
              '${_formatDate(_currentWeek.add(const Duration(days: 6)))}';

    return Scaffold(
      backgroundColor: OnTimeColors.background,

      appBar: AppBar(
        title: const Text(
          '전체 일정',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: OnTimeColors.darkBrown,
          ),
        ),
      ),

      body: Column(
        children: [
          // ======================================================
          // 월 / 주 선택
          // ======================================================

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: OnTimeColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _ViewTypeButton(
                      title: '월별',
                      selected: isMonthlyView,
                      onTap: () {
                        setState(() {
                          isMonthlyView = true;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: _ViewTypeButton(
                      title: '주별',
                      selected: !isMonthlyView,
                      onTap: () {
                        setState(() {
                          isMonthlyView = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ======================================================
          // 이전 / 현재 / 다음
          // ======================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: isMonthlyView ? _previousMonth : _previousWeek,
                  icon: const Icon(Icons.chevron_left_rounded),
                  color: OnTimeColors.darkBrown,
                ),

                Expanded(
                  child: Center(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: OnTimeColors.darkBrown,
                      ),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: isMonthlyView ? _nextMonth : _nextWeek,
                  icon: const Icon(Icons.chevron_right_rounded),
                  color: OnTimeColors.darkBrown,
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: OnTimeColors.border),

          // ======================================================
          // 일정
          // ======================================================
          Expanded(
            child: isMonthlyView
                ? _buildMonthlyView(context)
                : _buildWeeklyView(context),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// 월별 / 주별 선택 버튼
// ============================================================

class _ViewTypeButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ViewTypeButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected ? OnTimeColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: selected ? Colors.white : OnTimeColors.darkBrown,
            ),
          ),
        ),
      ),
    );
  }
}
