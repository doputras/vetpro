import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vetpro/bloc/list_inspection/list_inspection_bloc.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/data/models/inspection_model.dart';

import '../../common/components/list_card_widget.dart';
import '../../common/components/tab_menu_widget.dart';
import '../animal_inpection/detail_animal_inpection_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    context
        .read<ListInspectionBloc>()
        .add(const ListInspectionEvent.getInspection());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'History',
                  style: primaryTextStyle.copyWith(
                    fontSize: 40,
                    fontWeight: bold,
                  ),
                ),
                const IconButton(
                    onPressed: null,
                    icon: Icon(
                      Icons.search,
                      size: 45,
                      color: Colors.black,
                    ))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            BlocBuilder<ListInspectionBloc, ListInspectionState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: primaryColor,
                      ),
                    );
                  },
                  loaded: (data) {
                    if (data.isEmpty) {
                      return Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 500,
                        child: Center(
                          child: Text(
                            'Tidak data inspection yang tersedia.',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: blackTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final InspectionModel inspection = data[index];
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  inspection.animal,
                                  style: blackTextStyle.copyWith(
                                    fontSize: 18,
                                    fontWeight: bold,
                                  ),
                                ),
                                ListCardWidget(
                                  color: secondaryColor,
                                  flag: '2',
                                  text1: inspection.animal,
                                  text2: 'Telkom University',
                                  text3: inspection.inspector,
                                  image: 'assets/domba.png',
                                  widget: InkWell(
                                      onTap: () =>
                                          Get.to(DetailAnimalInpectionPage(
                                            inspectionModel: inspection,
                                          )),
                                      child: Image.asset('assets/file.png')),
                                ),
                              ],
                            );
                          });
                    }
                  },
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: const TabMenuWidget(menu: '2'),
      ),
    );
  }
}
