import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TimeNewsPanel extends StatelessWidget {
  final String currentTime;
  final String dateText;

  const TimeNewsPanel({
    super.key,
    required this.currentTime,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 158,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: OnTimeColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 왼쪽 - 현재 시간
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '현재 시간',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 5),

                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentTime,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: OnTimeColors.darkBrown,
                      ),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    dateText,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: 1,
            height: 100,
            color: OnTimeColors.border,
          ),

          // 오른쪽 - 뉴스
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                18,
                18,
                18,
                18,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.newspaper_outlined,
                        size: 18,
                        color: OnTimeColors.primary,
                      ),

                      const SizedBox(width: 6),

                      const Text(
                        '오늘의 뉴스',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: OnTimeColors.darkBrown,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    '뉴스를 불러오는 공간입니다.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: OnTimeColors.darkBrown,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '뉴스 API 연동 예정',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}