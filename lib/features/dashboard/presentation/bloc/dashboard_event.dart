abstract class DashboardEvent {}

class LoadDashboardData extends DashboardEvent {
  // Aquí podrías pasar el userId si fuera necesario, 
  // pero usualmente el repositorio lo saca del token guardado.
}