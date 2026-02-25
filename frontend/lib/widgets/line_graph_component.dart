import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LineGraphComponent extends StatefulWidget {
  final List<double> dataPoints;
  final List<String> labels;
  final double maxY;
  final Color themeColor;

  const LineGraphComponent({
    super.key,
    required this.dataPoints,
    required this.labels,
    this.maxY =
        200, // Adjusted to match the higher values in reference image (like 188)
    this.themeColor = const Color(0xFFFF6B6B),
  });

  @override
  State<LineGraphComponent> createState() => _LineGraphComponentState();
}

class _LineGraphComponentState extends State<LineGraphComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 180,
          width: double.infinity,
          child: CustomPaint(
            painter: _LineGraphPainter(
              dataPoints: widget.dataPoints,
              maxY: widget.maxY,
              themeColor: widget.themeColor,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widget.labels
              .map(
                (label) => Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.grey.shade400,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _LineGraphPainter extends CustomPainter {
  final List<double> dataPoints;
  final double maxY;
  final Color themeColor;

  _LineGraphPainter({
    required this.dataPoints,
    required this.maxY,
    required this.themeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;

    final double paddingLeft = 35.0;
    final double paddingBottom = 0.0;
    final double chartWidth = size.width - paddingLeft;
    final double chartHeight = size.height - paddingBottom;

    final Paint gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.12)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final Paint linePaint = Paint()
      ..color = themeColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [themeColor.withValues(alpha: 0.12), themeColor.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(paddingLeft, 0, chartWidth, chartHeight));

    // 1. Draw Dashed Grid Lines (Horizontal and vertical matching the reference)
    // Ticks matching reference image: 0, 50, 188 (using 188 as maxY)
    final List<double> yTicks = [0, 50, maxY];
    for (var yVal in yTicks) {
      double yPos = chartHeight - (yVal / maxY * chartHeight);
      _drawDashedLine(
        canvas,
        Offset(paddingLeft, yPos),
        Offset(size.width, yPos),
        gridPaint,
        vertical: false,
      );
      _drawText(canvas, Offset(0, yPos - 7), yVal.toInt().toString());
    }

    // 2. Prepare Paths
    if (dataPoints.length < 2) {
      if (dataPoints.isNotEmpty) {
        // Draw a single point if needed
        double x = paddingLeft;
        double y = chartHeight - (dataPoints[0] / maxY * chartHeight);
        canvas.drawCircle(Offset(x, y), 5, Paint()..color = themeColor);
      }
      return;
    }

    double xStep = chartWidth / (dataPoints.length - 1);

    // Vertical dashed lines
    for (int i = 0; i < dataPoints.length; i++) {
      double xPos = paddingLeft + (i * xStep);
      _drawDashedLine(
        canvas,
        Offset(xPos, 0),
        Offset(xPos, chartHeight),
        gridPaint,
        vertical: true,
      );
    }

    final Path path = Path();
    final Path fillPath = Path();

    double startX = paddingLeft;
    double startY = chartHeight - (dataPoints[0] / maxY * chartHeight);

    path.moveTo(startX, startY);
    fillPath.moveTo(startX, chartHeight);
    fillPath.lineTo(startX, startY);

    for (int i = 1; i < dataPoints.length; i++) {
      double x = paddingLeft + (i * xStep);
      double y = chartHeight - (dataPoints[i] / maxY * chartHeight);

      double prevX = paddingLeft + ((i - 1) * xStep);
      double prevY = chartHeight - (dataPoints[i - 1] / maxY * chartHeight);

      path.cubicTo(
        prevX + (x - prevX) / 2,
        prevY,
        prevX + (x - prevX) / 2,
        y,
        x,
        y,
      );
      fillPath.cubicTo(
        prevX + (x - prevX) / 2,
        prevY,
        prevX + (x - prevX) / 2,
        y,
        x,
        y,
      );
    }

    fillPath.lineTo(size.width, chartHeight);
    fillPath.lineTo(paddingLeft, chartHeight);
    fillPath.close();

    // 3. Draw Paths
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, linePaint);

    // 4. Draw Dots
    final Paint dotPaint = Paint()..color = themeColor;
    final Paint innerDotPaint = Paint()..color = Colors.white;

    for (int i = 0; i < dataPoints.length; i++) {
      double x = paddingLeft + (i * xStep);
      double y = chartHeight - (dataPoints[i] / maxY * chartHeight);
      canvas.drawCircle(Offset(x, y), 5, dotPaint);
      canvas.drawCircle(Offset(x, y), 2.5, innerDotPaint);
    }

    // 5. Special Blue Dot (outside the line, mimicking the reference image)
    double specialX = paddingLeft;
    double specialY = chartHeight - (105 / maxY * chartHeight);
    canvas.drawCircle(
      Offset(specialX, specialY),
      6,
      Paint()..color = const Color(0xFF0D3B66),
    );
    canvas.drawCircle(
      Offset(specialX, specialY),
      3.5,
      Paint()..color = Colors.white,
    );
  }

  void _drawDashedLine(
    Canvas canvas,
    Offset p1,
    Offset p2,
    Paint paint, {
    bool vertical = false,
  }) {
    double dashWidth = 3, dashSpace = 4, distance = 0;
    double dx = p2.dx - p1.dx;
    double dy = p2.dy - p1.dy;
    double totalDistance = (p2 - p1).distance;
    if (totalDistance == 0) return;
    double x = p1.dx, y = p1.dy;

    while (distance < totalDistance) {
      canvas.drawLine(
        Offset(x, y),
        Offset(
          x + dx / totalDistance * dashWidth,
          y + dy / totalDistance * dashWidth,
        ),
        paint,
      );
      x += dx / totalDistance * (dashWidth + dashSpace);
      y += dy / totalDistance * (dashWidth + dashSpace);
      distance += dashWidth + dashSpace;
    }
  }

  void _drawText(Canvas canvas, Offset offset, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.inter(
          color: Colors.grey.shade400,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
