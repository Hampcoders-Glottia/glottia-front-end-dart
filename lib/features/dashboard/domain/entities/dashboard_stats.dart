class DashboardStats {
  final double hoursPracticed;
  final int eventsAttended;
  final int streakDays; // Días seguidos practicando

  const DashboardStats({
    required this.hoursPracticed,
    required this.eventsAttended,
    required this.streakDays,
  });
}