//ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';

class BarChart extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPrecentage;
  const BarChart(
      {required this.label,
      required this.spendingAmount,
      required this.spendingPrecentage,
      super.key});

  @override
  Widget build(BuildContext context) {
    MoneyFormatter fmf = MoneyFormatter(
      amount: spendingAmount,
      settings: MoneyFormatterSettings(
        symbol: 'Rp',
        thousandSeparator: '.',
        symbolAndNumberSeparator: ' ',
        compactFormatType: CompactFormatType.short,
        fractionDigits: 0,
      ),
    );
    return LayoutBuilder(builder: (ctx, constraint) {
      return Column(
        children: <Widget>[
          Container(
            height: constraint.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                fmf.output.symbolOnLeft,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: constraint.maxHeight * 0.05),
          Container(
            height: constraint.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1),
                    color: Color.fromRGBO(220, 220, 220, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPrecentage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: constraint.maxHeight * 0.05),
          SizedBox(height: constraint.maxHeight * 0.15, child: Text(label)),
        ],
      );
    });
  }
}
