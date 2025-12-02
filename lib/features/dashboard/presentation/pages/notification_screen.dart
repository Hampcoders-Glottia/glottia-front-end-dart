import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Mock Data
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': 1,
      'title': '¡Clase confirmada!',
      'body': 'Tu reserva en Starbucks Larcomar para hoy a las 6:00 PM está lista.',
      'time': DateTime.now().subtract(const Duration(minutes: 30)),
      'type': 'success',
      'read': false,
    },
    {
      'id': 2,
      'title': 'Recordatorio',
      'body': 'Faltan 2 horas para tu clase de Inglés.',
      'time': DateTime.now().subtract(const Duration(hours: 2)),
      'type': 'info',
      'read': true,
    },
    {
      'id': 3,
      'title': 'Puntos Añadidos',
      'body': '¡Ganaste 50 puntos por tu Check-in ayer!',
      'time': DateTime.now().subtract(const Duration(days: 1)),
      'type': 'reward',
      'read': true,
    },
    {
      'id': 4,
      'title': 'Reserva Cancelada',
      'body': 'Lamentablemente, la sesión en Biblioteca Central fue cancelada por el organizador.',
      'time': DateTime.now().subtract(const Duration(days: 2)),
      'type': 'error',
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text("Notificaciones", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black87),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                for (var n in _notifications) {
                  n['read'] = true;
                }
              });
            },
            child: const Text("Marcar leídas", style: TextStyle(color: kPrimaryBlue)),
          )
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationItem(notification);
              },
            ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    IconData icon;
    Color color;

    switch (notification['type']) {
      case 'success':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'error':
        icon = Icons.cancel;
        color = Colors.red;
        break;
      case 'reward':
        icon = Icons.emoji_events;
        color = Colors.amber;
        break;
      default:
        icon = Icons.info;
        color = kPrimaryBlue;
    }

    return Dismissible(
      key: Key(notification['id'].toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        setState(() {
          _notifications.remove(notification);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Notificación eliminada"), duration: Duration(seconds: 1)),
        );
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.red),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: notification['read'] ? Colors.white : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontWeight: notification['read'] ? FontWeight.w600 : FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(notification['body'], style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 8),
              Text(
                _formatTime(notification['time']),
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              notification['read'] = true;
            });
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text("Sin notificaciones", style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return "Hace ${difference.inMinutes} min";
    } else if (difference.inHours < 24) {
      return "Hace ${difference.inHours} h";
    } else {
      return DateFormat('dd MMM', 'es_ES').format(time);
    }
  }
}