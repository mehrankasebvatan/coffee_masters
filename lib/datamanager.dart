import 'dart:convert';

import 'package:coffee_masters/datamodel.dart';
import 'package:http/http.dart' as http;

class DataManager {
  List<Category>? _menu;
  List<ItemInCart> cart = [];

  fetchMenu() async {
    const url = 'https://firtman.github.io/coffeemasters/api/menu.json';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var body = response.body;
      _menu = [];
      var decodeData = jsonDecode(body) as List<dynamic>;
      for (var element in decodeData) {
        _menu?.add(Category.fromJson(element));
      }
    }
  }

  Future<List<Category>> getMenu() async {
    if (_menu == null) {
      await fetchMenu();
    }
    return _menu!;
  }

  cartAdd(Product p) {
    bool found = false;
    print("size after add clicked: " + cart.length.toString());
    for (var item in cart) {
      if (item.product.id == p.id) {
        item.quantity++;
        found = true;
        print("size after add quantity: " + cart.length.toString());
      }

      if (!found) {
        cart.add(new ItemInCart(product: p, quantity: 1));
        print("size after add product: " + cart.length.toString()); 
      }
    }
  }

  cartRemove(Product p) {
    cart.removeWhere((item) => item.product.id == p.id);
  }

  cartClear() {
    cart.clear();
  }

  double cartTotal() {
    var total = 0.0;
    for (var item in cart) {
      total += item.quantity * item.product.price;
    }

    return total;
  }
}
