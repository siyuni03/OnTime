import 'package:flutter/material.dart';

import '../models/schedule.dart';
import '../theme/app_theme.dart';
import '../widgets/schedule_card.dart';
import '../widgets/schedule_detail_sheet.dart';

class PastSchedulesScreen extends StatelessWidget {
  final List<Schedule> schedules;

  const PastSchedulesScreen({super.key, required this.schedules});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final pastSchedules =
        schedules.where((schedule) => schedule.startAt.isBefore(now)).toList()
          ..sort((a, b) => b.startAt.compareTo(a.startAt));

    return Scaffold(
      backgroundColor: OnTimeColors.background,
      appBar: AppBar(
        title: const Text(
          '지난 일정',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: OnTimeColors.darkBrown,
          ),
        ),
      ),
      body: pastSchedules.isEmpty
          ? const Center(
              child: Text(
                '지난 일정이 없습니다.',
                style: TextStyle(
                  fontSize: 15,
                  color: OnTimeColors.secondaryText,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              itemCount: pastSchedules.length,
              separatorBuilder: (_, __) {
                return const SizedBox(height: 12);
              },
              itemBuilder: (context, index) {
                final schedule = pastSchedules[index];

                return ListScheduleCard(
                  schedule: schedule,
                  onTap: () {
                    showScheduleDetail(
                      context,
                      schedule,
                      onDelete: () {},
                      onEdit: () {},
                    );
                  },
                );
              },
            ),
    );
  }
}
