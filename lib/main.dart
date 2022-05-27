import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './models/transaction.dart';
import './widgets/new_transaction.dart';

void main() {
  // NOTE: set device orientation
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //   [
  //     DeviceOrientation.portraitDown,
  //     DeviceOrientation.portraitUp,
  //   ],
  // );
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
      theme: ThemeData(
        fontFamily: 'QuickSand',
        primaryTextTheme: ThemeData.dark().primaryTextTheme.copyWith(
            headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black)),
        appBarTheme: AppBarTheme(
            titleTextStyle: ThemeData.light()
                .textTheme
                .copyWith(
                  headline6: const TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
                .headline6),
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(primary: Colors.purple, secondary: Colors.orange),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showChart = false;

  final List<Transaction> _userTransaction = [
    Transaction(
      title: 'Pembelian Course',
      amount: 109000,
      date: DateTime.utc(2022, 5, 20, 20, 18, 04),
      txnId: DateTime.now().toString(),
    ),
    Transaction(
      title: 'Mouse',
      amount: 625000,
      date: DateTime.now(),
      txnId: DateTime.now().toString(),
    ),
    Transaction(
      title: 'Pembelian Course',
      amount: 109000,
      date: DateTime.utc(2022, 5, 21, 21, 18, 04),
      txnId: DateTime.now().toString(),
    ),
    Transaction(
      title: 'Mouse',
      amount: 625000,
      date: DateTime.utc(2022, 18, 5, 20, 18, 04),
      txnId: DateTime.now().toString(),
    ),
    Transaction(
      title: 'Pembelian Course',
      amount: 109000,
      date: DateTime.now(),
      txnId: DateTime.now().toString(),
    ),
    Transaction(
      title: 'Mouse',
      amount: 625000,
      date: DateTime.utc(2022, 5, 17, 20, 18, 04),
      txnId: DateTime.now().toString(),
    )
  ];

  List<Transaction> get _recentTransaction {
    return _userTransaction.where((txn) {
      return txn.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(String title, double amount, DateTime date) {
    final newTx = Transaction(
      title: title,
      amount: amount,
      date: date,
      txnId: DateTime.now.toString(),
    );

    setState(() {
      _userTransaction.add(newTx);
    });
    Navigator.pop(context);
  }

  //delete by index
  void _delTransaction(var index) {
    setState(() {
      _userTransaction.removeAt(index);
    });
  }

  //delete by id
  // void _deleteTransaction(String id) {
  //   setState(() {
  //     _userTransaction.removeWhere((element) => element.txnId == id);
  //   });
  // }

  void _showAddTransactionForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          MediaQuery.of(context).orientation == Orientation.landscape
              ? true
              : false,
      builder: (_) {
        return NewTransaction(_addTransaction);
      },
    );
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, txnListWidget) {
    return [
      //build switch show user can choose to view chart or txn list
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Show Chart'),
          Switch.adaptive(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
            activeColor: Theme.of(context).colorScheme.secondary,
          )
        ],
      ),
      //if switch true, show chart instead of txn list
      _showChart == true
          ? SizedBox(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.7,
              child: Chart(_recentTransaction))
          : txnListWidget,
    ];
  }

  List<Widget> _buildPotraitContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, txtnListWidget) {
    return [
      //view chart and txn
      SizedBox(
          height: (mediaQuery.size.height -
                  appBar.preferredSize.height -
                  mediaQuery.padding.top) *
              0.25,
          child: Chart(_recentTransaction)),
      txtnListWidget
    ];
  }

  PreferredSizeWidget _buildAppBar() {
    return (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('My Expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _showAddTransactionForm(),
                ),
              ],
            ),
          )
        : AppBar(
            title: const Text('My Expenses'),
          )) as PreferredSizeWidget;
  }

  //build list widget
  Widget txnListWidget(var height, MediaQueryData mediaQuery, isLandscape) {
    return SizedBox(
      height: (mediaQuery.size.height -
              _buildAppBar().preferredSize.height -
              mediaQuery.padding.top) *
          height,
      child: TransactionList(
          _userTransaction, _delTransaction, isLandscape ? 0.7 : 0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(
                  mediaQuery,
                  _buildAppBar(),
                  txnListWidget(_userTransaction.isEmpty ? 0.7 : 0.85,
                      mediaQuery, isLandscape)),
            if (!isLandscape)
              ..._buildPotraitContent(mediaQuery, _buildAppBar(),
                  txnListWidget(0.75, mediaQuery, isLandscape)),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: _buildAppBar() as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: _buildAppBar(),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showAddTransactionForm(),
              child: const Icon(Icons.add),
            ),
            floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: pageBody,
          );
  }
}
