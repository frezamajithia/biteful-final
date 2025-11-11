class Order {
  int? id;
  final String restaurantName;
  final double total;
  final String status;
  final String createdAt;

  Order({
    this.id,
    required this.restaurantName,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantName': restaurantName,
      'total': total,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as int?,
      restaurantName: map['restaurantName'] as String,
      total: map['total'] as double,
      status: map['status'] as String,
      createdAt: map['createdAt'] as String,
    );
  }
}