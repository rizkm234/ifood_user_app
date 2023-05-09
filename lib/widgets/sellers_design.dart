import 'package:flutter/material.dart';
import 'package:ifood_user_app/main%20screens/menus_screen.dart';
import 'package:ifood_user_app/models/sellers_model.dart';
import 'package:ifood_user_app/widgets/menus_design.dart';

class SellersDesignWidget extends StatefulWidget {
  Sellers? model ;
  BuildContext? context;
   SellersDesignWidget({Key? key ,
      this.model ,
      this.context
   }) : super(key: key);

  @override
  State<SellersDesignWidget> createState() => _SellersDesignWidgetState();
}

class _SellersDesignWidgetState extends State<SellersDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context, MaterialPageRoute(
            builder: (context)=>MenusScreen(
            model: widget.model,
        )));
      },
      splashColor: Colors.amber,
      child: Padding(
          padding: const EdgeInsets.all(5),
        child: Container(
          height: 300,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const SizedBox(height: 10,),
              Image.network(widget.model!.sellerAvatarUrl! ,
                height: 220,
              fit: BoxFit.cover,),
              const SizedBox(height: 1,),
              Text(widget.model!.sellerName! ,
                style: const TextStyle(
                  color: Colors.cyan,
                  fontSize: 20,
                  fontFamily: 'Train'
                ),
              ),
              Text(widget.model!.sellerEmail! ,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Divider(
                height: 4,
                thickness: 3,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
