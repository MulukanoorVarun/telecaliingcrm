import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';

class PermissionManager {
  /// Checks and requests permissions for Android and iOS, returning true if all are granted.
  static Future<bool> checkPermissions(
      BuildContext context, {
        required Function(bool) onPermissionStatusChanged,
        bool showBottomSheet = true,
      }) async {
    try {
      // Get platform-specific permissions
      final permissions = await _getRequiredPermissions();

      // Check if all permissions are already granted
      final initialStatuses = await Future.wait(permissions.map((p) => p.status));
      if (initialStatuses.every((status) => status.isGranted)) {
        onPermissionStatusChanged(true);
        return true;
      }

      // Show rationale bottom sheet if needed
      if (showBottomSheet && context.mounted) {
        final shouldShowRationale = await _shouldShowRationale(permissions);
        if (shouldShowRationale && context.mounted) {
          final proceed = await _showPermissionRationaleBottomSheet(context);
          if (!proceed) {
            onPermissionStatusChanged(false);
            return false;
          }
        }
      }

      // Request permissions
      final statuses = await permissions.request();

      // Check if all permissions are granted
      final allGranted = statuses.values.every((status) => status.isGranted);
      onPermissionStatusChanged(allGranted);

      // Handle denied or permanently denied permissions
      if (!allGranted && context.mounted && showBottomSheet) {
        await _handleDeniedPermissions(context, statuses);
      }

      return allGranted;
    } catch (e) {
      debugPrint('Error checking permissions: $e');
      onPermissionStatusChanged(false);
      return false;
    }
  }

  /// Returns the list of required permissions based on platform and version.
  static Future<List<Permission>> _getRequiredPermissions() async {
    final permissions = <Permission>[];

    if (Platform.isAndroid) {
      // Android-specific permissions
      permissions.addAll([
        Permission.phone, // For reading phone state
        Permission.contacts, // For accessing contacts
        Permission.ignoreBatteryOptimizations, // To prevent battery optimization restrictions
      ]);
    } else if (Platform.isIOS) {
      // iOS-specific permissions
      permissions.addAll([
        Permission.contacts, // For accessing contacts
        // Note: phone, callLog, and ignoreBatteryOptimizations are not supported on iOS
      ]);
    }

    return permissions;
  }

  /// Checks the status of required permissions without requesting them.
  static Future<Map<Permission, PermissionStatus>> checkPermissionStatuses() async {
    try {
      final permissions = await _getRequiredPermissions();
      final statuses = <Permission, PermissionStatus>{};
      for (var permission in permissions) {
        statuses[permission] = await permission.status;
      }
      return statuses;
    } catch (e) {
      debugPrint('Error checking permission statuses: $e');
      return {};
    }
  }

  /// Checks if any permission requires a rationale.
  static Future<bool> _shouldShowRationale(List<Permission> permissions) async {
    if (Platform.isIOS) return false; // iOS handles rationale via Info.plist
    final shouldShow = await Future.wait(
      permissions.map((p) async => await p.shouldShowRequestRationale),
    );
    return shouldShow.any((show) => show);
  }

  /// Shows a permission rationale bottom sheet.
  static Future<bool> _showPermissionRationaleBottomSheet(
      BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => _PermissionBottomSheet(
        title: 'Permissions Needed',
        message:
        'This app needs access to your location, camera, notifications, and photos to work properly. Please allow these permissions to continue.',
        icon: Icons.lock_open,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(
              'Deny',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Allow',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ) ??
        false;
  }

  /// Handles denied or permanently denied permissions.
  static Future<void> _handleDeniedPermissions(
      BuildContext context, Map<Permission, PermissionStatus> statuses) async {
    final deniedPermissions = statuses.entries
        .where((entry) => entry.value.isDenied)
        .map((entry) => entry.key)
        .toList();

    final permanentlyDeniedPermissions = statuses.entries
        .where((entry) => entry.value.isPermanentlyDenied)
        .map((entry) => entry.key)
        .toList();

    if (permanentlyDeniedPermissions.isNotEmpty && context.mounted) {
      await _showPermanentlyDeniedBottomSheet(context, permanentlyDeniedPermissions);
    } else if (deniedPermissions.isNotEmpty && context.mounted) {
      await _showPermissionDeniedBottomSheet(context, deniedPermissions);
    }
  }

  /// Shows a bottom sheet for denied permissions with retry option.
  static Future<void> _showPermissionDeniedBottomSheet(
      BuildContext context, List<Permission> deniedPermissions) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => _PermissionBottomSheet(
        title: 'Permissions Required',
        message:
        'Please grant the following permissions to continue: ${_formatPermissions(deniedPermissions)}.',
        icon: Icons.warning_amber,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              checkPermissions(
                context,
                onPermissionStatusChanged: (granted) {},
                showBottomSheet: false, // Prevent recursive bottom sheets
              );
            },
            child: const Text(
              'Retry',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Shows a bottom sheet for permanently denied permissions, directing to settings.
  static Future<void> _showPermanentlyDeniedBottomSheet(
      BuildContext context, List<Permission> permissions) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => _PermissionBottomSheet(
        title: 'Permissions Denied',
        message:
        'The following permissions are permanently denied: ${_formatPermissions(permissions)}. Please enable them in your device settings.',
        icon: Icons.settings,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await openAppSettings();
            },
            child: const Text(
              'Open Settings',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Formats permissions into a user-friendly string.
  static String _formatPermissions(List<Permission> permissions) {
    return permissions
        .map((p) => _permissionToString(p))
        .toSet()
        .join(', ');
  }

  /// Converts permission to a user-friendly string.
  static String _permissionToString(Permission permission) {
    final name = permission.toString().split('.').last;
    final formatted = name.replaceAllMapped(
      RegExp(r'(?<=[a-z])([A-Z])'),
          (match) => ' ${match.group(1)}',
    );
    return formatted[0].toUpperCase() + formatted.substring(1).toLowerCase();
  }
}

/// A reusable bottom sheet widget for permission dialogs.
class _PermissionBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final List<Widget> actions;

  const _PermissionBottomSheet({
    required this.title,
    required this.message,
    required this.icon,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      padding: MediaQuery.of(context).viewInsets,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: SingleChildScrollView(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}