import 'package:flutter/material.dart';
import 'package:ifood_user_app/assistant%20methods/address_changer.dart';
import 'package:ifood_user_app/main%20screens/placed_order_screen.dart';
import 'package:ifood_user_app/maps/maps.dart';
import 'package:ifood_user_app/models/address.dart';
import 'package:provider/provider.dart';

class AddressDesign extends StatefulWidget {
  final Address? model ;
  final int? currentIndex;
  final int? value;
  final String? addressID;
  final double? totalAmount;
  final String? sellerUID;

  AddressDesign({
    this.model,
    this.currentIndex,
    this.value,
    this.addressID,
    this.totalAmount,
    this.sellerUID
});

  @override
  State<AddressDesign> createState() => _AddressDesignState();
}

class _AddressDesignState extends State<AddressDesign> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Provider.of<AddressChanger>(
            context , listen: false
        ).displayResult(widget.value);
      },
      child: Card(
        color: Colors.black12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //address info
            Row(
              children: [
                Radio(
                    value: widget.value,
                    groupValue: widget.currentIndex,
                    activeColor: Colors.amber,
                    onChanged: (val){
                      //provider
                      Provider.of<AddressChanger>(
                          context , listen: false
                      ).displayResult(val);
                      print(val);
                    },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Table(
                        children: [
                          TableRow(
                            children: [
                              const Text('Name: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                              Text(widget.model!.name.toString()),
                            ]
                          ),
                          TableRow(
                            children: [
                              const Text('Phone: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                              Text(widget.model!.phoneNumber.toString()),
                            ]
                          ),
                          TableRow(
                            children: [
                              const Text('Flat Number: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                              Text(widget.model!.flatNumber.toString()),
                            ]
                          ),
                          TableRow(
                            children: [
                              const Text('City: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                              Text(widget.model!.city.toString()),
                            ]
                          ),
                          TableRow(
                            children: [
                              const Text('State: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                              Text(widget.model!.state.toString()),
                            ]
                          ),
                          TableRow(
                            children: [
                              const Text('Full Address: ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold
                              ),
                              ),
                              Text(widget.model!.fullAddress.toString()),
                            ]
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                //check on maps

              ],
            ),
            ElevatedButton(
              onPressed: (){
                MapsUtils.openMapWithPosition(
                    widget.model!.lat!, widget.model!.lang!
                );
                //MapsUtils.openMapWithAddress(widget.model!.fullAddress!);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
              ),
              child: const Text('Check on map' , style: TextStyle(color: Colors.white),),
            ),
            widget.value == Provider.of<AddressChanger>(context).count
                ?ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context)=> PlacedOrderScreen(
                          addressID: widget.addressID,
                          totalAmount: widget.totalAmount,
                          sellerUID : widget.sellerUID,
                        )));
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,),
                 child: const Text('Proceed', style: TextStyle(color: Colors.white)),
            )
                :Container()
          ],
        ),

      ),
    );
  }
}
