import 'package:permission_handler/permission_handler.dart';

Future<bool> contactPerms() async {
  final status = await Permission.contacts.status;
  if (!status.isGranted) {
    PermissionStatus perm = await Permission.contacts.request();
    return (perm.isGranted);
  }
  return true;
}

Future<bool> locationPerms() async {
  final status = await Permission.location.status;
  if (!status.isGranted) {
    PermissionStatus perm = await Permission.location.request();
    return (perm.isGranted);
  }
  return true;
}
