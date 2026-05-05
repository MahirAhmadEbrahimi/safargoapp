import 'package:flutter/material.dart';
import '../data/app_data.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedFilter = "All";

  @override
  void initState() {
    super.initState();
    print("📊 ALL BOOKINGS: ${AppData.bookings}");
  }

  // ✅ 🔥 THIS FIX FOR AUTO REFRESH
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  List<Map<String, dynamic>> getFilteredData() {
    DateTime now = DateTime.now();

    return AppData.bookings.where((b) {
      // ✅ SAFE DATE (IMPORTANT)
      DateTime date;
      if (b["date"] is DateTime) {
        date = b["date"];
      } else {
        date = DateTime.tryParse(b["date"].toString()) ?? DateTime.now();
      }

      if (selectedFilter == "Daily") {
        return date.day == now.day &&
            date.month == now.month &&
            date.year == now.year;
      }

      if (selectedFilter == "Monthly") {
        return date.month == now.month && date.year == now.year;
      }

      if (selectedFilter == "Yearly") {
        return date.year == now.year;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ DEBUG (YOU WILL SEE DATA NOW)
    print("📊 BUILD BOOKINGS: ${AppData.bookings}");

    List<Map<String, dynamic>> data = getFilteredData();

    int total = data.length;

    int revenue = data.fold(0, (sum, item) {
      String price = item["price"].toString().replaceAll(RegExp(r'[^0-9]'), '');
      return sum + (int.tryParse(price) ?? 0);
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),

      // ✅ 🔥 PULL TO REFRESH ADDED
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Filter Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: ["All", "Daily", "Monthly", "Yearly"].map((type) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedFilter = type;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedFilter == type
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    child: Text(type),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),

              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.confirmation_number,
                              color: Colors.blue,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Total Tickets",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$total",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.attach_money,
                              color: Colors.green,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Revenue",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "$revenue AFN",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // List
              Expanded(
                child: data.isEmpty
                    ? const Center(
                        child: Text(
                          "No bookings yet",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (_, i) {
                          final b = data[i];

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.receipt,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        "Booking Details",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text("From: ${b["from"]}"),
                                  Text("To: ${b["to"]}"),
                                  Text("Date: ${b["date"]}"),
                                  Text("Type: ${b["type"]}"),
                                  Text("Time: ${b["time"]}"),
                                  Text("Payment: Electronic 💳"),
                                  Text("Price: ${b["price"]}"),
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
      ),
    );
  }
}
