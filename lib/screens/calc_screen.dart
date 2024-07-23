import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'dart:math';

class CalcScreen extends StatefulWidget {
  @override
  _CalcScreenState createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  String displayValue = "0";
  String currentExpression = "";

  void onButtonClick(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        displayValue = "0";
        currentExpression = "";
      } else if (buttonText == "=") {
        try {
          Expression expr = Expression.parse(currentExpression);
          final evaluator = const ExpressionEvaluator();
          var result = evaluator.eval(expr, {});
          displayValue = result.toString();
          currentExpression = displayValue;
        } catch (e) {
          displayValue = "Error";
        }
      } else if (buttonText == "X") {
        if (currentExpression.isNotEmpty) {
          currentExpression =
              currentExpression.substring(0, currentExpression.length - 1);
          displayValue = currentExpression.isEmpty ? "0" : currentExpression;
        }
      } else if (buttonText == "√") {
        try {
          var result = sqrt(double.parse(currentExpression));
          displayValue = result.toString();
          currentExpression = displayValue;
        } catch (e) {
          displayValue = "Error";
        }
      } else if (buttonText == "^2") {
        try {
          var result = pow(double.parse(currentExpression), 2);
          displayValue = result.toString();
          currentExpression = displayValue;
        } catch (e) {
          displayValue = "Error";
        }
      } else {
        currentExpression += buttonText;
        displayValue = currentExpression;
      }
    });
  }

  Widget buildCalcButton(String buttonText, {Color color = Colors.white}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: OutlinedButton(
          onPressed: () => onButtonClick(buttonText),
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            backgroundColor: Colors.grey[800],
            side: BorderSide(color: color, width: 1),
            padding: EdgeInsets.all(16.0),
            textStyle: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Times New Roman',
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Text(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Times New Roman',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: EdgeInsets.symmetric(
                          vertical: 24.0, horizontal: 12.0),
                      child: Text(
                        displayValue,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 48.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Times New Roman',
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.backspace, color: Colors.orange),
                    onPressed: () => onButtonClick("X"),
                    iconSize: 30.0,
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCalcButton("C", color: Colors.red),
                      buildCalcButton("√", color: Colors.blue),
                      buildCalcButton("^2", color: Colors.blue),
                      buildCalcButton("/", color: Colors.blue),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCalcButton("7"),
                      buildCalcButton("8"),
                      buildCalcButton("9"),
                      buildCalcButton("*", color: Colors.blue),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCalcButton("4"),
                      buildCalcButton("5"),
                      buildCalcButton("6"),
                      buildCalcButton("-", color: Colors.blue),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCalcButton("1"),
                      buildCalcButton("2"),
                      buildCalcButton("3"),
                      buildCalcButton("+", color: Colors.blue),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCalcButton("."),
                      buildCalcButton("0"),
                      buildCalcButton("=", color: Colors.green),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
