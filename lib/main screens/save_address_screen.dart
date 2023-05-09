import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ifood_user_app/global/global.dart';
import 'package:ifood_user_app/models/address.dart';
import 'package:ifood_user_app/widgets/simple_appBar.dart';
import 'package:ifood_user_app/widgets/text_field.dart';

class SaveAddressScreen extends StatelessWidget {
  final _name = TextEditingController();
  final _phoneNumber = TextEditingController();
  final _flatNumber = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _completeAddress = TextEditingController();
  final _locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Position? position;
  List<Placemark>? placeMarks;
  String fullAddress = '';
   SaveAddressScreen({Key? key}) : super(key: key);

  getCurrentLocation() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;
    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];
    fullAddress =
    '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';
    _locationController.text = fullAddress;
    _flatNumber.text = '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}';
    _city.text = '${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}';
    _state.text =  '${pMark.country}';
    _completeAddress.text = fullAddress;
    _name.text = sharedPreferences!.getString('name')!;
    print(fullAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(title: 'iFood',),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            //save address info to firestore
            if (formKey.currentState!.validate()){
              final model = Address(
                name: _name.text.trim(),
                phoneNumber: _phoneNumber.text.trim(),
                flatNumber: _flatNumber.text.trim(),
                city: _city.text.trim(),
                state: _state.text.trim(),
                fullAddress: _completeAddress.text.trim(),
                lat: position!.latitude,
                lang: position!.longitude,
              ).toJson();
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(sharedPreferences!.getString('uid'))
                  .collection('userAddress')
                  .doc(DateTime.now().millisecondsSinceEpoch.toString())
                  .set(model).then((value){
                    Fluttertoast
                        .showToast(
                        msg: 'New Address has been saved successfully.'
                    );
                    formKey.currentState!.reset();
              });
            }
          },
          label: const Text('Save Address'),
        icon: const Icon(Icons.save_alt_rounded , color: Colors.amber,),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children:  [
            const SizedBox(height: 6,),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:EdgeInsets.all(8),
              child: Text('Save New Address:',
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Acme'
              ),),
              ),
            ),
            ListTile(
              leading: const Icon(
                  Icons.person_pin_circle,
                color: Colors.amber,
                size: 35,
              ),
              title: Container(
                width: 250,
                child: TextFormField(
                  enabled: false,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'Your address ?',
                    hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: const MaterialStatePropertyAll<Color>(Colors.cyan),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: Colors.cyan)
                  )
                ),
              ),
                onPressed: (){
                //get Current location
                  getCurrentLocation();
                },
                icon: const Icon(Icons.location_on , color: Colors.amber,),
                label: const Text(
                  'Get My Location' ,
                  style: TextStyle(
                      color: Colors.white
                  ),
                )
            ),
            Form(
              key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: 'Name',
                      controller: _name,
                    ),
                    MyTextField(
                      hint: 'Phone',
                      controller: _phoneNumber,
                    ),
                    MyTextField(
                      hint: 'Flat Number',
                      controller: _flatNumber,
                    ),
                    MyTextField(
                      hint: 'City',
                      controller: _city,
                    ),
                    MyTextField(
                      hint: 'State / Country',
                      controller: _state,
                    ),
                    MyTextField(
                      hint: 'Complete Address',
                      controller: _completeAddress,
                    ),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}
