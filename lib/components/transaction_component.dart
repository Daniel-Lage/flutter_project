import 'package:flutter/material.dart';
import 'package:flutter_project/models/transaction_model.dart';

class TransactionComponent extends StatelessWidget {
  final Transaction transaction;

  const TransactionComponent({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsGeometry.symmetric(vertical: 2),

    child: Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          width: 350,
          height: 50,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${transaction.id}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Você   ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      transaction.type == TransactionType.minus
                          ? Icons.remove
                          : Icons.arrow_back,
                    ),
                    Text(
                      '${transaction.value}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Icon(
                      transaction.type == TransactionType.minus
                          ? Icons.arrow_forward
                          : Icons.remove,
                    ),
                    Text(
                      '   ${transaction.personName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
