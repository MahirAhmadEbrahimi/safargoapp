import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/app_data.dart';
import 'trips_screen.dart';
import 'report_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String from = "از ولایت";
  String to = "به ولایت";
  String date = "تاریخ";
  String payment = "پرداخت";
  List<int> selectedSeats = [];

  late AnimationController _controller;

  final List<String> provinces = [
    "کابل",
    "هرات",
    "مزار شریف",
    "قندهار",
    "جلال‌آباد",
    "بلخ",
    "غزنی",
    "خوست",
    "پکتیا",
    "بدخشان",
    "بغلان",
    "فراه",
    "لوگر",
    "پروان",
    "سمنگان",
  ];

  final List<String> payments = ["پول الکترونیکی 💳", "نقدی 💵"];

  final List<Map<String, dynamic>> services = [
    {"title": "Online Ticket Booking", "icon": Icons.directions_bus},
    {"title": "Instant Trip Search", "icon": Icons.search},
    {"title": "Secure Payments", "icon": Icons.lock},
    {"title": "Daily Reports System", "icon": Icons.bar_chart},
    {"title": "24/7 Support", "icon": Icons.support_agent},
  ];

  @override
  void initState() {
    super.initState();
    void pickSeats() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (_) {
          return StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "انتخاب چوکی",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    GridView.builder(
                      shrinkWrap: true,
                      itemCount: 20,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                          ),
                      itemBuilder: (context, index) {
                        int seat = index + 1;
                        bool selected = selectedSeats.contains(seat);

                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              setState(() {
                                if (selected) {
                                  selectedSeats.remove(seat);
                                } else {
                                  selectedSeats.add(seat);
                                }
                              });
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: selected ? Colors.green : Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "$seat",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("تایید"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  void pick(List<String> items, Function(String) onSelect) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return ListView(
          padding: const EdgeInsets.all(10),
          children: items
              .map(
                (e) => ListTile(
                  title: Text(e),
                  onTap: () => Navigator.pop(context, e),
                ),
              )
              .toList(),
        );
      },
    ).then((value) {
      if (value != null) onSelect(value);
    });
  }

  void pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        date = "${picked.year}/${picked.month}/${picked.day}";
      });
    }
  }

  void swap() {
    _controller.forward(from: 0);
    setState(() {
      final temp = from;
      from = to;
      to = temp;
    });
  }

  Widget box(String text, IconData icon, VoidCallback onTap) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue, size: 28),
              const SizedBox(width: 12),
              Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void navigateTo(String page) {
    Navigator.pop(context);

    if (page == "home") {
      setState(() {});
    } else if (page == "services") {
      showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Our Services",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ...services.map(
                  (s) => ListTile(
                    leading: Icon(s["icon"], color: Colors.blue),
                    title: Text(s["title"]),
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else if (page == "reports") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ReportScreen()),
      );
    } else if (page == "contact") {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Contact: 0778511935")));
    }
    // ❌ REMOVED BOOKINGS (as you requested)
    else if (page == "logout") {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  void pickSeats() {
    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("انتخاب چوکی"),
              content: SizedBox(
                width: double.maxFinite,
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: 20,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                  ),
                  itemBuilder: (context, index) {
                    int seat = index + 1;
                    bool selected = selectedSeats.contains(seat);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selected) {
                            selectedSeats.remove(seat);
                          } else {
                            selectedSeats.add(seat);
                          }
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selected ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(child: Text("$seat")),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("تمام"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void confirmBooking() {
    if (from == "از ولایت" || to == "به ولایت") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select route first")),
      );
      return;
    }

    int priceValue;
    try {
      priceValue = AppData.getPrice(from, to);
    } catch (e) {
      priceValue = 500;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Booking"),
        content: Text(
          "From: $from\nTo: $to\nDate: $date\nPayment: $payment\nPrice: $priceValue AFN",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              AppData.bookings.add({
                "from": from,
                "to": to,
                "type": "Home Booking",
                "time": date,
                "price": "$priceValue AFN",
                "date": DateTime.now(),
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Ticket Booked 🎉")));
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "SafeGo",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () => navigateTo("home"),
            ),

            ListTile(
              leading: const Icon(Icons.directions_bus),
              title: const Text("Services"),
              onTap: () => navigateTo("services"),
            ),

            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: const Text("Reports"),
              onTap: () => navigateTo("reports"),
            ),

            ListTile(
              leading: const Icon(Icons.contact_phone),
              title: const Text("Contact"),
              onTap: () => navigateTo("contact"),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () => navigateTo("logout"),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Search Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Find Your Trip",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),

                      box(
                        from,
                        Icons.location_on,
                        () => pick(provinces, (v) => setState(() => from = v)),
                      ),

                      Center(
                        child: RotationTransition(
                          turns: Tween(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(_controller),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: swap,
                              icon: const Icon(
                                Icons.swap_vert,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),

                      box(
                        to,
                        Icons.flag,
                        () => pick(provinces, (v) => setState(() => to = v)),
                      ),

                      box(date, Icons.date_range, pickDate),

                      box(
                        payment,
                        Icons.payment,
                        () =>
                            pick(payments, (v) => setState(() => payment = v)),
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (from == "از ولایت" || to == "به ولایت") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please select route"),
                                ),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TripsScreen(from: from, to: to),
                              ),
                            );
                          },
                          child: const Text("SEARCH TRIPS"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Services Section
              const Text(
                "Our Services",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () => navigateTo("services"),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(service["icon"], size: 40, color: Colors.blue),
                            const SizedBox(height: 8),
                            Text(
                              service["title"],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
