import 'package:flutter/material.dart';
import 'package:ifood_user_app/global/global.dart';
import 'package:ifood_user_app/main%20screens/address_screen.dart';
import 'package:ifood_user_app/main%20screens/history_screen.dart';
import 'package:ifood_user_app/main%20screens/home_screen.dart';
import 'package:ifood_user_app/main%20screens/my_orders_screen.dart';
import 'package:ifood_user_app/main%20screens/save_address_screen.dart';
import 'package:ifood_user_app/main%20screens/search_screen.dart';

import '../authentication/auth_screen.dart';
import 'error_dialog.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.amber,
      child: ListView(
        children: [
          // header
          Container(
            padding: const EdgeInsets.only(top: 25, bottom: 10),
            child: Column(
              children:  [
                //header drawer
                Material(
                  borderRadius: const BorderRadius.all(Radius.circular(80)),
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Container(
                      height: 160,
                        width: 160,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(
                            sharedPreferences!.getString('photoUrl')!
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Text(sharedPreferences!.getString('name')! ,
                  style: const TextStyle(
                      color: Colors.black ,
                      fontSize: 30,
                      fontFamily: 'Train'
                  ),
                ),
                Text(sharedPreferences!.getString('email')! ,
                  style: const TextStyle(
                      color: Colors.black ,
                      fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12,),
          // body
          Container(
            padding: const EdgeInsets.only(top: 1),
            child: Column(
              children:  [
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.home , color: Colors.black,size:30),
                  title: const Text(
                    'Home',
                    style: TextStyle(
                        color: Colors.black,
                    ),
                  ),
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.reorder, color: Colors.black,size:30),
                  title: const Text(
                    'My Orders',
                    style: TextStyle(
                        color: Colors.black,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const MyOrdersScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.access_time , color: Colors.black,size:30),
                  title: const Text(
                    'History',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  const HistoryScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.search , color: Colors.black,size:30),
                  title: const Text(
                    'Search',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  const SearchScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.add_location , color: Colors.black,size:30),
                  title: const Text(
                    'Add New Address',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>  SaveAddressScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
                ListTile(
                  leading: const Icon(Icons.exit_to_app , color: Colors.black,size:30,),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onTap: (){
                    firebaseAuth.signOut().then((value){
                      Navigator
                          .pushReplacement(
                          context, MaterialPageRoute(
                          builder: (context)=> const AuthScreen()));
                    }).catchError((err){
                      showDialog(
                          context: context,
                          builder: (c) {
                            return ErrorDialog(
                              message: err.message.toString(),
                            );
                          });
                    });
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
