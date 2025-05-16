import 'package:get/get.dart';
import 'package:fish_app/models/category.dart';

class CategoryController extends GetxController {
  var categories =
      <Category>[
        Category(name: "Tous", isSelected: true),
        Category(name: "Cannes"),
        Category(name: "Moulinets"),
        Category(name: "Leurres"),
        Category(name: "Accessoires"),
      ].obs;

  void selectCategory(int index) {
    for (var category in categories) {
      category.isSelected = false;
    }
    categories[index].isSelected = true;
    categories.refresh();
  }

  void addCategory(String name) {
    categories.add(Category(name: name));
    categories.refresh();
  }
}