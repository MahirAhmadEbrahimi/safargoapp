import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class BookingService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _bookingsRef =
      FirebaseDatabase.instance.ref('bookings');

  User? get currentUser => _auth.currentUser;

  Future<void> createBooking({
    required String from,
    required String to,
    required DateTime travelDate,
    required String vehicleName,
    required int passengers,
    required List<String> seats,
    required int price,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'not-authenticated',
        message: 'Please login first',
      );
    }

    final ref = _bookingsRef.push();
    await ref.set({
      'id': ref.key,
      'userId': user.uid,
      'userEmail': user.email,
      'from': from,
      'to': to,
      'travelDate': travelDate.millisecondsSinceEpoch,
      'vehicleName': vehicleName,
      'passengers': passengers,
      'seats': seats,
      'price': price,
      'createdAt': ServerValue.timestamp,
    });
  }

  Future<List<Map<String, dynamic>>> getUserBookings() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'not-authenticated',
        message: 'Please login first',
      );
    }

    final snapshot =
        await _bookingsRef.orderByChild('userId').equalTo(user.uid).get();

    final List<Map<String, dynamic>> bookings = [];
    if (!snapshot.exists || snapshot.value == null) {
      return bookings;
    }

    final raw = Map<dynamic, dynamic>.from(snapshot.value as Map);
    for (final entry in raw.entries) {
      final item = Map<dynamic, dynamic>.from(entry.value as Map);
      bookings.add({
        'id': item['id'] ?? entry.key.toString(),
        'userId': item['userId'] ?? '',
        'userEmail': item['userEmail'] ?? '',
        'from': item['from'] ?? '',
        'to': item['to'] ?? '',
        'travelDate': item['travelDate'] ?? 0,
        'vehicleName': item['vehicleName'] ?? '',
        'passengers': item['passengers'] ?? 0,
        'seats': List<dynamic>.from(item['seats'] ?? const []),
        'price': item['price'] ?? 0,
        'createdAt': item['createdAt'] ?? 0,
      });
    }

    bookings.sort((a, b) =>
        (b['travelDate'] as int).compareTo((a['travelDate'] as int)));
    return bookings;
  }
}
