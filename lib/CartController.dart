import 'package:get/get.dart';
import 'CartModel.dart';
import 'CartModel.dart';
import 'CartModel.dart';
import 'Model.dart';
import 'Model.dart';
import 'Model.dart';
import 'Network.dart';
import 'Network.dart';

class ProviderCart extends GetxController {
  var loading = true.obs;
  var getCartData = List<CartModel>().obs;
  var listOfCategoryProducts = List<Data>().obs;
  var itemCountList = [].obs;
  // var userAddress = List<addCartAddress.Address>().obs;

  var cartlength = 0.obs;


  @override
  void onInit() {
  getDataFromNetwork();
  super.onInit();
  }

  getDataFromNetwork() async {
    Network network = Network();
    await network.getProducts();
    listOfCategoryProducts.value = network.listOfData;
    // print(listOfCategoryProducts.value.length);
    while (itemCountList.length < listOfCategoryProducts.length) {
      itemCountList.add(0);
    }
  }
//!

  var cart_items = List<CartModel>().obs;

  var _totalprice = 0.0.obs;

  get totalprice => _totalprice;
  int get count => cart_items.length;

  void removeProduct(Data product) {
    cart_items.removeWhere((i) => i.productName == product.name);
    Network().getProducts().addItemInCart();
    calculateTotal();
    update();
  }

  void updateProduct(Data product, qty, indexx) async {
    int index = cart_items.indexWhere((i) => i.productName == product.name);
    cart_items[index].numberOrdered = qty;
    cart_items[index].productPrice = cart_items[index].productPrice * qty;

    loading.value = true;
    // await HttpAddItemInCart().addItemInCart();
    // await getDataItems();
    await Network().getProducts().addItemInCart();
    await getDataFromNetwork();
    calculateTotal();
    update();
  }

  void calculateTotal() {
    _totalprice.value = 0;
    getCartData.forEach((f) {
      _totalprice += int.parse(f.productPrice) * f.numberOrdered;
    });
  }

  List<CartModel> get addinCart {
    return cart_items.value;
  }
}