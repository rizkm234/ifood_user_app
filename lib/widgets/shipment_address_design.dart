import 'package:flutter/material.dart';
import 'package:ifood_user_app/main%20screens/home_screen.dart';
import 'package:ifood_user_app/models/address.dart';
class ShipmentAddressDesign extends StatelessWidget {
  final Address? model ;
  const ShipmentAddressDesign({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
              'Shipment Details: ' , style: TextStyle(
            color: Colors.black , fontWeight: FontWeight.bold
          ) ,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal:90 , vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    'Name:' ,
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    model!.name! ,
                    style: const TextStyle(color: Colors.black),
                  ),
                ]
              ),
              TableRow(
                  children: [
                    const Text(
                      'Phone Number:' ,
                      style: TextStyle(color: Colors.black),
                    ),
                    Text(
                      model!.phoneNumber! ,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ]
              ),
            ],
          ),
        ),
        const SizedBox(height: 6,),
         const Padding(
           padding: EdgeInsets.all(10.0),
           child: Text(
            'Full address:' ,
            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
        ),
         ),
         Padding(
           padding: const EdgeInsets.only(left: 10.0 , right: 10),
           child: Text(
            model!.fullAddress! ,
            style: const TextStyle(color: Colors.black),
        ),
         ),
        const SizedBox(height: 30,),
        Center(
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [Colors.cyan , Colors.amber ],
                      begin: FractionalOffset(0.0,0.0),
                      end: FractionalOffset(1.0,0.0),
                      stops: [0.0 , 1.0],
                      tileMode: TileMode.clamp,
                    ),
                ),
                width: MediaQuery.of(context).size.width - 40,
                height: 50,
                child: const Center(
                  child: Text(
                      'Go Back',
                  style: TextStyle(color: Colors.white , fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
