import 'package:flutter/material.dart';
import "../data/app_data.dart";

class TripsScreen extends StatefulWidget {
  final String from;
  final String to;

  const TripsScreen({super.key, required this.from, required this.to});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  final List<Map<String, dynamic>> trips = [
    {"type": "VIP Bus", "time": "08:00 AM"},
    {"type": "Regular Bus", "time": "10:00 AM"},
    {"type": "Private Car", "time": "01:00 PM"},
  ];

  void bookTicket(Map<String, dynamic> trip) {
    final price = AppData.getPrice(widget.from, widget.to);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Ticket"),
        content: Text(
          "From: ${widget.from}\n"
          "To: ${widget.to}\n"
          "Type: ${trip["type"]}\n"
          "Time: ${trip["time"]}\n"
          "Price: $price AFN",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {
              // ✅ SAVE BOOKING
              AppData.addBooking({
                "from": widget.from,
                "to": widget.to,
                "type": trip["type"],
                "time": trip["time"],
                "price": "$price AFN",
                "date": DateTime.now(),
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Ticket Booked Successfully 🎉")),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final price = AppData.getPrice(widget.from, widget.to);

    return Scaffold(
      appBar: AppBar(title: Text("${widget.from} → ${widget.to}")),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Available Trips",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: trips.length,
                itemBuilder: (_, i) {
                  final trip = trips[i];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.directions_bus,
                        color: Colors.blue,
                        size: 32,
                      ),
                      title: Text(
                        trip["type"] ?? "Unknown",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("⏰ ${trip["time"] ?? ""}"),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$price AFN",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          ElevatedButton(
                            onPressed: () => bookTicket(trip),
                            child: const Text("Book"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
