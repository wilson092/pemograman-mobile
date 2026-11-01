import 'package:flutter/material.dart';
import 'package:pemob/project/app/core/theme/app_colors.dart';
import 'package:pemob/project/app/core/theme/app_text_styles.dart';
import 'package:pemob/project/app/data/models/weather_rule.dart';

class RiskSegmented extends StatelessWidget {
  final RiskLevel activeLevel;

  const RiskSegmented({
    super.key,
    required this.activeLevel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSegment(
                label: 'Rendah',
                level: RiskLevel.rendah,
                bgColor: AppColors.riskLowBg,
                textColor: AppColors.riskLow,
                isLeft: true,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildSegment(
                label: 'Sedang',
                level: RiskLevel.sedang,
                bgColor: AppColors.riskMediumBg,
                textColor: AppColors.riskMedium,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: _buildSegment(
                label: 'Tinggi',
                level: RiskLevel.tinggi,
                bgColor: AppColors.riskHighBg,
                textColor: AppColors.riskHigh,
                isRight: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            Expanded(
              child: Center(
                child: activeLevel == RiskLevel.rendah
                    ? const _TriangleIndicator()
                    : const SizedBox(height: 6),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Center(
                child: activeLevel == RiskLevel.sedang
                    ? const _TriangleIndicator()
                    : const SizedBox(height: 6),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Center(
                child: activeLevel == RiskLevel.tinggi
                    ? const _TriangleIndicator()
                    : const SizedBox(height: 6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSegment({
    required String label,
    required RiskLevel level,
    required Color bgColor,
    required Color textColor,
    bool isLeft = false,
    bool isRight = false,
  }) {
    final isActive = activeLevel == level;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isLeft ? 8 : 4),
          bottomLeft: Radius.circular(isLeft ? 8 : 4),
          topRight: Radius.circular(isRight ? 8 : 4),
          bottomRight: Radius.circular(isRight ? 8 : 4),
        ),
        border: isActive
            ? Border.all(color: textColor, width: 1.5)
            : Border.all(color: Colors.transparent, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: AppTextStyles.bodyStrong.copyWith(
          color: textColor,
          fontSize: 12,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }
}

class _TriangleIndicator extends StatelessWidget {
  const _TriangleIndicator();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(10, 6),
      painter: _TrianglePainter(color: AppColors.primary),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
