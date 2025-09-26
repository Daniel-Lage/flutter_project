import 'package:flutter/material.dart';
import 'package:flutter_project/models/contact_model.dart';
import 'package:flutter_project/currency_input_formatter.dart';

class ContactComponent extends StatelessWidget {
  final Contact contact;
  final void Function()? delete;
  final void Function()? goTo;

  const ContactComponent({
    super.key,
    required this.contact,
    required this.delete,
    required this.goTo,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsGeometry.directional(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 10,
      children: <Widget>[
        GestureDetector(
          onTap: goTo,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            height: 50,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    contact.name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    CurrencyInputFormatter.formatter.format(contact.debt / 100),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(onPressed: delete, icon: Icon(Icons.remove)),
      ],
    ),
  );
}
