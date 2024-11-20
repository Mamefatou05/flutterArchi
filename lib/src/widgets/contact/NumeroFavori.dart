import 'package:flutter/material.dart';

import '../../models/NumeroFavori.dart';


class NumeroFavoriWidget extends StatelessWidget {
  final List<NumeroFavori> numerosFavoris;

  const NumeroFavoriWidget({
    super.key,
    required this.numerosFavoris,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: numerosFavoris.length,
        itemBuilder: (context, index) {
          final numeroFavori = numerosFavoris[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Center(
                    child: Text(
                      numeroFavori.numeroTelephone.substring(0, 2),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  numeroFavori.nom ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}