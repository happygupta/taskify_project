import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../main.dart';
import '../home.dart';

class SignUp extends StatefulWidget {
  // final Function() onClickedSignIn;

  // const SignUp({
  //   Key? key,
  //   required this.onClickedSignIn,
  // }) : super(key: key);

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List images = ["go.png"];

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: formKey,
        child: Column(children: [
          SizedBox(height: 70),
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: h * 0.18,
                ),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage("assets/avatar.jpg"),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 65),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 7,
                          blurRadius: 10,
                          offset: Offset(1, 1),
                          color: Colors.deepOrangeAccent.withOpacity(0.1))
                    ]),
                
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? '          Enter a valid email'
                          : null,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: 'Enter Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.deepOrange,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0))),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 7,
                          blurRadius: 10,
                          offset: Offset(1, 1),
                          color: Colors.deepOrangeAccent.withOpacity(0.1))
                    ]),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6
                      ? '          Enter min 6 characters'
                      : null,
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Enter Password',
                      prefixIcon: Icon(
                        Icons.password,
                        color: Colors.deepOrange,
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0))),
                ),
              ),
            ]),
          ),
          SizedBox(height: 55),
          Container(
            width: 230,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.deepOrangeAccent],
              ),
            ),
            child: MaterialButton(
              minWidth: 230,
              height: 50,
              onPressed: () {
                sign();
              },
              child: Text(
                "SignUp",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          RichText(
              text: TextSpan(
                  recognizer: TapGestureRecognizer()..onTap = () => Get.back(),
                  text: "Have an account?",
                  style: TextStyle(fontSize: 17, color: Colors.deepOrange))),
          SizedBox(height: w * 0.08),
          RichText(
              text: TextSpan(
            text: "SignUp using on the following method",
            style: TextStyle(
                fontSize: 16, color: Color.fromARGB(165, 255, 109, 64)),
          )),
          Wrap(
            children: List<Widget>.generate(1, (index) {
              return Padding(
                padding: const EdgeInsets.all(10),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage("assets/" + images[index]),
                  backgroundColor: Colors.white,
                ),
              );
            }),
          )
        ]),
      ),
    );
  }

  Future sign() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      move_();
    } on FirebaseAuthException catch (e) {
    
      var snackbar = Get.snackbar("Error", "Something went Wrong. Try again",
      
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent.withOpacity(0.5));
      
    }
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  void move_() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Something went Wront!'));
              } else {
                return HomePage();
              }
            })));
  }
}
