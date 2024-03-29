import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mock_tradex/Buisness_logic/auth/bloc/auth_bloc.dart';
import 'package:mock_tradex/Data/Repositories/auth_repository.dart';
import 'package:mock_tradex/Presentation/Screens/front_page.dart';
import 'package:mock_tradex/Presentation/Screens/sign_in.dart';
import 'package:mock_tradex/constants.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? email;
  String? name;
  String? password;
  String? confirm;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context)),
      child: Scaffold(
        backgroundColor: const Color(0xff1F1A30),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Frontpage()));
            }

            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.Error)));
            }
          },
          builder: (context, state) {
            if (state is Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UnAuthenticated) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 100, left: 35),
                        child: Text(
                          'Create Account',
                          style: kTickerTextStyle.copyWith(fontSize: 35),
                        )),
                    Container(
                      margin: const EdgeInsets.only(left: 35, top: 5),
                      child: const Text('Please fill the input below',
                          style: kTickerSubTextStyle),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                left: 35, right: 35, top: 10),
                            margin: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              onChanged: (value) {
                                name = value;
                              },
                              validator: (userName) => userName!.isEmpty
                                  ? 'Name cannot be left blank'
                                  : null,
                              style: const TextStyle(color: Colors.blueAccent),
                              //scrollPadding: EdgeInsets.all(50),

                              decoration: InputDecoration(
                                  // disabledBorder: ,

                                  fillColor: const Color(0xff363144),
                                  hoverColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(20)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(20)),
                                  // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                                  labelText: 'Name',
                                  hintText: 'Name',
                                  labelStyle: const TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                  hintStyle: const TextStyle(
                                      color: Colors.blueAccent)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 35, right: 35, top: 10),
                            margin: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              onChanged: (value) {
                                email = value;
                              },
                              validator: (email) => email != null &&
                                      !RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                                          .hasMatch(email)
                                  ? 'Enter a valid email id'
                                  : null,
                              style: const TextStyle(color: Colors.blueAccent),
                              //scrollPadding: EdgeInsets.all(50),

                              decoration: InputDecoration(
                                  // disabledBorder: ,

                                  fillColor: const Color(0xff363144),
                                  hoverColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(20)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(20)),
                                  // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                                  labelText: 'E-mail',
                                  hintText: 'E-mail',
                                  labelStyle: const TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                  hintStyle: const TextStyle(
                                      color: Colors.blueAccent)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 35, right: 35, top: 10),
                            margin: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              onChanged: (value) {
                                password = value;
                              },

                              validator: (password) => password!.length < 8
                                  ? "Password length must be atleast 8 characters"
                                  : null,

                              obscureText: true,
                              style: const TextStyle(color: Colors.blueAccent),
                              //scrollPadding: EdgeInsets.all(50),

                              decoration: InputDecoration(
                                  // disabledBorder: ,

                                  fillColor: Color(0xff363144),
                                  hoverColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(20)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(20)),
                                  // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                                  labelText: 'Password',
                                  hintText: 'Password',
                                  labelStyle: const TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                  hintStyle: const TextStyle(
                                      color: Colors.blueAccent)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 35, right: 35, top: 10),
                            margin: const EdgeInsets.only(top: 10),
                            child: TextFormField(
                              onChanged: (value) {
                                confirm = value;
                              },
                              validator: (confirmPassword) => password !=
                                      confirm
                                  ? 'Doesn\'t matches with the above entered password'
                                  : null,
                              obscureText: true,

                              style: const TextStyle(color: Colors.blueAccent),
                              //scrollPadding: EdgeInsets.all(50),

                              decoration: InputDecoration(
                                  // disabledBorder: ,

                                  fillColor: const Color(0xff363144),
                                  hoverColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(20)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Colors.blueAccent),
                                      borderRadius: BorderRadius.circular(20)),
                                  // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
                                  labelText: 'Confirm Password',
                                  hintText: 'Confirm Password',
                                  labelStyle: const TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                  hintStyle: const TextStyle(
                                      color: Colors.blueAccent)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 40),
                          //color: Colors.blueAccent,
                          height: 60,
                          width: 120,
                          child: TextButton(
                            style: ButtonStyle(
                              // padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(15)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueAccent),
                              // foregroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              )),
                            ),
                            onPressed: () {
                              final isValidForm =
                                  formKey.currentState!.validate();
                              if (isValidForm) {
                                BlocProvider.of<AuthBloc>(context)
                                    .add(SignUpRequested(name, email, confirm));
                              }
                            },
                            child:
                                const Text('Sign Up', style: kTickerTextStyle),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have a account? ',
                          style: kTickerTextStyle,
                        ),
                        GestureDetector(
                          child: Text(
                            'Log In',
                            style: kTickerTextStyle.copyWith(
                                color: Colors.blueAccent),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignIn(),
                              ),
                            );
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
