import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings _androidInitializationSettings =
      AndroidInitializationSettings('ic_launcher');

  void initializationNotification() async {
    InitializationSettings initializationSetting =
        InitializationSettings(android: _androidInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(initializationSetting);
  }

  void secheduleNotification(
      String numberTaskToday, String numberWillLate) async {
    AndroidNotificationDetails _android = const AndroidNotificationDetails(
        'id', 'name',
        importance: Importance.max, priority: Priority.high);

    NotificationDetails notiDetail = NotificationDetails(android: _android);

    await _flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Thông báo',
      'Hôm nay bạn có $numberTaskToday việc\n $numberWillLate việc sắp hết hạn ',
      RepeatInterval.daily,
      notiDetail,
    );
  }

  void sendNotification(String numberTaskToday, String numberWillLate) async {
    AndroidNotificationDetails _android = const AndroidNotificationDetails(
        'id', 'name',
        importance: Importance.max, priority: Priority.high);

    NotificationDetails notiDetail = NotificationDetails(android: _android);

    await _flutterLocalNotificationsPlugin.show(
      0,
      'Thông báo',
      'Hôm nay có $numberTaskToday việc.\n $numberWillLate việc sắp hết hạn trong 3 ngày',
      notiDetail,
    );
  }

  void stopNotification() async {
    _flutterLocalNotificationsPlugin.cancelAll();
  }
}
