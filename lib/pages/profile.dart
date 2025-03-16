import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_shop/widgetstyle.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
  }


class _ProfileState extends State<Profile> {
  String username = '';

  getData() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String storedUsername = pref.getString('username') ?? 'sss';
  
  setState(() {
    username = storedUsername;
  });
}

  @override
  void initState() {
    super.initState();
    getData();
  }
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Container(
            height: size.height / 2 - 40,
            decoration: BoxDecoration(color: WidgetStyle.primary),
            child: Stack(
              children: [
                Container(
                  height: size.height / 2 - 50,
                ),
                Positioned.fill(
                    top: 10,
                    child: Container(
                      width: size.width,
                      height: size.height / 2 - 7,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 10,),
                              Container(height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                color: WidgetStyle.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.arrow_back,color: Colors.white, size: 45,),),
                              Expanded(child: SizedBox()),
                              Text(
                                'Profile',
                                style: TextStyle(color: Colors.white, fontSize: 40),
                                
                              ),
                              Expanded(child: SizedBox()),
                              SizedBox(width: 45,),
                            ],
                          ),
                          SizedBox(height: 25,),
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(30)
                            ),
                            child: Icon(Icons.person, size: 80, color: Colors.white,),
                          ),
                          SizedBox(height: 25,),

                          Text(
                                'name is : ${username}',
                                style: TextStyle(color: Colors.black, fontSize: 40),
                                
                              ),
                        ],
                      ),
                    ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
