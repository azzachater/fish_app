import 'package:get/get.dart';
import '../data/tip_data.dart';  // Importer la liste des tips depuis tip_data.dart
import '../models/tip_model.dart';

class TipController extends GetxController {
  // Utiliser la liste des tips de tip_data.dart et la rendre réactive
  var tips = tipsData.obs; 

  // Méthode pour supprimer un conseil
  void deleteTip(int index) {
    tips.removeAt(index);
  }

  // Méthode pour ajouter un nouveau conseil
  void addTip(Tip tip) {
    tips.add(tip);
  }

  // Méthode pour mettre à jour un conseil existant
  void updateTip(int index, Tip updatedTip) {
    tips[index] = updatedTip;
  }
}
