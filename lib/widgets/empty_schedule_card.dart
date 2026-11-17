import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class EmptyScheduleCard extends StatelessWidget {
  const EmptyScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: OnTimeColors.border,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_available_outlined,
            size: 38,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 10),
          Text(
            '등록된 일정이 없습니다.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}