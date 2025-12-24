import 'package:extro/core/extensions/context_extensions.dart';
import 'package:extro/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class WeeklySpendingChart extends StatelessWidget {
  final String totalAmount;
  final String percentageChange;
  final bool isPositiveChange;
  final List<double> spendingData;

  const WeeklySpendingChart({
    super.key,
    required this.totalAmount,
    required this.percentageChange,
    this.isPositiveChange = false,
    required this.spendingData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.slate200),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.localizer.weeklySpending,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.textDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    context.localizer.lastSevenDays,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: AppColors.slate500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    totalAmount,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$percentageChange ${context.localizer.vsLastWeek}',
                    style: context.textTheme.labelSmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(
                data: spendingData,
                lineColor: AppColors.primary,
                gradientColor: AppColors.primary.withValues(alpha: 0.2),
              ),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _DayLabel(label: 'Mon'),
              _DayLabel(label: 'Tue'),
              _DayLabel(label: 'Wed'),
              _DayLabel(label: 'Thu'),
              _DayLabel(label: 'Fri'),
              _DayLabel(label: 'Sat'),
              _DayLabel(label: 'Sun'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String label;

  const _DayLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: context.textTheme.labelSmall?.copyWith(
        color: AppColors.slate400,
        fontWeight: FontWeight.w500,
        fontSize: 10,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> data;
  final Color lineColor;
  final Color gradientColor;

  _LineChartPainter({
    required this.data,
    required this.lineColor,
    required this.gradientColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;

    final points = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedValue = range == 0 ? 0.5 : (data[i] - minValue) / range;
      final y =
          size.height -
          (normalizedValue * size.height * 0.8) -
          (size.height * 0.1);
      points.add(Offset(x, y));
    }

    final gradientPath = Path();
    gradientPath.moveTo(0, size.height);
    gradientPath.lineTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      gradientPath.lineTo(points[i].dx, points[i].dy);
    }

    gradientPath.lineTo(size.width, size.height);
    gradientPath.close();

    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [gradientColor, gradientColor.withValues(alpha: 0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(gradientPath, gradientPaint);

    final linePath = Path();
    linePath.moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }

    final linePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
