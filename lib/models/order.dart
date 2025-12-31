class Order {
  final String tenant;
  final String menu;
  final int price;
  final String status; // Menunggu, Diproses, Selesai
  final DateTime createdAt;

  Order({
    required this.tenant,
    required this.menu,
    required this.price,
    required this.status,
    required this.createdAt,
  });
}