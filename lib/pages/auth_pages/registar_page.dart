/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clonex/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:twitter_clonex/components/constant.dart';
import 'package:twitter_clonex/components/sign_textfield.dart';
import 'package:twitter_clonex/main.dart';

class RegistarPage extends StatefulWidget {
  const RegistarPage({super.key});

  @override
  State<RegistarPage> createState() => _RegistarPageState();
}

class _RegistarPageState extends State<RegistarPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool signInRequired=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const FaIcon(FontAwesomeIcons.xTwitter)
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 5,),
                const Text("Giriş Yap" ,style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),),
                const Spacer(flex: 70,),
              
                SizedBox(
                  height: 80,
                  child: SignTextfield(
                    validator: (val){
                      if(val!.isEmpty){
                        return "lütfen alanı doldurun";
                      }
                      else if(!emailRexExp.hasMatch(val)){
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
              const Spacer(flex: 5,),
                SizedBox(
                  height: 80,
                  child: SignTextfield(
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
                const Spacer(flex: 100,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    !signInRequired ?
                    ElevatedButton(
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.black)),
                      onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignInBloc>().add(SignInRequired(
                          emailController.text,
                          passwordController.text
                        ));
                  }
                    }, child: const Text("giriş yap", style: TextStyle(color: Colors.white),))
                    : const CircularProgressIndicator(),
                  ],
                )
              ],
            )),
      ),
    );
  }
} */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clonex/blocs/auth_bloc/auth_bloc.dart';
import 'package:twitter_clonex/blocs/sign_up_bloc/sign_up_bloc.dart';
import 'package:twitter_clonex/components/constant.dart';
import 'package:twitter_clonex/components/sign_textfield.dart';
import 'package:twitter_clonex/mobile_layout.dart';

import 'package:user_repository/user_repository.dart';

class RegistarPage extends StatefulWidget {
  const RegistarPage({super.key});

  @override
  State<RegistarPage> createState() => _RegistarPageState();
}

class _RegistarPageState extends State<RegistarPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  final nameController = TextEditingController();
  bool signUpRequired = false;

  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const FaIcon(FontAwesomeIcons.xTwitter),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: BlocListener<AuthBloc, AuthState>(
			listener: (context, state) {
				if(state is SignUpSuccsess) {
					setState(() {
					  signUpRequired = false;

					});
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MobileLayout(),));
				} else if(state is SignUpProcess) {
					setState(() {
					  signUpRequired = true;
					});
				} else if(state is SignUpFailure) {
					return;
				} 
            },
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      "Hesabını Oluştur",
                      style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: SignTextfield(
                          labelText: "Email",
                          controller: emailController,
                          hintText: 'Email',
                          obscureText: false,
                          keyboardType: TextInputType.emailAddress,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'bu alanı doldurun';
                            } else if (!emailRexExp.hasMatch(val)) {
                              return 'geçerli email hesabı girin';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: SignTextfield(
                          labelText: "Parola",
                          controller: passwordController,
                          hintText: 'Parola',
                          obscureText: obscurePassword,
                          keyboardType: TextInputType.visiblePassword,
                          onChanged: (val) {
                            if (val!.contains(RegExp(r'[A-Z]'))) {
                              setState(() {
                                containsUpperCase = true;
                              });
                            } else {
                              setState(() {
                                containsUpperCase = false;
                              });
                            }
                            if (val.contains(RegExp(r'[a-z]'))) {
                              setState(() {
                                containsLowerCase = true;
                              });
                            } else {
                              setState(() {
                                containsLowerCase = false;
                              });
                            }
                            if (val.contains(RegExp(r'[0-9]'))) {
                              setState(() {
                                containsNumber = true;
                              });
                            } else {
                              setState(() {
                                containsNumber = false;
                              });
                            }
                            if (val.contains(specialCharRexExp)) {
                              setState(() {
                                containsSpecialChar = true;
                              });
                            } else {
                              setState(() {
                                containsSpecialChar = false;
                              });
                            }
                            if (val.length >= 8) {
                              setState(() {
                                contains8Length = true;
                              });
                            } else {
                              setState(() {
                                contains8Length = false;
                              });
                            }
                            return null;
                          },
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'bu alanı doldurun';
                            } else if (!passwordRexExp.hasMatch(val)) {
                              return 'geçerli bir parola girin';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "⚈  1 uppercase",
                              style: TextStyle(
                                  color: containsUpperCase ? Colors.green : Theme.of(context).colorScheme.onSurface),
                            ),
                            Text(
                              "⚈  1 lowercase",
                              style: TextStyle(
                                  color: containsLowerCase ? Colors.green : Theme.of(context).colorScheme.onSurface),
                            ),
                            Text(
                              "⚈  1 number",
                              style: TextStyle(
                                  color: containsNumber ? Colors.green : Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "⚈  1 special character",
                              style: TextStyle(
                                  color: containsSpecialChar ? Colors.green : Theme.of(context).colorScheme.onSurface),
                            ),
                            Text(
                              "⚈  8 minimum character",
                              style: TextStyle(
                                  color: contains8Length ? Colors.green : Theme.of(context).colorScheme.onSurface),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: SignTextfield(
                          labelText: "İsim",
                          controller: nameController,
                          hintText: 'İsim',
                          obscureText: false,
                          keyboardType: TextInputType.name,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'bu alanı doldurun';
                            } else if (val.length > 30) {
                              return 'çok uzun isim';
                            }
                            return null;
                          }),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                    !signUpRequired
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    MyUser myUser = MyUser.empty;
                                    myUser = myUser.copyWith(
                                      email: emailController.text,
                                      name: nameController.text,
                                    );

                                    setState(() {
                                      context.read<AuthBloc>().add(SignUpRequired(myUser, passwordController.text));
                                    });
                                  }
                                },
                                style: TextButton.styleFrom(
                                  elevation: 3.0,
                                  backgroundColor: Colors.black,
                                ),
                                child: const Text(
                                  'Kayıt ol',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                )),
                          )
                        : const CircularProgressIndicator()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
