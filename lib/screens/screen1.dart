import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../models/app_state.dart';
import 'screen3.dart';

class Screen1 extends StatefulWidget {
  final Product product;

  const Screen1({Key? key, required this.product}) : super(key: key);

  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  String? _selectedSize;
  String? _selectedColor;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.url,
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\$${product.precio.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, color: Colors.green),
            ),
            const SizedBox(height: 10),
            Text(
              product.nota ?? "Sin descripción",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Selección de talla
            if (product.talla != null) ...[
              const Text("Selecciona una talla:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: product.talla!.map((size) {
                  return ChoiceChip(
                    label: Text(size),
                    selected: _selectedSize == size,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSize = selected ? size : null;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],

            // Selección de color
            if (product.color != null) ...[
              const Text("Selecciona un color:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8.0,
                children: product.color!.map((colorHex) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = colorHex;
                      });
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Color(int.parse("0xFF${colorHex.substring(1)}")),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _selectedColor == colorHex ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],

            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (_selectedSize == null || _selectedColor == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Por favor, selecciona talla y color")),
                      );
                      return;
                    }

                    appState.addToCart(product, _selectedSize!, _selectedColor!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${product.name} agregado al carrito")),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("Agregar al carrito"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Screen3()),
                    );
                  },
                  child: const Text("Ir al carrito"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
