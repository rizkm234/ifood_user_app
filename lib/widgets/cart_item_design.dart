import 'package:flutter/material.dart';
import 'package:ifood_user_app/models/items_model.dart';


class CartItemDesign extends StatefulWidget {
  final Items? model;
  BuildContext? context ;
  final int? QuantityNumber ;

  CartItemDesign ({this.model , this.context, this.QuantityNumber});

  @override
  State<CartItemDesign> createState() => _CartItemDesignState();
}

class _CartItemDesignState extends State<CartItemDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.cyan,
      child: Padding(
          padding: const EdgeInsets.only(left: 10 , bottom: 10, top: 2),
        child: SizedBox(
          height: 120,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.network(widget.model!.thumbnailUrl! ,fit: BoxFit.cover, width: 140 , height: 120,),
              const SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.model!.itemTitle!,
                    style: const TextStyle(
                        color: Colors.black ,
                        fontSize: 16,
                        fontFamily: 'Kiwi'
                    ),
                  ),
                  const SizedBox(height: 1,),
                  Row(
                    children: [
                      const Text(
                        'X ',
                        style: TextStyle(
                            color: Colors.black ,
                            fontSize: 20,
                            fontFamily: 'Acme'
                        ),
                      ),
                      Text(
                        widget.QuantityNumber.toString(),
                        style: const TextStyle(
                            color: Colors.black ,
                            fontSize: 20,
                            fontFamily: 'Acme'
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text(
                        'Price: ',
                        style: TextStyle(
                            fontSize: 15 ,
                            color: Colors.grey,
                        )
                      ),
                      const Text(
                          'EGP',
                          style: TextStyle(
                            fontSize: 16 ,
                            color: Colors.cyan,
                          )
                      ),
                      Text(
                          widget.model!.itemPrice.toString(),
                          style: const TextStyle(
                            fontSize: 16 ,
                            color: Colors.cyan,
                          )
                      ),
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
