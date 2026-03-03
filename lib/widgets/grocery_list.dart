import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list_app/data/categories.dart';
import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>> _loadItems;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadItems = _loadItem();
  }

  List<GroceryItem> _getFilteredItems() {
    if (_searchQuery.isEmpty) {
      return _groceryItems;
    }
    return _groceryItems
        .where(
          (item) =>
              item.name.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  Future<List<GroceryItem>> _loadItem() async {
    try {
      final url = Uri.https(
        'shopping-list-flutter-ap-6e165-default-rtdb.firebaseio.com',
        'shopping-list.json',
      );

      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw Exception(
          'Failed to fetch grocery items. Please try again later.',
        );
      }

      if (response.body == 'null') {
        return [];
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
              (catItem) => catItem.value.title == item.value['category'],
            )
            .value;
        loadedItems.add(
          GroceryItem(
            id: item.key,
            name: item.value['name'],
            quantity: item.value['quantity'],
            category: category,
          ),
        );
      }

      return loadedItems;
    } catch (error) {
      setState(() {
        _error = 'Something went wrong, please try again later!';
      });
      rethrow;
    }
  }

  void _addItem() async {
    final newItem = await Navigator.of(
      context,
    ).push<GroceryItem>(MaterialPageRoute(builder: (ctx) => NewItem()));

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https(
      'shopping-list-flutter-ap-6e165-default-rtdb.firebaseio.com',
      'shopping-list/${item.id}.json',
    );

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Groceries'),
        actions: [IconButton(onPressed: _addItem, icon: Icon(Icons.add))],
      ),
      body: FutureBuilder(
        future: _loadItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          // Populate _groceryItems when data loads
          if (snapshot.hasData &&
              _groceryItems.isEmpty &&
              snapshot.data!.isNotEmpty) {
            _groceryItems = snapshot.data!;
          }

          final filteredItems = _getFilteredItems();

          if (_groceryItems.isEmpty) {
            return const Center(child: Text('No items added yet.'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              if (filteredItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No items match your search.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (ctx, index) => Dismissible(
                      key: ValueKey(filteredItems[index].id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        final deletedItem = filteredItems[index];
                        _removeItem(deletedItem);
                      },
                      child: ListTile(
                        title: Text(filteredItems[index].name),
                        leading: Container(
                          width: 24,
                          height: 24,
                          color: filteredItems[index].category.color,
                        ),
                        trailing: Text(
                          filteredItems[index].quantity.toString(),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
