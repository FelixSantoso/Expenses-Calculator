//ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransction;
  const Chart(this.recentTransction, {super.key});

  List<Map<String, Object>> get listTransaction {
    return List.generate(7, (index) {
      // final weekDay = DateTime.now().subtract(Duration(days: index));

      final weekDay = DateTime.now()
          .subtract(Duration(days: DateTime.now().weekday - (index + 1)));

      // print(
      //     'End of week: ${DateTime.now().add(Duration(days: DateTime.daysPerWeek - DateTime.now().weekday))}');

      var totalAmount = 0.0;
      for (int i = 0; i < recentTransction.length; i++) {
        if (recentTransction[i].date.day == weekDay.day &&
            recentTransction[i].date.month == weekDay.month &&
            recentTransction[i].date.year == weekDay.year) {
          totalAmount += recentTransction[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalAmount
      };
    }, growable: false);
  }

  double get totalSpending {
    return listTransaction.fold(0.0, (previousValue, element) {
      return previousValue + (element['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: listTransaction.map((e) {
            return Flexible(
              fit: FlexFit.tight,
              child: BarChart(
                label: (e['day'] as String),
                spendingAmount: (e['amount'] as double),
                spendingPrecentage: totalSpending == 0.0
                    ? 0
                    : (e['amount'] as double) / totalSpending,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
