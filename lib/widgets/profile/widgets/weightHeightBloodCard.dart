import 'package:flutter/material.dart';
import 'package:calendar_dashboard/widgets/custom_card.dart';

class WeightHeightBloodCard extends StatelessWidget {
  WeightHeightBloodCard({
    super.key,
    this.key1 = 'Weight',
    this.value1 = '53 kg',
    this.key2 = 'Height',
    this.value2 = "163 cm",
    this.key3 = "Blood Type",
    this.value3 = "O+",
  });

  String key1;
  String value1;
  String key2;
  String value2;
  String key3;
  String value3;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      color: const Color(0xFF2F353E),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          details(key1, value1),
          details(key2, value2),
          details(key3, value3),
        ],
      ),
    );
  }

  Widget details(String key, String value) {
    return Column(
      children: [
        Text(
          key,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
