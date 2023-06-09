import 'package:flutter/material.dart';
import 'package:ifood_user_app/widgets/progress_bar.dart';


class LoadingDialog extends StatelessWidget {

  String? message;

  LoadingDialog({Key? key,required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(height: 10,),
          Text('${message!} Please wait.....'),
        ],
      ),
    );
  }
}
