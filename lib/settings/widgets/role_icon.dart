import 'package:flutter/material.dart';
import 'package:worship_connect/wc_core/worship_connect_constants.dart';

class RoleIcon extends StatelessWidget {
  const RoleIcon({Key? key, required this.role}) : super(key: key);

  final UserStatusEnum role;

  static String _roleString = '';

  @override
  Widget build(BuildContext context) {
    switch (role) {
      case UserStatusEnum.admin:
        _roleString = 'Admin';
        break;
      case UserStatusEnum.leader:
        _roleString = 'Leader';
        break;
      default:
        _roleString = '';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: wcAccentColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          _roleString,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
