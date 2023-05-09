import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';
import '../global/global.dart';
import '../main screens/home_screen.dart';
import '../widgets/custom_textField.dart';
import '../widgets/error_dialog.dart';
import '../widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  // TextEditingController phoneController = TextEditingController();
  // TextEditingController locationController = TextEditingController();
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();
  // String completeAddress = '';

  // Position? position;
  // List<Placemark>? placeMarks;

  String sellerImageUrl = ' ';

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  // getCurrentLocation() async {
  //   LocationPermission permission;
  //   permission = await Geolocator.requestPermission();
  //   Position newPosition = await Geolocator.getCurrentPosition(
  //     desiredAccuracy: LocationAccuracy.high,
  //   );
  //   position = newPosition;
  //   placeMarks = await placemarkFromCoordinates(
  //     position!.latitude,
  //     position!.longitude,
  //   );
  //
  //   Placemark pMark = placeMarks![0];
  //   completeAddress =
  //       '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';
  //   locationController.text = completeAddress;
  //   print(completeAddress);
  // }

  Future<void> formValidation() async {
    if (imageXFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please Select an image.",
            );
          });
    } else {
      if (passwordController.text == confirmPasswordController.text) {
        if (confirmPasswordController.text.isNotEmpty &&
            emailController.text.isNotEmpty &&
            nameController.text.isNotEmpty
            // && phoneController.text.isNotEmpty &&
            // locationController.text.isNotEmpty
        ) {


          // start uploading image
          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialog(
                  message: "Registering Account",
                );
              });
          String filename = DateTime.now().microsecondsSinceEpoch.toString();

          fStorage.Reference reference =
            fStorage.FirebaseStorage.instance.ref().child('users').child(filename);

          fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
          fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){});
          await taskSnapshot.ref.getDownloadURL().then((url) {
            sellerImageUrl = url ;

          // saving data to firestore
            authSellerAndSignUp();

          });
        } else {
          showDialog(
              context: context,
              builder: (c) {
                return ErrorDialog(
                  message: "Please enter missing data.",
                );
              });
        }
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Password doesn't match.",
              );
            });
      }
    }
  }
  void authSellerAndSignUp() async {
    User? currentUser;
    await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim()).then((auth){
          currentUser = auth.user;
    }).catchError((error){
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null){
       saveDataToFirestore(currentUser!).then((value){
         Navigator.pop(context);
         //send user to home page
         Route newRoute = MaterialPageRoute(builder: (context) => const HomeScreen());
         Navigator.pushReplacement(context, newRoute);
       });
    }
  }


  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection('users').doc(currentUser.uid).set({
      'uid' : currentUser.uid,
      'email' : currentUser.email,
      'name' : nameController.text.trim(),
      'photoUrl' : sellerImageUrl,
      // 'phone' : phoneController.text.trim(),
      'status' : 'approved',
      'userCart' : ['fakeData'],
    });

    //save data locally
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString('uid', currentUser.uid);
    await sharedPreferences!.setString('name', nameController.text);
    await sharedPreferences!.setString('photoUrl', sellerImageUrl);
    // await sharedPreferences!.setString('phone', phoneController.text);
    await sharedPreferences!.setString('email', emailController.text);
    await sharedPreferences!.setStringList('userCart', ['fakeData']);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
              onTap: () {
                _getImage();
              },
              child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width * 0.20,
                  backgroundColor: Colors.white,
                  backgroundImage: imageXFile == null
                      ? null
                      : FileImage(File(imageXFile!.path)),
                  child: imageXFile == null
                      ? Icon(
                          Icons.add_photo_alternate,
                          size: MediaQuery.of(context).size.width * 0.20,
                          color: Colors.grey,
                        )
                      : null)),
          const SizedBox(
            height: 10,
          ),
          Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    controller: nameController,
                    data: Icons.person,
                    hintText: 'Name',
                    isObscure: false,
                    enabled: true,
                  ),
                  CustomTextField(
                    controller: emailController,
                    data: Icons.mail,
                    hintText: 'Email',
                    isObscure: false,
                    enabled: true,
                  ),
                  CustomTextField(
                    controller: passwordController,
                    data: Icons.lock,
                    hintText: 'Password',
                    isObscure: true,
                    enabled: true,
                  ),
                  CustomTextField(
                    controller: confirmPasswordController,
                    data: Icons.lock,
                    hintText: 'Confirm Password',
                    isObscure: true,
                    enabled: true,
                  ),
                  // CustomTextField(
                  //   controller: phoneController,
                  //   data: Icons.phone,
                  //   hintText: 'Phone number',
                  //   isObscure: false,
                  //   enabled: true,
                  // ),
                  // CustomTextField(
                  //   controller: locationController,
                  //   data: Icons.my_location,
                  //   hintText: 'My Current Address',
                  //   isObscure: false,
                  //   enabled: false,
                  // ),
                  // Container(
                  //   width: 400,
                  //   height: 40,
                  //   alignment: Alignment.center,
                  //   child: ElevatedButton.icon(
                  //     onPressed: () {
                  //       getCurrentLocation();
                  //     },
                  //     icon: const Icon(
                  //       Icons.location_on,
                  //       color: Colors.white,
                  //     ),
                  //     label: const Text(
                  //       'Get my current location',
                  //       style: TextStyle(color: Colors.white),
                  //     ),
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.amber,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(30),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              )),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              formValidation();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
