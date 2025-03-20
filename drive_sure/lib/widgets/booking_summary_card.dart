import 'package:flutter/material.dart';

class BookingSummaryCard extends StatelessWidget {
  final double basePrice;
  final double insurancePrice;
  final double gpsPrice;
  final double childSeatPrice;
  final double totalPrice;
  final int totalDays;

  const BookingSummaryCard({
    Key? key,
    required this.basePrice,
    required this.insurancePrice,
    required this.gpsPrice,
    required this.childSeatPrice,
    required this.totalPrice,
    required this.totalDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _buildSummaryRow(
            'Base Price',
            '\$${basePrice.toStringAsFixed(2)}',
            subtitle: '$totalDays days @ \$${(basePrice / totalDays).toStringAsFixed(2)}/day',
          ),
          if (insurancePrice > 0) ...[
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Insurance',
              '\$${insurancePrice.toStringAsFixed(2)}',
              subtitle: '$totalDays days @ \$25/day',
            ),
          ],
          if (gpsPrice > 0) ...[
            const SizedBox(height: 12),
            _buildSummaryRow(
              'GPS Navigation',
              '\$${gpsPrice.toStringAsFixed(2)}',
              subtitle: '$totalDays days @ \$10/day',
            ),
          ],
          if (childSeatPrice > 0) ...[
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Child Seat',
              '\$${childSeatPrice.toStringAsFixed(2)}',
              subtitle: '$totalDays days @ \$15/day',
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          _buildSummaryRow(
            'Total',
            '\$${totalPrice.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, {String? subtitle, bool isTotal = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                fontSize: isTotal ? 18 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }
}