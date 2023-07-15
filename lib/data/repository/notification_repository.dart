import 'package:compare_product/data/interfaces/i_service_api.dart';
import 'package:compare_product/data/models/notification.dart' as noti;
import 'package:compare_product/data/network/base_api_service.dart';
import 'package:compare_product/data/network/network_api_service.dart';

class NotificationRepository extends IServiceAPI {
  String urlGetNotifications = 'http://192.168.1.79:8080/v1/noti';

  final BaseApiServices _apiServices = NetworkApiService();

  Future<List<noti.Notification>> getNotifications() async {
    try {
      final response = await _apiServices.get(
        urlGetNotifications,
        {
          "Accept": '*/*',
          'Content-Type': 'application/json',
        },
      );

      List<noti.Notification> notifications = [];

      for (var map in response) {
        noti.Notification notification = noti.Notification.fromMap(map);
        notifications.add(notification);
      }

      return notifications;
    } catch (e) {
      return [];
    }
  }

  @override
  convertToObject(value) {
    throw UnimplementedError();
  }
}
