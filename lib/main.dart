import 'package:flutter/material.dart';

void main() {
  runApp(const KitschCoffeeApp());
}

class AppColors {
  static const cherry = Color(0xFFD7263D);
  static const bubblegum = Color(0xFFF7A8C4);
  static const cream = Color(0xFFFFF4E6);
}

const Map<String, double> menu = {
  'Pumpkin Spiced Latte': 5.00,
  "Mocha": 6.00,
  'Cold Brew': 4.00,
  'Drip Coffee': 3.00,
};

class KitschCoffeeApp extends StatelessWidget {
  const KitschCoffeeApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kitsch Coffee',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: AppColors.cherry),
        scaffoldBackgroundColor: AppColors.cream,
      ),
      home: const OrderScreen(),
    );
  }
}

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final Set<String> selected = {};

  double get total => selected.fold(0, (sum, name) => sum + menu[name]!);

  void toggle(String name) {
    setState(() {
      selected.contains(name) ? selected.remove(name) : selected.add(name);
    });
  }

  void placeOrder() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order placed!'),
        content: Text('Total is \$${total.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.bubblegum,

        title: const Row(
          children: [
            Icon(Icons.coffee, color: AppColors.cherry),
            SizedBox(width: 8),
            Text(
              'Kitsch Coffee',
              style: TextStyle(
                color: AppColors.cherry,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final name in menu.keys)
            DrinkCard(
              name: name,
              price: menu[name]!,
              isSelected: selected.contains(name),
              onTap: () => toggle(name),
            ),

          const Divider(height: 32), //new ui element
          Text(
            'Total Amount \$${total.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (selected.isNotEmpty)
            FilledButton(
              onPressed: placeOrder,
              child: const Text('Place Order'),
            ),
        ],
      ),
    );
  }
}
// Center is a layout widget. It takes a single child and positions it
// in the middle of the parent.

class DrinkCard extends StatelessWidget {
  final String name;
  final double price;
  final bool isSelected;
  final VoidCallback onTap;

  const DrinkCard({
    super.key,
    required this.name,
    required this.price,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(name),
        subtitle: Text('\$${price.toStringAsFixed(2)}'),
        trailing: Icon(
          isSelected ? Icons.check_circle : Icons.add_circle_outline,
          color: AppColors.cherry,
        ),
        onTap: onTap,
      ),
    );
  }
}
