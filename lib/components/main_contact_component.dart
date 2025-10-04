import 'package:flutter/material.dart';
import 'package:flutter_project/models/contact_model.dart';

class MainContactComponent extends StatelessWidget {
  final ContactObject? contact;

  const MainContactComponent({super.key, this.contact});

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
              child: contact == null
                  ? null
                  : Text(
                      contact!.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSecondary,
                        fontSize: 20,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
