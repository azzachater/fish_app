import 'package:fish_app/constants/theme.dart';
import 'package:fish_app/controller/data_selector_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatelessWidget {
  final DateSelectorController controller = Get.find<DateSelectorController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left, color: AppTheme.primaryColor),
                onPressed:
                    controller
                        .goToPreviousMonth, // Utilisez directement la méthode
              ),
              Obx(
                () => Text(
                  DateFormat(
                    'MMMM yyyy',
                  ).format(controller.currentDisplayedMonth.value),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkPrimary,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right, color: AppTheme.primaryColor),
                onPressed:
                    controller.goToNextMonth, // Utilisez directement la méthode
              ),
            ],
          ),
        ),
        // Liste des jours
        SizedBox(
          height: 80,
          child: Obx(
            () => ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.dates.length,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemBuilder: (context, index) {
                DateTime date = controller.dates[index];
                bool isToday = _isSameDay(date, DateTime.now());
                bool isSelected = index == controller.selectedIndex.value;

                return GestureDetector(
                  onTap: () => controller.selectDate(index),
                  child: Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppTheme.primaryColor
                              : isToday
                              ? AppTheme.lightPrimary
                              : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: AppTheme.darkPrimary.withOpacity(0.4),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                              : [],
                      border:
                          isSelected || isToday
                              ? null
                              : Border.all(
                                color: AppTheme.lightPrimary,
                                width: 1,
                              ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('d').format(date),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                isSelected
                                    ? Colors.white
                                    : isToday
                                    ? AppTheme.primaryColor
                                    : AppTheme.darkPrimary.withOpacity(0.8),
                          ),
                        ),
                        Text(
                          DateFormat('E').format(date), // Ex: Mon
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                isSelected
                                    ? Colors.white70
                                    : isToday
                                    ? AppTheme.primaryColor
                                    : AppTheme.darkPrimary.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
