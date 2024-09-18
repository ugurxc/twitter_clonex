import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clonex/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:twitter_clonex/components/constant.dart';
import 'package:twitter_clonex/components/sign_textfield.dart';
import 'package:twitter_clonex/mobile_layout.dart';


class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? _errorMsg;
  bool signInRequired = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const FaIcon(FontAwesomeIcons.xTwitter)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: BlocListener<SignInBloc, SignInState>(
  listener: (context, state) {
        if(state is SignInSuccsess) {
					setState(() {
					  signInRequired = false;
					});
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MobileLayout(),));
				} else if(state is SignInProcess) {
					setState(() {
					  signInRequired = true;
					});
				} else if(state is SignInFailure) {
					setState(() {
					  signInRequired = false;
						_errorMsg = 'Invalid email or password';
					});
				}
          },
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(
                    flex: 5,
                  ),
                  const Text(
                    "Giriş Yap",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(
                    flex: 70,
                  ),
                  SizedBox(
                    height: 80,
                    child: SignTextfield(
                      errMessage: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "lütfen alanı doldurun";
                          } else if (!emailRexExp.hasMatch(val)) {
                            return "geçerli bir email adresi girin ";
                          }
                          return null;
                        },
                        labelText: "e-posta",
                        controller: emailController,
                        hintText: "e-posta",
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress),
                  ),
                  const Spacer(
                    flex: 5,
                  ),
                  SizedBox(
                    height: 80,
                    child: SignTextfield(
                        errMessage: _errorMsg,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'lütfen alanı doldurun';
                          } else if (!passwordRexExp.hasMatch(val)) {
                            return 'geçerli bir parola girin';
                          }
                          return null;
                        },
                        labelText: "Şifre",
                        controller: passwordController,
                        hintText: "Şifre",
                        obscureText: false,
                        keyboardType: TextInputType.text),
                  ),
                  const Spacer(
                    flex: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      !signInRequired
                          ? ElevatedButton(
                              style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<SignInBloc>()
                                      .add(SignInRequired(emailController.text, passwordController.text));
                                }
                              },
                              child: const Text(
                                "giriş yap",
                                style: TextStyle(color: Colors.white),
                              ))
                          : const CircularProgressIndicator(),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
