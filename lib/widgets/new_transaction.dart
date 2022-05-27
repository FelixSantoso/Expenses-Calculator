//ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTxn;
  const NewTransaction(this.addTxn, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleInput = TextEditingController();
  final amountInput = TextEditingController();
  DateTime? date;

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      keyboardType: TextInputType.datetime,
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        date = value;
      });
    });
  }

  void _submitData() {
    if (amountInput.text.isEmpty) {
      return;
    }
    final title = titleInput.text;
    final amount = double.parse(amountInput.text);
    if (title.isEmpty || amount <= 0 || date == null) {
      return;
    }
    widget.addTxn(
      title,
      amount,
      date,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                TextField(
                  controller: titleInput,
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: amountInput,
                  textAlign: TextAlign.justify,
                  decoration: InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: true, signed: true),
                ),
                SizedBox(
                  height: 70,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          date == null
                              ? 'No Date Choosen'
                              : 'Date Picked : ${DateFormat.yMMMd().format(date!)}',
                        ),
                      ),
                      IconButton(
                        onPressed: _showDatePicker,
                        icon: Icon(
                          Icons.calendar_month_rounded,
                          size: 30,
                        ),
                      )
                      // Expanded(
                      //   child: Text(
                      //     date == null
                      //         ? 'No Date Choosen'
                      //         : 'Picked Date : ${DateFormat.yMMMd().format(date!)}',
                      //   ),
                      // ),
                      // TextButton(
                      //   onPressed: () {},
                      //   child: Text(
                      //     'Choose Date',
                      //     style: TextStyle(fontWeight: FontWeight.bold),
                      //   ),
                      // )
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _submitData(),
                  child: Text(
                    'Add Transaction',
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
