/*import 'package:get/get.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../../data/user_data.dart';
import '../../data/group_data.dart';

class CreateSearchGroupController extends GetxController {
  var filteredGroups = List<Group>.from(allGroupsData).obs;
  var selectedUsers = <User>[currentUser].obs; // currentUser est sélectionné par défaut
  var filteredUsers = List<User>.from(usersData).obs;

  void filterUsers(String query) {
    filteredUsers.value = usersData.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void toggleUserSelection(User user) {
    if (selectedUsers.contains(user)) {
      selectedUsers.remove(user);
    } else {
      selectedUsers.add(user);
    }
  }

  void addGroup(Group group) {
    allGroupsData.add(group);
    filteredGroups.value = List.from(allGroupsData);
    selectedUsers.clear();
    selectedUsers.add(currentUser);
  }
}
*/