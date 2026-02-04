import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/order.dart';

class OrderService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // CREATE: Save order to Firebase
  Future<String?> createOrder(Order order) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Generate unique order ID
      final ordersRef = _database.child('orders').child(userId);
      final newOrderRef = ordersRef.push();
      
      // Create order with generated ID
      final orderWithId = Order(
        id: newOrderRef.key!,
        userId: userId,
        items: order.items,
        totalAmount: order.totalAmount,
        status: order.status,
        createdAt: order.createdAt,
        deliveryAddress: order.deliveryAddress,
      );

      // Save to Firebase
      await newOrderRef.set(orderWithId.toJson());
      
      return newOrderRef.key;
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  // READ: Get all orders for current user
  Future<List<Order>> getOrders() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final ordersRef = _database.child('orders').child(userId);
      final snapshot = await ordersRef.get();

      if (!snapshot.exists) return [];

      final ordersMap = snapshot.value as Map<dynamic, dynamic>;
      final orders = ordersMap.entries.map((entry) {
        return Order.fromJson(entry.value as Map<dynamic, dynamic>);
      }).toList();

      // Sort by creation date (newest first)
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
    } catch (e) {
      print('Error fetching orders: $e');
      return [];
    }
  }

  // READ: Get single order by ID
  Future<Order?> getOrderById(String orderId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final orderRef = _database.child('orders').child(userId).child(orderId);
      final snapshot = await orderRef.get();

      if (!snapshot.exists) return null;

      return Order.fromJson(snapshot.value as Map<dynamic, dynamic>);
    } catch (e) {
      print('Error fetching order: $e');
      return null;
    }
  }

  // UPDATE: Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _database
          .child('orders')
          .child(userId)
          .child(orderId)
          .update({'status': status});
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }

  // DELETE: Delete order
  Future<void> deleteOrder(String orderId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _database.child('orders').child(userId).child(orderId).remove();
    } catch (e) {
      print('Error deleting order: $e');
      rethrow;
    }
  }

  // CANCEL: Cancel an order (updates status to 'cancelled')
  Future<void> cancelOrder(String orderId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      await _database
          .child('orders')
          .child(userId)
          .child(orderId)
          .update({'status': 'cancelled'});
    } catch (e) {
      print('Error cancelling order: $e');
      rethrow;
    }
  }

  // Stream of orders (real-time updates)
  Stream<List<Order>> ordersStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _database.child('orders').child(userId).onValue.map((event) {
      if (!event.snapshot.exists) return <Order>[];

      final ordersMap = event.snapshot.value as Map<dynamic, dynamic>;
      final orders = ordersMap.entries.map((entry) {
        return Order.fromJson(entry.value as Map<dynamic, dynamic>);
      }).toList();

      // Sort by creation date (newest first)
      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      return orders;
    });
  }
}
