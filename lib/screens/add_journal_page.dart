import 'package:fish_app/controller/add_journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddJournalPage extends StatelessWidget {
  final AddJournalController controller = Get.put(AddJournalController());

   AddJournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> dates = controller.getDates();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Journal',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        // Envelopper le contenu dans un SingleChildScrollView pour le rendre défilable
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select the date",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              //obx est un widget réactif qui met à jour l'interface lorsque Rx(variable) change
              Obx(
                () => Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(dates.length + 1, (index) {
                        bool isSelected =
                            index == controller.selectedDateIndex.value;
                        return GestureDetector(
                          onTap: () {
                            if (index == dates.length) {
                              _showDatePicker(
                                context,
                              ); // Afficher le calendrier si "Other" est sélectionné
                            } else {
                              controller.selectedDateIndex.value = index;
                              controller.selectedDate.value = DateTime.parse(
                                dates[index]["date"],
                              );
                            }
                          },
                          child: Container(
                            width: 70,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  isSelected
                                      ? Colors.blue
                                      : const Color.fromARGB(
                                        255,
                                        213,
                                        235,
                                        251,
                                      ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  index < dates.length
                                      ? dates[index]["day"]!
                                      : "Other",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                ),
                                Text(
                                  index < dates.length
                                      ? dates[index]["weekday"]!
                                      : "Date",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    if (controller.showCalendar.value)
                      _buildDatePicker(context),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Time Selection
              const Text(
                "Select time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 213, 235, 251),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(
                      () =>
                          _timeButton(context, controller.fromTime.value, true),
                    ),
                    const Icon(Icons.arrow_forward),
                    Obx(
                      () =>
                          _timeButton(context, controller.toTime.value, false),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Description Input
              const Text(
                "Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter details...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 213, 235, 251),
                ),
              ),

              const SizedBox(height: 20),

              // Save Button
              GestureDetector(
                onTap: controller.saveJournal,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      "Save",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeButton(BuildContext context, TimeOfDay? time, bool isFrom) {
    return GestureDetector(
      onTap: () => Get.find<AddJournalController>().selectTime(context, isFrom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Text(
          time != null ? time.format(context) : (isFrom ? "From" : "To"),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // Affichage du calendrier
  void _showDatePicker(BuildContext context) {
    controller
        .toggleCalendar(); // Bascule pour afficher ou masquer le calendrier
  }

  // Widget pour le sélecteur de date
  Widget _buildDatePicker(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CalendarDatePicker(
        initialDate: controller.selectedDate.value ?? DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 365)),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        onDateChanged: (date) {
          controller.selectCustomDate(date); // Met à jour la date sélectionnée
        },
      ),
    );
  }
}
