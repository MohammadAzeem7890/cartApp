import 'package:get/get.dart';
import 'package:task1/CartModel.dart';
import 'package:task1/Model.dart';
import 'package:task1/Network.dart';

class Controller extends GetxController {

  var listOfCategoryProducts = List<Data>().obs;
  var addToProductsList = List<CartModel>().obs;///

  var totalPrice = 0.obs;

  var cartList = [].obs;

  var itemCountList = [].obs;
  var isInCart = false.obs;

  addToCart(index) {
    // print(itemCountList.length);
    for (int i = 0; i < listOfCategoryProducts.length; i++) {
      if (i == index) {
        addToProductsList.forEach((cart) {
          if(cart.productName.contains(listOfCategoryProducts[i].name)){
            isInCart.value = true;
          }
          else{
            isInCart.value = false;
          }
        });
        if(isInCart.value == false) {
          addToProductsList.add(
              CartModel(
                  productName: listOfCategoryProducts[index].name,
                  productImage: listOfCategoryProducts[index].featuredImage,
                  productPrice: listOfCategoryProducts[index].price,
                  numberOrdered: itemCountList[index])
          );
        }
        if(isInCart.value == true){
          itemCountList[i] = itemCountList[i] + 1;
        }
        totalPrice.value = totalPrice.value + int.parse(listOfCategoryProducts[index].price);
      }
    }
    // print(addToProductsList.length);
    update();
  }

  decreaseCartItem(index) {
    // for (int i = 0; i < listOfCategoryProducts.length; i++) {
    //   if (i == index) {
    //     // print('current index is ${index}');
    //     itemCountList[i] = itemCountList[i] == 0 ? 0 : itemCountList[i] - 1;
    //     totalPrice.value =
    //         totalPrice.value - int.parse(listOfCategoryProducts[index].price);
    //   }
    //   // print(addToProductsList.length);

      //update();
    //}//
    var product = listOfCategoryProducts[index];
    if(itemCountList[index] > 0){
      itemCountList[index]--;
      totalPrice.value = totalPrice.value - int.parse(product.price);
    }
    else{
      var cart = new CartModel(
          productName: product.name,
          productImage: product.featuredImage,
          productPrice: product.price,
          numberOrdered: itemCountList[index]);
      removeFromCart(cart, index);
    }
    update();
  }

  removeFromCart(CartModel cartModel, index) {
    // decreaseCartItem(index);
    addToProductsList.remove(cartModel);
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

  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getDataFromNetwork();
  }
}
