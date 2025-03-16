import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_shop/Auth/login.dart';
import 'package:tech_shop/widgetstyle.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  GlobalKey<FormFieldState<String>> emailValid = GlobalKey();
  GlobalKey<FormFieldState<String>> passValid = GlobalKey();

  @override
  Widget build(BuildContext context) {
    bool isPassHide = true;
    @override
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Tech Shop',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: WidgetStyle.primary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: size.height * 0.3,
              child: Image.asset('assets/images/logo.jpg'),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: userNameController,
              decoration: InputDecoration(
                hintText: 'Username',
                suffix: Icon(
                  Icons.person,
                  color: WidgetStyle.primary,
                ),
                focusedBorder: Border(),
                enabledBorder: Border(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: emailController,
              validator: (value) {
                return value != null && !value.contains('@')
                    ? 'it must contain @'
                    : null;
              },
              key: emailValid,
              decoration: InputDecoration(
                hintText: 'Email',
                suffix: Icon(
                  Icons.email,
                  color: WidgetStyle.primary,
                ),
                focusedBorder: Border(),
                enabledBorder: Border(),
                errorBorder: Border(),
                disabledBorder: Border(),
                focusedErrorBorder: Border(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passController,
              validator: (value) => value != null && value.length < 6
                  ? 'it must be at least 6 characters long'
                  : null,
              key: passValid,
              obscureText: isPassHide,
              enabled: true,
              decoration: InputDecoration(
                hintText: 'Password',
                suffix: IconButton(
                    onPressed: () {
                      setState(() {
                        isPassHide = !isPassHide;
                      });
                    },
                    icon: Icon(
                      // ignore: dead_code
                      isPassHide ? Icons.visibility : Icons.visibility_off,
                    )),
                focusedBorder: Border(),
                enabledBorder: Border(),
                errorBorder: Border(),
                disabledBorder: Border(),
                focusedErrorBorder: Border(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: WidgetStyle.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            )),
                        onPressed: () async{
                          if(emailValid.currentState!.validate() &&
                            passValid.currentState!.validate()) {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                              pref.setString('username', userNameController.text);
                              pref.setString('email', emailController.text);
                              pref.setString('pass', passController.text);
                              Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login(),));
                        }
                        },
                        child: Text(
                          'Create a new account',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ))),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => Login(),));
                  },
                  child: Text('I have an account'
                  ,style: TextStyle(color: WidgetStyle.primary),),
                )
              ],
            ),
          ],
        ),
      ),
    ));
  }

  OutlineInputBorder Border() {
    return OutlineInputBorder(
      borderSide: BorderSide(color: WidgetStyle.primary, width: 2),
      borderRadius: BorderRadius.circular(20),
    );
  }
}
