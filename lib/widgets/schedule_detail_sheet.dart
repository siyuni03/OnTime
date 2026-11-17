import 'package:flutter/material.dart';

import '../models/schedule.dart';
import '../theme/app_theme.dart';

void showScheduleDetail(
  BuildContext context,
  Schedule schedule, {
  required VoidCallback onDelete,
  required VoidCallback onEdit,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 30),
        decoration: const BoxDecoration(
          color: OnTimeColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: OnTimeColors.background,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      schedule.icon,
                      color: OnTimeColors.primary,
                      size: 25,
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Text(
                      schedule.title,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: OnTimeColors.darkBrown,
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      onEdit();
                    },
                    icon: const Icon(
                      Icons.edit_outlined,
                      color: OnTimeColors.darkBrown,
                    ),
                    tooltip: '일정 수정',
                  ),

                  IconButton(
                    onPressed: () async {
                      final shouldDelete = await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) {
                          return AlertDialog(
                            backgroundColor: OnTimeColors.card,
                            title: const Text(
                              '일정 삭제',
                              style: TextStyle(
                                color: OnTimeColors.darkBrown,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            content: Text(
                              '"${schedule.title}" 일정을 삭제하시겠습니까?',
                              style: const TextStyle(
                                color: OnTimeColors.darkBrown,
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, false);
                                },
                                child: const Text(
                                  '취소',
                                  style: TextStyle(
                                    color: OnTimeColors.secondaryText,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(dialogContext, true);
                                },
                                child: const Text(
                                  '삭제',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (shouldDelete == true) {
                        onDelete();
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    tooltip: '일정 삭제',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              DetailRow(
                icon: Icons.calendar_today_outlined,
                title: '일정 날짜',
                value:
                    '${schedule.date.year}년 ${schedule.date.month}월 ${schedule.date.day}일',
              ),

              DetailRow(
                icon: Icons.location_on_outlined,
                title: '장소',
                value: schedule.location,
              ),

              DetailRow(
                icon: Icons.schedule,
                title: '수업 시작시간',
                value: schedule.startTime,
              ),

              DetailRow(
                icon: Icons.directions_walk_outlined,
                title: '이동시간',
                value: '${schedule.travelMinutes}분',
              ),

              DetailRow(
                icon: Icons.more_time,
                title: '여유시간',
                value: '${schedule.bufferMinutes}분',
              ),

              DetailRow(
                icon: Icons.directions_car_outlined,
                title: '출발시간',
                value: schedule.departureTime,
              ),

              DetailRow(
                icon: Icons.notes_outlined,
                title: '메모',
                value: schedule.memo.isEmpty ? '메모 없음' : schedule.memo,
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
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
                  child: const Text('닫기'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// ============================================================
// 상세 정보 한 줄
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
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: OnTimeColors.primary),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: OnTimeColors.darkBrown,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
