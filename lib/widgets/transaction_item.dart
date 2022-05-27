import 'package:flutter/material.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.fmf,
    required this.transaction,
    required this.delTransaction,
    required this.index,
  }) : super(key: key);

  final MoneyFormatter fmf;
  final Transaction transaction;
  final Function delTransaction;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text(
                fmf.output.symbolOnLeft,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMMEEEEd().format(transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 450
            ? TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style:
                    TextButton.styleFrom(primary: Theme.of(context).errorColor),
              )
            : IconButton(
                onPressed: () => delTransaction(index),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
              ),
      ),
    );
  }
}
