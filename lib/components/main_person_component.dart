import 'package:flutter/material.dart';
import 'package:flutter_project/models/person_model.dart';

class MainPersonComponent extends StatelessWidget {
  final Person? person;

  const MainPersonComponent({super.key, this.person});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,

      decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondary),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 310,
            height: 50,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 17),
              child: person == null
                  ? null
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          person!.name,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Dívida: ${person!.debt}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
