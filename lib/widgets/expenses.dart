import 'package:flutter/material.dart';

import 'package:expense_tracker/model/expense.dart';
import 'package:expense_tracker/widgets/charts/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredData = [
    Expense(
        title: "Flutter Course",
        amount: 499,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: "Cinema",
        amount: 350,
        date: DateTime.now(),
        category: Category.leisure),
    Expense(
        title: "Bix",
        amount: 691822,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openModalOverlay() {
    showModalBottomSheet(
      useSafeArea: true, // Adjust content according to camera, speaker, etc.
      isScrollControlled: true,
      context: context,
      builder: (ctx) => NewExpense(onAddExpense: _addExpense),
    );
  }

  void _addExpense(Expense expense) {
    setState(
      () {
        _registeredData.add(expense);
      },
    );
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredData.indexOf(expense);
    setState(() {
      _registeredData.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: const Text("Expense deleted!"),
      action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredData.insert(expenseIndex, expense);
            });
          }),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    Widget mainContent =
        const Center(child: Text("No expenses found. Try adding some!!!"));

    if (_registeredData.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredData,
        onRemoveExpense: _removeExpense,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Expense-Tracker"),
        actions: [
          IconButton(
            onPressed: _openModalOverlay,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: width < 600
          ? Column(
              children: [
                Chart(expenses: _registeredData),
                Expanded(
                  child: mainContent,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Chart(expenses: _registeredData),
                ),
                Expanded(
                  child: mainContent,
                ),
              ],
            ),
    );
  }
}
