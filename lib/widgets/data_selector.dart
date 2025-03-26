import 'package:fish_app/controller/data_selector_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final DateSelectorController controller = Get.put(DateSelectorController());

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.dates.length,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        itemBuilder: (context, index) {
          DateTime date = controller.dates[index];

          return GestureDetector(
            onTap: () => controller.selectDate(index),
            child: Obx(() {
              bool isSelected = index == controller.selectedIndex.value;

              return Container(
                width: 60,
                margin: const EdgeInsets.symmetric(horizontal: 5),
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.5),
                              blurRadius: 5,
                              spreadRadius: 2,
                            ),
                          ]
                          : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd').format(date),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      DateFormat('E').format(date), // Ex: Mon
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.black54,
                      ),
                    ),
                  ],
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
