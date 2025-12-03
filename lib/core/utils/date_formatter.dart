class DateFormatter {
  /// Formatea una fecha para mostrarla de manera relativa (Hoy, Ayer, hace X días, etc)
  static String formatRelativeDate(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final difference = today.difference(date).inDays;

    if (date == today) {
      return 'Hoy';
    } else if (date == yesterday) {
      return 'Ayer';
    } else if (difference < 7) {
      return 'Hace $difference días';
    } else if (difference < 14) {
      return 'Hace 1 semana';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return 'Hace $weeks semanas';
    } else if (difference < 60) {
      return 'Hace 1 mes';
    } else {
      final months = (difference / 30).floor();
      return 'Hace $months meses';
    }
  }
}

