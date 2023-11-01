// ignore_for_file: unused_shown_name, duplicate_ignore

import 'package:flutter/material.dart'
    // ignore: duplicate_ignore
    show
        Alignment,
        AlwaysScrollableScrollPhysics,
        AnnotatedRegion,
        BorderRadius,
        BoxFit,
        BuildContext,
        Colors,
        Column,
        Container,
        CrossAxisAlignment,
        EdgeInsets,
        FocusScope,
        FontWeight,
        Form,
        FormState,
        GestureDetector,
        GlobalKey,
        Icon,
        Icons,
        Image,
        InputBorder,
        InputDecoration,
        Key,
        MainAxisAlignment,
        // ignore: unused_shown_name
        Padding,
        Positioned,
        ElevatedButton,
        RichText,
        RoundedRectangleBorder,
        // ignore: unused_shown_name
        Row,
        Scaffold,
        SingleChildScrollView,
        SizedBox,
        Stack,
        State,
        StatefulWidget,
        Text,
        TextAlign,
        // ignore: unused_shown_name
        TextButton,
        TextFormField,
        TextInputType,
        TextSpan,
        TextStyle,
        Theme,
        // ignore: unused_shown_name
        ThemeData,
        Widget,
        debugPrint;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/auth.dart';
import '../../shared/loading.dart';
import '../../utilities/constants.dart';

class SignIn extends StatefulWidget {
  final Function? toggleView;

  const SignIn({Key? key, this.toggleView}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = "";
  String password = "";

  String error = '';

  Widget _buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Email",
          style: kLabelStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: kBoxDecorationStyle,
          alignment: Alignment.centerLeft,
          child: TextFormField(
            onChanged: (val) {
              setState(() => email = val);
            },
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(color: Colors.black54),
            decoration: const InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.black54,
                ),
                labelText: "Enter your email",
                hintStyle: kHintTextStyle),
          ),
        )
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          "Password",
          style: kLabelStyle,
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          decoration: kBoxDecorationStyle,
          alignment: Alignment.centerLeft,
          child: TextFormField(
            onChanged: (val) {
              setState(() => password = val);
            },
            obscureText: true,
            style: const TextStyle(color: Colors.black54),
            decoration: const InputDecoration(
                errorStyle: TextStyle(fontSize: 15),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14.0, horizontal: 14.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.black54,
                ),
                hintText: "Enter your password",
                hintStyle: kHintTextStyle),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
      ),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Theme.of(context).primaryColor,
        ),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() => loading = true);
            await context
                .read<Auth>()
                .signInWithEmailAndPassword(email: email, password: password)
                .catchError((exception) => setState(() {
                      error =
                          "Email or password is incorrect! Please try again or reset your password.";

                      loading = false;
                    }));
          }
        },
        child: const Text(
          "LOGIN",
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Comfortaa",
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton() {
    return GestureDetector(
      onTap: () {
        dynamic toggleView;
        toggleView = toggleView;
        widget.toggleView!();
      },
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an account? ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Image.asset(
                        "assets/background-wave.png",
                        fit: BoxFit.fitWidth,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                    SizedBox(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 120.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: const <Widget>[
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    "Welcome Back",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: "OpenSans",
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  _buildEmail(),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  _buildPassword(),
                                  _buildLoginBtn(),
                                  Text(
                                    error,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 16.0),
                                  ),
                                  const SizedBox(
                                    height: 13.0,
                                  ),
                                ],
                              ),
                            ),
                            _buildSignUpButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
