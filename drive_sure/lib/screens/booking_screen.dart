import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/car.dart';
import '../widgets/booking_summary_card.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Car car;

  const BookingScreen({Key? key, required this.car}) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _includeInsurance = false;
  bool _includeGPS = false;
  bool _includeChildSeat = false;

  double get _totalDays {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays.toDouble();
  }

  double get _basePrice => widget.car.pricePerDay * _totalDays;

  double get _insurancePrice => _includeInsurance ? (25 * _totalDays) : 0;

  double get _gpsPrice => _includeGPS ? (10 * _totalDays) : 0;

  double get _childSeatPrice => _includeChildSeat ? (15 * _totalDays) : 0;

  double get _totalPrice =>
      _basePrice + _insurancePrice + _gpsPrice + _childSeatPrice;

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date first')),
      );
      return;
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate!.add(const Duration(days: 1)),
      firstDate: _startDate!.add(const Duration(days: 1)),
      lastDate: _startDate!.add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Your Car'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.car.images[0],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.car.name,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          widget.car.brand,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${widget.car.pricePerDay}/day',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Date Selection
            Text(
              'Select Dates',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectStartDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Start Date',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _startDate == null
                                ? 'Select Date'
                                : DateFormat('MMM dd, yyyy').format(_startDate!),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _selectEndDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'End Date',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _endDate == null
                                ? 'Select Date'
                                : DateFormat('MMM dd, yyyy').format(_endDate!),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Additional Services
            Text(
              'Additional Services',
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: _includeInsurance,
              onChanged: (value) => setState(() => _includeInsurance = value),
              title: const Text('Insurance Coverage'),
              subtitle: const Text('\$25/day'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SwitchListTile(
              value: _includeGPS,
              onChanged: (value) => setState(() => _includeGPS = value),
              title: const Text('GPS Navigation'),
              subtitle: const Text('\$10/day'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SwitchListTile(
              value: _includeChildSeat,
              onChanged: (value) => setState(() => _includeChildSeat = value),
              title: const Text('Child Seat'),
              subtitle: const Text('\$15/day'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),

            // Booking Summary
            if (_startDate != null && _endDate != null) ...[
              Text(
                'Booking Summary',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 16),
              BookingSummaryCard(
                basePrice: _basePrice,
                insurancePrice: _insurancePrice,
                gpsPrice: _gpsPrice,
                childSeatPrice: _childSeatPrice,
                totalPrice: _totalPrice,
                totalDays: _totalDays.toInt(),
              ),
            ],
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Amount',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _startDate == null || _endDate == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PaymentScreen(
                              car: widget.car,
                              startDate: _startDate!,
                              endDate: _endDate!,
                              totalAmount: _totalPrice,
                              includeInsurance: _includeInsurance,
                              includeGPS: _includeGPS,
                              includeChildSeat: _includeChildSeat,
                            ),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continue to Payment',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}