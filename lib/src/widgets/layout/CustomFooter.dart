import 'package:flutter/material.dart';

import '../../routes/HistoryRoute.dart';
import '../../routes/HomeRoute.dart';
import '../../routes/QRRoute.dart';

class CustomFooter extends StatelessWidget {
  final String currentRoute;

  const CustomFooter({
    Key? key,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              context,
              HomeRoute.home,
              Icons.home,
              'Accueil',
            ),
            _buildNavItem(
              context,
              QRRoute.qr,
              Icons.qr_code_scanner,
              'QR',
            ),
            _buildNavItem(
              context,
              HistoryRoute.history,
              Icons.history,
              'Historique',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context,
      String route,
      IconData icon,
      String label,
      ) {
    final isSelected = currentRoute == route;
    return InkWell(
      onTap: () {
        if (currentRoute != route) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
          color: const Color(0xFF8B5CF6).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? const Color(0xFF8B5CF6) : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
