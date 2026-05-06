import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final List<String> _cities = const [
    'Kabul',
    'Herat',
    'Mazar-i-Sharif',
    'Kandahar',
    'Bamyan',
    'Jalalabad',
  ];
  final List<String> _seatCodes = const [
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
  final Set<String> _takenSeats = const {'A2', 'B3', 'D4', 'E2', 'E3'}.toSet();
  final Set<String> _selectedSeats = {};

  String _from = 'Kabul';
  String _to = 'Select destination';
  DateTime? _travelDate;
  int _passengers = 1;
  int _selectedVehicleIndex = 0;

  final List<Map<String, dynamic>> _vehicles = const [
    {
      'name': 'Express Bus',
      'driver': 'Ahmad K.',
      'rating': 4.8,
      'seats': 12,
      'duration': '8h',
      'price': 1200,
      'icon': Icons.directions_bus,
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

  int get _pricePerSeat => _vehicles[_selectedVehicleIndex]['price'] as int;
  int get _estimatedPrice => _pricePerSeat * _selectedSeats.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topBar(),
              const SizedBox(height: 16),
              const Text('Book a Trip',
                  style: TextStyle(fontSize: 37, fontWeight: FontWeight.w800)),
              const Text('Find the best route for your journey',
                  style: TextStyle(fontSize: 21, color: Color(0xFF6B7280))),
              const SizedBox(height: 14),
              _routeSection(),
              const SizedBox(height: 14),
              _aiSuggestedCard(),
              const SizedBox(height: 14),
              const Text('Available Vehicles',
                  style: TextStyle(fontSize: 31, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              ...List.generate(_vehicles.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _vehicleTile(index),
                );
              }),
              const SizedBox(height: 14),
              const Text('Select Seats',
                  style: TextStyle(fontSize: 31, fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _seatLegend(),
              const SizedBox(height: 10),
              _seatGrid(),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
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
                  const Text('Estimated Price',
                      style: TextStyle(fontSize: 16, color: Color(0xFF6B7280))),
                  Text(
                    _selectedSeats.isEmpty ? '—' : 'AFN $_estimatedPrice',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D4ED8)),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selectedSeats.isEmpty ? null : _bookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8DB0E8),
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Book Now',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const Text('AT',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
        ),
        const SizedBox(width: 10),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('AI Transport',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                SizedBox(width: 2),
                Text('Kabul', style: TextStyle(color: Colors.grey, fontSize: 14)),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              ],
            ),
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

  Widget _routeSection() {
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
            icon: Icons.my_location,
            label: 'FROM',
            value: _from,
            onTap: () => _pickCity(isFrom: true),
          ),
          const SizedBox(height: 8),
          _selectorTile(
            icon: Icons.send_outlined,
            label: 'TO',
            value: _to,
            onTap: () => _pickCity(isFrom: false),
            midAction: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: _swapCities,
                icon: const Icon(Icons.swap_vert, size: 18, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _miniPicker(
                  title: 'TRAVEL DATE',
                  content: _travelDate == null
                      ? 'mm/dd/yyyy'
                      : '${_travelDate!.month}/${_travelDate!.day}/${_travelDate!.year}',
                  icon: Icons.calendar_today_outlined,
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _passengersPicker(),
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
    Widget? midAction,
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
                  radius: 18,
                  backgroundColor: const Color(0xFFDBEAFE),
                  child: Icon(icon, color: const Color(0xFF3B82F6), size: 18),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                      Text(value,
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280)),
              ],
            ),
          ),
        ),
        if (midAction != null) midAction,
      ],
    );
  }

  Widget _miniPicker({
    required String title,
    required String content,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600)),
        const SizedBox(height: 5),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: const Color(0xFF6B7280)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(content,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                const Icon(Icons.calendar_today_outlined, size: 15),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _passengersPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('PASSENGERS',
            style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
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
              _counterBtn(
                  icon: Icons.remove,
                  onTap: _passengers > 1
                      ? () => setState(() => _passengers--)
                      : null),
              Expanded(
                child: Text('$_passengers',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              _counterBtn(
                  icon: Icons.add,
                  onTap: _passengers < 5
                      ? () => setState(() => _passengers++)
                      : null),
            ],
          ),
        ),
      ],
    );
  }

  Widget _counterBtn({required IconData icon, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 13,
        backgroundColor:
            onTap == null ? const Color(0xFFE5E7EB) : const Color(0xFF3B82F6),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }

  Widget _aiSuggestedCard() {
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
              _BestMatchTag(),
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
    final vehicle = _vehicles[index];
    final bool selected = index == _selectedVehicleIndex;
    return InkWell(
      onTap: () => setState(() {
        _selectedVehicleIndex = index;
        _selectedSeats.clear();
      }),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? const Color(0xFF3B82F6) : const Color(0xFFE5E7EB),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFDBEAFE),
              child:
                  Icon(vehicle['icon'] as IconData, color: const Color(0xFF2563EB)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle['name'] as String,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(vehicle['driver'] as String,
                          style: const TextStyle(color: Color(0xFF6B7280))),
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Color(0xFFF59E0B), size: 14),
                      const SizedBox(width: 2),
                      Text('${vehicle['rating']}'),
                      const SizedBox(width: 8),
                      const Icon(Icons.person_outline,
                          color: Color(0xFF6B7280), size: 14),
                      const SizedBox(width: 2),
                      Text('${vehicle['seats']}',
                          style: const TextStyle(color: Color(0xFF6B7280))),
                      const SizedBox(width: 8),
                      const Icon(Icons.schedule,
                          color: Color(0xFF6B7280), size: 14),
                      const SizedBox(width: 2),
                      Text('${vehicle['duration']}',
                          style: const TextStyle(color: Color(0xFF6B7280))),
                    ],
                  ),
                ],
              ),
            ),
            Text('AFN ${vehicle['price']}',
                style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _seatLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendDot(color: Color(0xFFE5E7EB), label: 'Available'),
          SizedBox(width: 16),
          _LegendDot(color: Color(0xFF3B82F6), label: 'Selected'),
          SizedBox(width: 16),
          _LegendDot(color: Color(0xFFCBD5E1), label: 'Taken'),
        ],
      ),
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
              child: Icon(
                Icons.directions_car_outlined,
                size: 13,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _seatCodes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 1.1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (_, index) {
              final seat = _seatCodes[index];
              final bool taken = _takenSeats.contains(seat);
              final bool selected = _selectedSeats.contains(seat);
              final Color bgColor = taken
                  ? const Color(0xFFE2E8F0)
                  : selected
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFFF1F5F9);
              final Color txtColor = selected
                  ? Colors.white
                  : taken
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF0F172A);
              return InkWell(
                onTap: taken ? null : () => _toggleSeat(seat),
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    seat,
                    style: TextStyle(fontWeight: FontWeight.w700, color: txtColor),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _pickCity({required bool isFrom}) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: _cities
              .map((city) => ListTile(
                    title: Text(city),
                    onTap: () => Navigator.pop(context, city),
                  ))
              .toList(),
        ),
      ),
    );
    if (selected == null) return;
    setState(() {
      if (isFrom) {
        _from = selected;
      } else {
        _to = selected;
      }
    });
  }

  void _swapCities() {
    if (_to == 'Select destination') return;
    setState(() {
      final oldFrom = _from;
      _from = _to;
      _to = oldFrom;
    });
  }

  void _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: _travelDate ?? DateTime.now(),
    );
    if (picked != null) {
      setState(() => _travelDate = picked);
    }
  }

  void _toggleSeat(String seat) {
    setState(() {
      if (_selectedSeats.contains(seat)) {
        _selectedSeats.remove(seat);
      } else {
        if (_selectedSeats.length >= _passengers) return;
        _selectedSeats.add(seat);
      }
    });
  }

  void _bookNow() {
    if (_to == 'Select destination') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select destination first')),
      );
      return;
    }
    if (_travelDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select travel date')),
      );
      return;
    }
    if (_selectedSeats.length != _passengers) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Select $_passengers seat(s) to continue')),
      );
      return;
    }
    final selectedVehicle = _vehicles[_selectedVehicleIndex]['name'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Booked $selectedVehicle from $_from to $_to | AFN $_estimatedPrice'),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

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

class _BestMatchTag extends StatelessWidget {
  const _BestMatchTag();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(18),
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
