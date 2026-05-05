
class Trip {
  final String type;
  final String time;
  final String price;

  Trip({
    required this.type,
    required this.time,
    required this.price,
  });

  factory Trip.fromMap(Map<String, dynamic> map) {
    return Trip(
      type: map['type'],
      time: map['time'],
      price: map['price'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'time': time,
      'price': price,
    };
  }
}