// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vetpro/bloc/auth_new/bloc/auth_new_bloc.dart';
import 'package:vetpro/common/components/buttons.dart';
import 'package:vetpro/common/components/form.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/data/datasources/auth_local_datasource.dart';
import 'package:vetpro/data/models/user_model.dart';
import 'package:vetpro/views/auth/register_page.dart';
import 'package:vetpro/views/home/home_page.dart';

import '../../bloc/login/auth_bloc.dart';
import '../../common/constants/theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/vet-clinic.png',
              fit: BoxFit.fill,
              width: MediaQuery.of(context).size.width,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                margin: const EdgeInsets.all(15),
                child: Image.asset('assets/logo-telkom.png'),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2.5),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: "Welcome to ",
                          style: primaryTextStyle.copyWith(
                              fontSize: 35, fontWeight: bold),
                          children: [
                            TextSpan(
                              text: '\nVetpro',
                              style: secondaryTextStyle.copyWith(
                                fontSize: 35,
                                fontWeight: bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Veterinary Care in Your Pocket',
                        style: greyTextStyle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomFormField(
                      controller: emailController,
                      isShadow: false,
                      isBorder: true,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.person_outline_rounded,
                        color: greyColor,
                        size: 24,
                      ),
                      title: 'Email',
                      hintText: 'Email',
                      fillColor: greyColor.withOpacity(0.2),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomFormField(
                      controller: passwordController,
                      isShadow: false,
                      isBorder: true,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: greyColor,
                        size: 24,
                      ),
                      title: 'Password',
                      hintText: 'Password',
                      fillColor: greyColor.withOpacity(0.2),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: Text(
                          'Belum Punya Akun Silahkan Register',
                          style: primaryTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    BlocConsumer<AuthNewBloc, AuthNewState>(
                      listener: (context, state) {
                        state.maybeWhen(
                          orElse: () {},
                          loginUser: (credential) {
                            AuthLocalDatasource()
                                .saveAuthData(credential.data ?? UserData());
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return const HomePage();
                            }));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login Success'),
                                backgroundColor: greenColor,
                              ),
                            );
                          },
                          error: (message) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Center(
                                        child: Text('Pemberitahuan')),
                                    content: Text(
                                      message,
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                });
                          },
                        );
                      },
                      builder: (context, state) {
                        return state.maybeWhen(
                          orElse: () {
                            return CustomFilledButton(
                              width: 300,
                              height: 60,
                              borderRadius: 35,
                              onPressed: () {
                                final UserData userData = UserData(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                                context.read<AuthNewBloc>().add(
                                      AuthNewEvent.login(userData),
                                    );
                              },
                              title: 'Login',
                            );
                          },
                          loading: () {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
