import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:vetpro/bloc/list_inspection/list_inspection_bloc.dart';
import 'package:vetpro/common/constants/colors.dart';
import 'package:vetpro/common/constants/theme.dart';
import 'package:vetpro/data/models/inspection_model.dart';
import 'package:vetpro/common/extensions/date_format_ext.dart';

import '../../common/components/list_card_widget.dart';
import '../../common/components/tab_menu_widget.dart';
import '../animal_inpection/detail_animal_inpection_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false; // Flag to toggle search bar

  @override
  void initState() {
    context.read<ListInspectionBloc>().add(const ListInspectionEvent.getInspection());
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _isSearching
                    ? Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search inspections...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      )
                    : Text(
                        'History',
                        style: primaryTextStyle.copyWith(fontSize: 40, fontWeight: bold),
                      ),
                IconButton(
                  icon: Icon(_isSearching ? Icons.close : Icons.search, size: 30),
                  onPressed: () {
                    setState(() {
                      if (_isSearching) {
                        _searchController.clear();
                        _searchQuery = '';
                      }
                      _isSearching = !_isSearching;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
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
                    // Filter the data based on search query
                    final filteredData = data.where((inspection) {
                      final lowerCaseQuery = _searchQuery.toLowerCase();
                      return inspection.animal.toLowerCase().contains(lowerCaseQuery) ||
                          inspection.location.toLowerCase().contains(lowerCaseQuery) ||
                          inspection.inspector.toLowerCase().contains(lowerCaseQuery);
                    }).toList();

                    // Sort the filtered data by date in descending order
                    filteredData.sort((a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

                    if (filteredData.isEmpty) {
                      return Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 500,
                        child: Center(
                          child: Text(
                            'No inspections found.',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: blackTextStyle.copyWith(fontSize: 16, fontWeight: bold),
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          final InspectionModel inspection = filteredData[index];
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Text(
                                DateTime.parse(inspection.date).formatDate(),
                                style: blackTextStyle.copyWith(fontSize: 18, fontWeight: bold),
                              ),
                              ListCardWidget(
                                color: secondaryColor,
                                flag: '2',
                                text1: inspection.animal,
                                text2: inspection.location,
                                text3: inspection.inspector,
                                image: 'assets/domba.png',
                                widget: InkWell(
                                  onTap: () => Get.to(DetailAnimalInpectionPage(inspectionModel: inspection)),
                                  child: Image.asset('assets/file.png'),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                );
              },
            )
          ],
        ),
        bottomNavigationBar: const TabMenuWidget(menu: '2'),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}