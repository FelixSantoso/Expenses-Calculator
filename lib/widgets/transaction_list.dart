import 'package:flutter/material.dart';

import 'package:money_formatter/money_formatter.dart';

import '../models/transaction.dart';
import './transaction_item.dart';

class TransactionList extends StatelessWidget {
  const TransactionList(this.transactionList, this.delTransaction, this.height,
      {super.key});
  final Function delTransaction;
  final List<Transaction> transactionList;
  final num height;

  @override
  Widget build(BuildContext context) {
    MoneyFormatter fmf;
    return transactionList.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constrain) {
              return Column(
                children: <Widget>[
                  const Text(
                    'Add here to list your expenses',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: constrain.maxHeight * height,
                    child: Image.asset(
                      'assets/images/NoList.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            },
          )
        : Container(
            padding: const EdgeInsets.all(5),
            child: ListView.builder(
              itemCount: transactionList.length,
              itemBuilder: ((context, index) {
                fmf = MoneyFormatter(
                  amount: transactionList[index].amount,
                  settings: MoneyFormatterSettings(
                    symbol: 'IDR',
                    thousandSeparator: '.',
                    symbolAndNumberSeparator: ' ',
                    compactFormatType: CompactFormatType.short,
                    fractionDigits: 0,
                  ),
                );
                return TransactionItem(
                  fmf: fmf,
                  transaction: transactionList[index],
                  delTransaction: delTransaction,
                  index: index,
                );
              }),
            ),
          );
  }
}
