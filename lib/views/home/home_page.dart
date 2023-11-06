import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vetpro/bloc/logout/logout_bloc.dart';
import 'package:vetpro/common/components/buttons.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/views/animal_inpection/animal_inpection_page.dart';
import 'package:vetpro/views/auth/login_page.dart';
import '../../common/components/list_card_widget.dart';
import '../../common/components/tab_menu_widget.dart';
import '../../data/datasources/auth_local_datasource.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(right: 15, left: 15, bottom: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('assets/logo2.png'),
                  Image.asset('assets/logo-telkom.png'),
                ],
              ),
            ),
            Center(
              child: Text(
                'Inspection',
                style: primaryTextStyle.copyWith(
                  fontSize: 40,
                  fontWeight: extraBold,
                ),
              ),
            ),
            Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 15,
                ),
                height: MediaQuery.of(context).size.height / 1.3,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextButton(
                        title: 'Inspection Now!',
                        height: 60,
                        isShowIcon: false,
                        isShowSubTitle: false,
                        borderRadius: 20,
                        buttonColor: whiteColor,
                        colorText: blackColor,
                        textSize: 16,
                        onPressed: () {
                          Get.to(const AnimalInpectionPage());
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Inspection',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          ListCardWidget(
                            color: Colors.white,
                            flag: '1',
                            text1: 'Domba',
                            text2: '16 October 2023',
                            text3: 'Drs. Buhori Muslim',
                            image: 'assets/domba.png',
                            widget: InkWell(
                                // onTap: () =>
                                //     Get.to(const DetailAnimalInpectionPage()),
                                child: Image.asset('assets/file.png')),
                          ),
                        ],
                      )
                    ]))
          ],
        ),
        floatingActionButton: BlocConsumer<LogoutBloc, LogoutState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              loaded: (message) {
                AuthLocalDatasource().removeAuthData();
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return const LoginPage();
                }), (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: greenColor,
                  ),
                );
              },
              error: (message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                    backgroundColor: secondaryColor,
                  ),
                );
              },
            );
          },
          builder: (context, state) {
            return state.maybeWhen(orElse: () {
              return FloatingActionButton(
                onPressed: () {
                  context.read<LogoutBloc>().add(const LogoutEvent.logout());
                },
                backgroundColor: whiteColor,
                child: const Icon(
                  Icons.logout,
                  color: secondaryColor,
                ),
              );
            }, loading: () {
              return const Center(
                child: CircularProgressIndicator(
                  color: secondaryColor,
                ),
              );
            });
          },
        ),
        bottomNavigationBar: TabMenuWidget(
          menu: '1',
        ));
  }
}
