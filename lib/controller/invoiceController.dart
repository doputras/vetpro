import 'package:get/get.dart';

import '../model/cart.dart';

class InvoiceController extends GetxController {
  List<Cart> listCart = [
    Cart(
        description: "Transport",
        harga: "100.0000",
        qty: "2",
        total: "200.000"),
    Cart(
        description: "General Check up",
        harga: "50.0000",
        qty: "2",
        total: "100.000"),
  ];

  addCart() {
    listCart.add(Cart(
        description: 'TES add', harga: '150.000', qty: '2', total: '300.0000'));
    update();
  }
}
