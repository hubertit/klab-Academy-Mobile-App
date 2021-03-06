import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'InputDeco_design.dart';
import 'signin.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmpassword = TextEditingController();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 70,

                  child: Image.asset("assets/klab.png"),
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _name,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.person, "Full Name"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please enter name";
                      }
                      return null;
                    },
                    onSaved: (String name) {},
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.email, "Email"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please enter  email";
                      }
                      if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                          .hasMatch(value)) {
                        return "Please enter valid email";
                      }
                      return null;
                    },
                    onSaved: (String email) {},
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.number,
                    decoration: buildInputDecoration(Icons.phone, "Phone No"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please enter  phone";
                      }
                      if (value.length < 10) {
                        return "Please enter valid phone";
                      }
                      return null;
                    },
                    onSaved: (String phone) {},
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _password,
                    keyboardType: TextInputType.text,
                    decoration: buildInputDecoration(Icons.lock, "Password"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please enter password";
                      }

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 15, left: 10, right: 10),
                  child: TextFormField(
                    controller: _confirmpassword,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    decoration:
                        buildInputDecoration(Icons.lock, "Confirm Password"),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please enter re-password";
                      }
                      if (_password.text != _confirmpassword.text) {
                        return "Password Do not match";
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: 400,
                  height: 50,
                  child: RaisedButton(
                    color: const Color(0xFF2B5894),
                    onPressed: () {
                      if (_formkey.currentState.validate()) {
                        RegistrationUser();
                        print("Successful");
                      } else {
                        print("Unsuccessfull");
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.blue, width: 2)),
                    textColor: Colors.white,
                    child: Text("Submit"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future RegistrationUser() async {
    // url to registration php script

    var url = Uri.http(
        'localhost', '/klab/api/members/register.php', {'q': '{http}'});

    //json maping user entered details
    Map mapeddate = {
      'category_id': "1",
      'member_fname': _name.text,
      'member_lname': _name.text,
      'member_email': _email.text,
      'member_phone': _phone.text,
      'password': _password.text
    };

    //send  data using http post to our php code
    http.Response reponse = await http.post(url, body: mapeddate);

    //getting response from php code, here
    var data = jsonDecode(reponse.body);
    //print("DATA: ${data}");

    if(data["code"] ==200)
      {
        var message = data["message"];
        print(message);

        final snackBar = SnackBar(
          content: Text(message),
          action: SnackBarAction(
            label: 'Signin',
            onPressed: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context)=> SigninScreen()));
            },
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.push(context, CupertinoPageRoute(builder: (context)=> SigninScreen()));

      }else{
      var message = data["message"];
      print(message);

      final snackBar = SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {

          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }



  }
}
