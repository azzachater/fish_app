import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fish_app/models/product.dart';
import 'package:fish_app/widgets/favorite_button.dart';
import 'package:fish_app/widgets/add_to_cart_button.dart';

class ProductCardController extends GetxController {
  var isHovered = false.obs;

  void setHover(bool value) {
    isHovered.value = value;
  }
}
