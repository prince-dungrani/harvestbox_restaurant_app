import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../services/menu_service.dart';
import '../theme/app_theme.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final MenuService _menuService = MenuService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Admin Panel',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle, color: AppTheme.primaryGreen),
            tooltip: 'Add Item',
            onPressed: () => _showItemForm(context),
          ),
        ],
      ),
      body: StreamBuilder<List<FoodItem>>(
        stream: _menuService.menuItemsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text('Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red)),
                ],
              ),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.restaurant_menu,
                      size: 64, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text('No menu items yet',
                      style: TextStyle(
                          fontSize: 18, color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  ElevatedButton.icon(
                    onPressed: () => _showItemForm(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add First Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildItemCard(item);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemForm(context),
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildItemCard(FoodItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 60,
            height: 60,
            color: Colors.grey.shade200,
            child: Image.network(
              item.image,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.restaurant, size: 30),
            ),
          ),
        ),
        title: Text(item.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${item.price.toStringAsFixed(2)}',
                style: const TextStyle(
                    color: AppTheme.primaryGreen, fontWeight: FontWeight.w600)),
            Row(
              children: [
                Text(item.category,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: item.isAvailable
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.isAvailable ? 'Available' : 'Unavailable',
                    style: TextStyle(
                      fontSize: 10,
                      color: item.isAvailable ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              _showItemForm(context, item: item);
            } else if (value == 'toggle') {
              _toggleAvailability(item);
            } else if (value == 'delete') {
              _confirmDelete(item);
            }
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'edit', child: Text('✏️ Edit')),
            PopupMenuItem(
                value: 'toggle',
                child: Text(item.isAvailable
                    ? '🔴 Mark Unavailable'
                    : '🟢 Mark Available')),
            const PopupMenuItem(
                value: 'delete',
                child:
                    Text('🗑️ Delete', style: TextStyle(color: Colors.red))),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleAvailability(FoodItem item) async {
    try {
      await _menuService.updateMenuItem(item.id, {
        'isAvailable': !item.isAvailable,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${item.name} marked as ${!item.isAvailable ? "available" : "unavailable"}'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _confirmDelete(FoodItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _menuService.deleteMenuItem(item.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${item.name} deleted'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
          );
        }
      }
    }
  }

  void _showItemForm(BuildContext context, {FoodItem? item}) {
    final isEditing = item != null;
    final nameController = TextEditingController(text: item?.name ?? '');
    final descController = TextEditingController(text: item?.description ?? '');
    final priceController =
        TextEditingController(text: item?.price.toString() ?? '');
    final imageController = TextEditingController(text: item?.image ?? '');
    String selectedCategory = item?.category ?? 'Pizza';
    bool isAvailable = item?.isAvailable ?? true;
    bool isVeg = item?.isVeg ?? false;
    bool isSpicy = item?.isSpicy ?? false;

    final categories = [
      'Pizza',
      'Burgers',
      'Coffee',
      'Garlic Bread',
      'Salads',
      'Desserts'
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Title
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      isEditing ? 'Edit Menu Item' : 'Add Menu Item',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),

                  // Form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(nameController, 'Item Name',
                              Icons.restaurant),
                          const SizedBox(height: 12),
                          _buildTextField(descController, 'Description',
                              Icons.description,
                              maxLines: 2),
                          const SizedBox(height: 12),
                          _buildTextField(
                              priceController, 'Price', Icons.attach_money,
                              keyboardType: TextInputType.number),
                          const SizedBox(height: 12),
                          _buildTextField(
                              imageController, 'Image URL', Icons.image),
                          const SizedBox(height: 16),

                          // Category Dropdown
                          DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration: InputDecoration(
                              labelText: 'Category',
                              prefixIcon: const Icon(Icons.category),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            items: categories.map((cat) {
                              return DropdownMenuItem(
                                  value: cat, child: Text(cat));
                            }).toList(),
                            onChanged: (val) {
                              setModalState(() => selectedCategory = val!);
                            },
                          ),
                          const SizedBox(height: 16),

                          // Toggles
                          SwitchListTile(
                            title: const Text('Available'),
                            value: isAvailable,
                            activeColor: AppTheme.primaryGreen,
                            onChanged: (val) =>
                                setModalState(() => isAvailable = val),
                          ),
                          SwitchListTile(
                            title: const Text('Vegetarian'),
                            value: isVeg,
                            activeColor: AppTheme.primaryGreen,
                            onChanged: (val) =>
                                setModalState(() => isVeg = val),
                          ),
                          SwitchListTile(
                            title: const Text('Spicy'),
                            value: isSpicy,
                            activeColor: Colors.red,
                            onChanged: (val) =>
                                setModalState(() => isSpicy = val),
                          ),

                          const SizedBox(height: 20),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (nameController.text.trim().isEmpty ||
                                    priceController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text('Name and Price are required'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                  return;
                                }

                                final price = double.tryParse(
                                        priceController.text.trim()) ??
                                    0.0;

                                try {
                                  if (isEditing) {
                                    await _menuService
                                        .updateMenuItem(item.id, {
                                      'name': nameController.text.trim(),
                                      'description':
                                          descController.text.trim(),
                                      'price': price,
                                      'image': imageController.text.trim(),
                                      'category': selectedCategory,
                                      'isAvailable': isAvailable,
                                      'isVeg': isVeg,
                                      'isSpicy': isSpicy,
                                    });
                                  } else {
                                    await _menuService.addMenuItem(FoodItem(
                                      id: '',
                                      name: nameController.text.trim(),
                                      description:
                                          descController.text.trim(),
                                      price: price,
                                      image: imageController.text.trim(),
                                      category: selectedCategory,
                                      isAvailable: isAvailable,
                                      isVeg: isVeg,
                                      isSpicy: isSpicy,
                                    ));
                                  }

                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(isEditing
                                            ? 'Item updated!'
                                            : 'Item added!'),
                                        backgroundColor:
                                            AppTheme.primaryGreen,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryGreen,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              child: Text(
                                isEditing ? 'Update Item' : 'Add Item',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
