import 'package:flutter/material.dart';

import '../models/schedule.dart';
import '../theme/app_theme.dart';

// ============================================================
// 목록형 일정 카드
// ============================================================

class ListScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onTap;

  const ListScheduleCard({
    super.key,
    required this.schedule,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final departureTime =
        '${schedule.departureAt.hour.toString().padLeft(2, '0')}:'
        '${schedule.departureAt.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: OnTimeColors.border,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 15,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      schedule.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: OnTimeColors.darkBrown,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      schedule.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 38,
                color: OnTimeColors.border,
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    '출발',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    departureTime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: OnTimeColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// 아이콘형 일정 카드
// ============================================================
class GridScheduleCard extends StatelessWidget {
  final Schedule schedule;
  final VoidCallback onTap;

  const GridScheduleCard({
    super.key,
    required this.schedule,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final departureTime =
        '${schedule.departureAt.hour.toString().padLeft(2, '0')}:'
        '${schedule.departureAt.minute.toString().padLeft(2, '0')}';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: OnTimeColors.border,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: OnTimeColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.event_outlined,
                  color: OnTimeColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                schedule.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: OnTimeColors.darkBrown,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                schedule.location,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.grey.shade500,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Icon(
                    Icons.departure_board_outlined,
                    size: 15,
                    color: OnTimeColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    departureTime,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: OnTimeColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}