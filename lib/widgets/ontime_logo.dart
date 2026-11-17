import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
class OnTimeLogo extends StatelessWidget {
  final double size;

  const OnTimeLogo({
    super.key,
    this.size = 38,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: OnTimeColors.primary,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 시계 원
          Container(
            width: size * 0.58,
            height: size * 0.58,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: OnTimeColors.darkBrown,
                width: size * 0.045,
              ),
            ),
          ),

          // 시계 바늘
          Positioned(
            top: size * 0.22,
            child: Container(
              width: size * 0.045,
              height: size * 0.20,
              decoration: BoxDecoration(
                color: OnTimeColors.darkBrown,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          Positioned(
            right: size * 0.25,
            child: Container(
              width: size * 0.17,
              height: size * 0.045,
              decoration: BoxDecoration(
                color: OnTimeColors.darkBrown,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // 체크 표시
          Positioned(
            right: size * 0.08,
            bottom: size * 0.08,
            child: Container(
              width: size * 0.30,
              height: size * 0.30,
              decoration: const BoxDecoration(
                color: OnTimeColors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: size * 0.19,
              ),
            ),
          ),
        ],
      ),
    );
  }
}