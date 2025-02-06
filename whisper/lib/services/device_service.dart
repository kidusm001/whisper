import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../data/models/user_model.dart';
import 'package:http/http.dart' as http;

class DeviceService {
  Future<DeviceInfo> getDeviceInfo() async {
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    final packageInfo = await PackageInfo.fromPlatform();
    final data = deviceInfo.data;

    return DeviceInfo(
      deviceId: '${data['id']}-${data['model']}-${packageInfo.buildNumber}',
      model: data['model'] ?? 'Unknown',
      os: '${data['operatingSystem']} ${data['osVersion']}',
      ipAddress: await _getIpAddress(),
      firstSeen: DateTime.now(),
      lastActive: DateTime.now(),
      locationHash: 'TODO', // Implement geohashing
      isTrusted: false,
    );
  }

  Future<String> _getIpAddress() async {
    try {
      final response = await http.get(Uri.parse('https://api.ipify.org'));
      return response.body;
    } catch (e) {
      return '0.0.0.0';
    }
  }
}
