import 'package:flutter/material.dart';
import 'package:flutter_project/models/person_model.dart';

class PersonComponent extends StatelessWidget {
  final Person person;
  final void Function()? delete;

  const PersonComponent({
    super.key,
    required this.person,
    required this.delete,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsetsGeometry.symmetric(vertical: 2),

    child: Row(
      spacing: 10,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/person', arguments: person);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            width: 300,
            height: 50,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    person.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                  Text(
                    '${person.debt}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
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
