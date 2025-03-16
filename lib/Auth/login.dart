import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tech_shop/Auth/signup.dart';
import 'package:tech_shop/main.dart';
import 'package:tech_shop/widgetstyle.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  GlobalKey<FormFieldState<String>> emailValid = GlobalKey();
  GlobalKey<FormFieldState<String>> passValid = GlobalKey();

  bool isPassHide = true;
  @override
  Widget build(BuildContext context) {
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
      body: Expanded(
        child: Padding(
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
                decoration: InputDecoration(
                  hintText: 'Password',
                  suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          isPassHide = !isPassHide;
                        });
                      },
                      icon: Icon(
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
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: WidgetStyle.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      onPressed: () async {
                        if (emailValid.currentState!.validate() &&
                            passValid.currentState!.validate()) {
                          SharedPreferences pref = await SharedPreferences.getInstance();

                          String email = pref.getString('email')?? 'error';
                          String pass = pref.getString('pass')?? 'error';
                          if(email != 'error' && pass != 'error') {

                                if(emailController.text == email && passController.text == pass) {
                                  pref.setBool('isLogin', true);
                                  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => BottomNavigation(),));
                                }else{
                                  showDialog(context: context, builder: (context) => AlertDialog(
                                  content: Container(
                                    height: 100,
                                    child: Column(
                                      children: [Text('Username Or Password wrong'),
                                      Expanded(child: SizedBox()),
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text("OK"))],
                                    ),
                                  ),
                                ),);
                                }

                              }else{
                                showDialog(context: context, builder: (context) => AlertDialog(
                                  content: Container(
                                    height: 100,
                                    child: Column(
                                      children: [Text('Create an account First'),
                                      Expanded(child: SizedBox()),
                                      TextButton(onPressed: (){
                                        Navigator.pop(context);
                                      }, child: Text("OK"))],
                                    ),
                                  ),
                                ),);
                              }
                        } else {}
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ))),
              SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot your password?',
                    style: TextStyle(color: WidgetStyle.primary),
                  )),
              Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'do not have account?',
                        style: TextStyle(color: Colors.black),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Signup(),
                            ));
                      },
                      child: Text(
                        'Create Account',
                        style: TextStyle(color: WidgetStyle.primary),
                      )),
                ],
              ),
            ],
          ),
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
