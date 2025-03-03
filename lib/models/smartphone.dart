class Smartphone {
  int? id;
  String brand;
  String model;
  double price;
  DateTime? purchaseDate;
  String status;

  Smartphone({
    this.id,
    required this.brand,
    required this.model,
    required this.price,
    this.purchaseDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'model': model,
      'price': price,
      'purchaseDate': purchaseDate?.millisecondsSinceEpoch,
      'status': status,
    };
  }

  factory Smartphone.fromMap(Map<String, dynamic> map) {
    return Smartphone(
      id: map['id'],
      brand: map['brand'],
      model: map['model'],
      price: map['price'],
      purchaseDate: map['purchaseDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['purchaseDate'])
          : null,
      status: map['status'],
    );
  }
}
