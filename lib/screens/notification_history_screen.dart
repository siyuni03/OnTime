import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class NotificationHistoryScreen extends StatelessWidget {
  const NotificationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnTimeColors.background,
      appBar: AppBar(
        title: const Text(
          '알림 기록',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none_outlined,
              size: 64,
              color: OnTimeColors.primary,
            ),
            const SizedBox(height: 16),
            const Text(
              '알림 기록이 없습니다.',
              style: TextStyle(
                fontSize: 16,
                color: OnTimeColors.darkBrown,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
