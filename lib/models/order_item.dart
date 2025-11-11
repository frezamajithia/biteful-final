class OrderItem {
  int? id;
  int? orderId;
  final String itemName;
  final int quantity;
  final double unitPrice;

  OrderItem({
    this.id,
    this.orderId,
    required this.itemName,
    required this.quantity,
    required this.unitPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orderId': orderId,
      'itemName': itemName,
      'quantity': quantity,
      'unitPrice': unitPrice,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      id: map['id'] as int?,
      orderId: map['orderId'] as int?,
      itemName: map['itemName'] as String,
      quantity: map['quantity'] as int,
      unitPrice: map['unitPrice'] as double,
    );
  }

  double get totalPrice => unitPrice * quantity;
}