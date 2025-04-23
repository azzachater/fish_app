import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controller/data_selector_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
                  color: isSelected ? AppTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.darkPrimary.withOpacity(0.4),
                            blurRadius: 6,
                            spreadRadius: 1,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : [],
                  border: isSelected
                      ? null
                      : Border.all(color: AppTheme.lightPrimary, width: 1),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd').format(date),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? Colors.white
                            : AppTheme.darkPrimary.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      DateFormat('E').format(date), // Ex: Mon
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white70
                            : AppTheme.darkPrimary.withOpacity(0.6),
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