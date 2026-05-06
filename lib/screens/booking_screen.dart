import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_screen.dart';
import '../services/booking_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingService _bookingService = BookingService();
  final List<String> _cities = const [
    'Kabul',
    'Herat',
    'Mazar-i-Sharif',
    'Kandahar',
    'Bamyan',
    'Jalalabad',
  ];

  final List<Map<String, dynamic>> _vehicles = const [
    {
      'name': 'Express Bus',
      'driver': 'Ahmad K.',
      'rating': 4.8,
      'seats': 12,
      'duration': '8h',
      'price': 1200,
      'icon': Icons.directions_bus_outlined,
    },
    {
      'name': 'Comfort Van',
      'driver': 'Farid M.',
      'rating': 4.9,
      'seats': 6,
      'duration': '7h',
      'price': 1800,
      'icon': Icons.local_shipping_outlined,
    },
    {
      'name': 'Private Car',
      'driver': 'Hassan R.',
      'rating': 4.7,
      'seats': 3,
      'duration': '6h',
      'price': 3500,
      'icon': Icons.directions_car_outlined,
    },
  ];

  final List<String> _seats = const [
    'A1',
    'A2',
    'A3',
    'A4',
    'B1',
    'B2',
    'B3',
    'B4',
    'C1',
    'C2',
    'C3',
    'C4',
    'D1',
    'D2',
    'D3',
    'D4',
    'E1',
    'E2',
    'E3',
    'E4',
    'E5',
  ];

  final Set<String> _taken = {'A2', 'B3', 'D4', 'E2', 'E3'};
  final Set<String> _selected = {};

  String _from = 'Kabul';
  String _to = 'Select destination';
  DateTime? _travelDate;
  int _passengers = 1;
  int _vehicleIndex = 1;

  int get _vehiclePrice => _vehicles[_vehicleIndex]['price'] as int;
  int get _estimatedPrice => _vehiclePrice * _selected.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 125),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 16),
              const Text(
                'Book a Trip',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w800),
              ),
              const Text(
                'Find the best route for your journey',
                style: TextStyle(fontSize: 22, color: Color(0xFF6B7280)),
              ),
              const SizedBox(height: 14),
              _bookingForm(),
              const SizedBox(height: 12),
              _aiSuggestion(),
              const SizedBox(height: 14),
              const Text(
                'Available Vehicles',
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),
              ...List.generate(
                _vehicles.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _vehicleTile(index),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Select Seats',
                style: TextStyle(fontSize: 33, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              _legend(),
              const SizedBox(height: 8),
              _seatGrid(),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Estimated Price',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 16),
                  ),
                  Text(
                    _selected.isEmpty ? '—' : 'AFN $_estimatedPrice',
                    style: const TextStyle(
                        color: Color(0xFF1D4ED8),
                        fontWeight: FontWeight.w700,
                        fontSize: 18),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selected.isEmpty ? null : _bookNow,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    backgroundColor: const Color(0xFF8DB0E8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Book Now',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text(
            'AT',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Transport',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                SizedBox(width: 2),
                Text('Kabul', style: TextStyle(color: Colors.grey)),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            )
          ],
        ),
        const Spacer(),
        Badge(
          backgroundColor: Colors.red,
          child: Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_none),
          ),
        ),
      ],
    );
  }

  Widget _bookingForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          _selectorTile(
            icon: Icons.my_location_outlined,
            label: 'FROM',
            value: _from,
            onTap: () => _pickCity(true),
          ),
          const SizedBox(height: 8),
          _selectorTile(
            icon: Icons.send_outlined,
            label: 'TO',
            value: _to,
            onTap: () => _pickCity(false),
            centerAction: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _swapRoute,
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.swap_vert, size: 18, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _datePicker(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _passengerPicker(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _selectorTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
    Widget? centerAction,
  }) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 17,
                  backgroundColor: const Color(0xFFDBEAFE),
                  child: Icon(icon, size: 18, color: const Color(0xFF3B82F6)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                              fontWeight: FontWeight.w600)),
                      Text(value,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
              ],
            ),
          ),
        ),
        if (centerAction != null) centerAction,
      ],
    );
  }

  Widget _datePicker() {
    final value = _travelDate == null
        ? 'mm/dd/yyyy'
        : '${_travelDate!.month}/${_travelDate!.day}/${_travelDate!.year}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('TRAVEL DATE',
            style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        InkWell(
          onTap: _pickDate,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 16, color: Color(0xFF6B7280)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(value,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                ),
                const Icon(Icons.calendar_today_outlined, size: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _passengerPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PASSENGERS',
            style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _counterButton(
                icon: Icons.remove,
                enabled: _passengers > 1,
                onTap: () => setState(() {
                  _passengers--;
                  if (_selected.length > _passengers) {
                    _selected.remove(_selected.last);
                  }
                }),
              ),
              Expanded(
                child: Text(
                  '$_passengers',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
              _counterButton(
                icon: Icons.add,
                enabled: _passengers < 5,
                onTap: () => setState(() => _passengers++),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _counterButton({
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: CircleAvatar(
        radius: 13,
        backgroundColor:
            enabled ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }

  Widget _aiSuggestion() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 16, color: Color(0xFF2563EB)),
              SizedBox(width: 8),
              Text('AI Suggested',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              Spacer(),
              _BestMatch(),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Based on your travel history, we recommend the Comfort Van departing at 6:00 AM for the best price-comfort balance.',
            style: TextStyle(color: Color(0xFF374151), height: 1.3),
          ),
          SizedBox(height: 8),
          Text('⚡ Save 15% with early booking',
              style: TextStyle(color: Color(0xFFD97706), fontSize: 12)),
        ],
      ),
    );
  }

  Widget _vehicleTile(int index) {
    final item = _vehicles[index];
    final selected = _vehicleIndex == index;
    return InkWell(
      onTap: () => setState(() {
        _vehicleIndex = index;
        _selected.clear();
      }),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
              width: selected ? 1.4 : 1),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFDBEAFE),
              child: Icon(item['icon'] as IconData, color: const Color(0xFF2563EB)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'] as String,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(item['driver'] as String,
                          style: const TextStyle(color: Color(0xFF6B7280))),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 2),
                      Text('${item['rating']}'),
                      const SizedBox(width: 8),
                      const Icon(Icons.person_outline,
                          size: 14, color: Color(0xFF6B7280)),
                      const SizedBox(width: 2),
                      Text('${item['seats']}',
                          style: const TextStyle(color: Color(0xFF6B7280))),
                      const SizedBox(width: 8),
                      const Icon(Icons.schedule,
                          size: 14, color: Color(0xFF6B7280)),
                      const SizedBox(width: 2),
                      Text('${item['duration']}',
                          style: const TextStyle(color: Color(0xFF6B7280))),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              'AFN ${item['price']}',
              style: const TextStyle(
                  color: Color(0xFF2563EB),
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LegendBox(color: Color(0xFFF1F5F9), label: 'Available'),
        SizedBox(width: 16),
        _LegendBox(color: Color(0xFF3B82F6), label: 'Selected'),
        SizedBox(width: 16),
        _LegendBox(color: Color(0xFFE2E8F0), label: 'Taken'),
      ],
    );
  }

  Widget _seatGrid() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFFE5E7EB),
              child: Icon(Icons.directions_car, size: 13, color: Colors.grey.shade700),
            ),
          ),
          GridView.builder(
            itemCount: _seats.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 10,
              childAspectRatio: 1.12,
            ),
            itemBuilder: (_, index) {
              final seat = _seats[index];
              final isTaken = _taken.contains(seat);
              final isSelected = _selected.contains(seat);
              final bg = isTaken
                  ? const Color(0xFFE2E8F0)
                  : isSelected
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFFF1F5F9);
              final color = isSelected
                  ? Colors.white
                  : isTaken
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A);
              return GestureDetector(
                onTap: isTaken ? null : () => _toggleSeat(seat),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Text(
                    seat,
                    style: TextStyle(fontWeight: FontWeight.w700, color: color),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickCity(bool isFrom) async {
    final city = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: _cities
              .map((e) => ListTile(
                    title: Text(e),
                    onTap: () => Navigator.pop(context, e),
                  ))
              .toList(),
        ),
      ),
    );
    if (city == null) return;
    setState(() {
      if (isFrom) {
        _from = city;
      } else {
        _to = city;
      }
    });
  }

  void _swapRoute() {
    if (_to == 'Select destination') return;
    setState(() {
      final temp = _from;
      _from = _to;
      _to = temp;
    });
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() => _travelDate = date);
    }
  }

  void _toggleSeat(String seat) {
    setState(() {
      if (_selected.contains(seat)) {
        _selected.remove(seat);
      } else {
        if (_selected.length >= _passengers) return;
        _selected.add(seat);
      }
    });
  }

  Future<void> _bookNow() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _showBlueSnack('Please login first to book a ticket');
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
      });
      return;
    }

    if (_to == 'Select destination') {
      _showBlueSnack('Please select destination');
      return;
    }
    if (_travelDate == null) {
      _showBlueSnack('Please select travel date');
      return;
    }
    if (_selected.length != _passengers) {
      _showBlueSnack('Select exactly $_passengers seat(s)');
      return;
    }

    final vehicleName = _vehicles[_vehicleIndex]['name'];
    try {
      await _bookingService.createBooking(
        from: _from,
        to: _to,
        travelDate: _travelDate!,
        vehicleName: vehicleName.toString(),
        passengers: _passengers,
        seats: _selected.toList(),
        price: _estimatedPrice,
      );
      _showBlueSnack(
        'Booked $vehicleName from $_from to $_to for AFN $_estimatedPrice',
      );
      setState(() {
        _selected.clear();
      });
    } catch (e) {
      _showBlueSnack('Booking failed: $e');
    }
  }

  void _showBlueSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2563EB),
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _LegendBox extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendBox({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Color(0xFF64748B))),
      ],
    );
  }
}

class _BestMatch extends StatelessWidget {
  const _BestMatch();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Best Match',
        style: TextStyle(
          color: Color(0xFF16A34A),
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
