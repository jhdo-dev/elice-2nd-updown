import 'package:flutter/material.dart';

class PushNotificationToggle extends StatefulWidget {
  const PushNotificationToggle({super.key});

  @override
  State<PushNotificationToggle> createState() => PushNotificationToggleState();
}

class PushNotificationToggleState extends State<PushNotificationToggle> {
  bool _pushNotificationToggle = true;

  void _togglePushNotifications(bool enable) {
    setState(() {
      _pushNotificationToggle = enable;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: _pushNotificationToggle,
      title: const Text('Push Notification'),
      subtitle: Text('Enabled: $_pushNotificationToggle'),
      trailing: Switch(
        onChanged: (bool? value) {
          _togglePushNotifications(value!);
        },
        value: _pushNotificationToggle,
      ),
    );
  }
}
