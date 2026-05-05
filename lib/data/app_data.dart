class AppData {
  static final List<Map<String, dynamic>> bookings = [];

  // ✅ ADD BOOKING FUNCTION
  static void addBooking(Map<String, dynamic> booking) {
    bookings.add(booking);
    print("✅ Booking Saved: $bookings");
  }

  // ✅ PRICE SYSTEM (PROVINCE BASED)
  static int getPrice(String from, String to) {
    if (from == to) return 100;

    Map<String, int> basePrices = {
      "کابل": 300,
      "هرات": 700,
      "مزار شریف": 600,
      "قندهار": 650,
      "جلال‌آباد": 400,
      "بلخ": 600,
      "غزنی": 350,
      "خوست": 500,
      "پکتیا": 450,
      "بدخشان": 800,
      "بغلان": 500,
      "فراه": 700,
      "لوگر": 250,
      "پروان": 200,
      "سمنگان": 550,
    };

    return (basePrices[from] ?? 400) + (basePrices[to] ?? 400) ~/ 2;
  }
}
