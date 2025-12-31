class CartItem {
  final String id;
  final String menuName;
  final int quantity;
  final int price;
  final String tenant;
  final String notes;
  final String image; 

  CartItem({
    required this.id,
    required this.menuName,
    required this.quantity,
    required this.price,
    required this.tenant,
    this.notes = '',
    required this.image, 
  });
}