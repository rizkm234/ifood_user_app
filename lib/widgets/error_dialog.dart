import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  String? message;
   ErrorDialog({Key? key ,  this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
            child: const Center(
              child: Text('Ok'),
            ),
        )
      ],
    );
  }
}

