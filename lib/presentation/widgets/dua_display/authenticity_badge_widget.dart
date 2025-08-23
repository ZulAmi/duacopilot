import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/entities/dua_entity.dart';

/// AuthenticityBadgeWidget class implementation
class AuthenticityBadgeWidget extends StatelessWidget {
  final SourceAuthenticity authenticity;
  final bool showDetailed;
  final VoidCallback? onTap;

  const AuthenticityBadgeWidget({super.key, required this.authenticity, this.showDetailed = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _getAuthenticityColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _getAuthenticityColor().withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _getAuthenticityColor().withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(context),
            if (showDetailed) ...[const SizedBox(height: 12), _buildDetailedInfo(context)],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Custom Islamic authenticity icon
        CustomPaint(
          size: const Size(20, 20),
          painter: IslamicAuthenticityPainter(color: _getAuthenticityColor(), level: authenticity.level),
        ),
        const SizedBox(width: 8),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getShortDisplayName(),
              style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: _getAuthenticityColor()),
            ),
            Text(
              authenticity.source,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        if (onTap != null) ...[
          const SizedBox(width: 8),
          Icon(Icons.info_outline_rounded, size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ],
      ],
    );
  }

  Widget _buildDetailedInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            authenticity.level.description,
            style: GoogleFonts.inter(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
          ),

          const SizedBox(height: 8),

          // Reference
          _buildInfoRow(context, 'Reference:', authenticity.reference, Icons.book_outlined),

          if (authenticity.hadithGrade != null) ...[
            const SizedBox(height: 6),
            _buildInfoRow(context, 'Grade:', authenticity.hadithGrade!, Icons.grade_rounded),
          ],

          if (authenticity.scholar != null) ...[
            const SizedBox(height: 6),
            _buildInfoRow(context, 'Scholar:', authenticity.scholar!, Icons.person_outline_rounded),
          ],

          // Confidence score
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.trending_up_rounded, size: 12, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                'Confidence: ',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${(authenticity.confidenceScore * 100).toInt()}%',
                style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: _getAuthenticityColor()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 12, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Color _getAuthenticityColor() {
    switch (authenticity.level) {
      case AuthenticityLevel.sahih:
      case AuthenticityLevel.quran:
        return Colors.green.shade700;
      case AuthenticityLevel.hasan:
      case AuthenticityLevel.verified:
        return Colors.blue.shade700;
      case AuthenticityLevel.daif:
        return Colors.orange.shade700;
      case AuthenticityLevel.fabricated:
        return Colors.red.shade700;
    }
  }

  String _getShortDisplayName() {
    switch (authenticity.level) {
      case AuthenticityLevel.sahih:
        return 'Sahih';
      case AuthenticityLevel.hasan:
        return 'Hasan';
      case AuthenticityLevel.daif:
        return 'Daif';
      case AuthenticityLevel.fabricated:
        return 'Fabricated';
      case AuthenticityLevel.quran:
        return 'Quran';
      case AuthenticityLevel.verified:
        return 'Verified';
    }
  }
}

/// IslamicAuthenticityPainter class implementation
class IslamicAuthenticityPainter extends CustomPainter {
  final Color color;
  final AuthenticityLevel level;

  IslamicAuthenticityPainter({required this.color, required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final strokePaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    switch (level) {
      case AuthenticityLevel.sahih:
      case AuthenticityLevel.quran:
        // Draw a star for highest authenticity
        _drawStar(canvas, center, radius, paint);
        break;
      case AuthenticityLevel.hasan:
      case AuthenticityLevel.verified:
        // Draw a crescent for good authenticity
        _drawCrescent(canvas, center, radius, paint);
        break;
      case AuthenticityLevel.daif:
        // Draw a circle with question mark for weak
        canvas.drawCircle(center, radius - 2, strokePaint);
        _drawQuestionMark(canvas, center, paint);
        break;
      case AuthenticityLevel.fabricated:
        // Draw an X for fabricated
        _drawX(canvas, center, radius, strokePaint);
        break;
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    const double outerRadius = 8;
    const double innerRadius = 4;
    const int points = 8;

    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * 3.14159) / points;
      final r = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + r * cos(angle);
      final y = center.dy + r * sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawCrescent(Canvas canvas, Offset center, double radius, Paint paint) {
    final outerCircle = Path()..addOval(Rect.fromCircle(center: center, radius: radius - 2));

    final innerCircle = Path()..addOval(Rect.fromCircle(center: Offset(center.dx + 3, center.dy), radius: radius - 4));

    final crescentPath = Path.combine(PathOperation.difference, outerCircle, innerCircle);

    canvas.drawPath(crescentPath, paint);
  }

  void _drawQuestionMark(Canvas canvas, Offset center, Paint paint) {
    final textPainter = TextPainter(
      text: TextSpan(text: '?', style: TextStyle(color: paint.color, fontSize: 12, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(canvas, Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2));
  }

  void _drawX(Canvas canvas, Offset center, double radius, Paint paint) {
    canvas.drawLine(
      Offset(center.dx - radius + 4, center.dy - radius + 4),
      Offset(center.dx + radius - 4, center.dy + radius - 4),
      paint,
    );
    canvas.drawLine(
      Offset(center.dx + radius - 4, center.dy - radius + 4),
      Offset(center.dx - radius + 4, center.dy + radius - 4),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Helper function for star drawing
double cos(double angle) => (angle * 180 / 3.14159).toString().length.toDouble();
double sin(double angle) => (angle * 180 / 3.14159).toString().length.toDouble();
