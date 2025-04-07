import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ForecastChart extends StatelessWidget {
  final List<int> probabilities;

  const ForecastChart({super.key, required this.probabilities});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A3A5F),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(
                probabilities.length,
                (index) =>
                    FlSpot(index.toDouble(), probabilities[index].toDouble()),
              ),
              isCurved: true,
              color: Colors.lightBlueAccent,
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.shade100.withOpacity(0.2),
              ),
              dotData: const FlDotData(show: false),
              barWidth: 4,
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const labels = ['12 PM', '2 PM', '4 PM', '6 PM', '8 PM'];
                  return Text(
                    value.toInt() < labels.length ? labels[value.toInt()] : '',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 20,
                getTitlesWidget: (value, _) {
                  return Text(
                    '${value.toInt()}%',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
        ),
      ),
    );
  }
}
