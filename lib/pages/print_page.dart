import 'dart:async';

import 'package:calendar_dashboard/responsive.dart';
import 'package:calendar_dashboard/model/plaque_model.dart';
import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:calendar_dashboard/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class PrintPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const PrintPage({super.key, required this.scaffoldKey});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  final textStyle = const TextStyle(fontSize: 32.0, height: 1.5);
  Timer? timmer;
  bool isTesting = false;

  final appController = Get.find<MyAppController>();
  HebrewDateFormatter hebrewDateFormatter = HebrewDateFormatter();

  @override
  void initState() {
    super.initState();
    plaqueList = appController.plaqueList;
    followingWeek();
    hebrewDateFormatter.hebrewFormat = true;
  }

  List<PlaqueModel> plaqueList = [];
  DateTime now = DateTime.now();

  wholeList() {
    plaqueList = appController.plaqueList;
    setState(() {});
  }

  void followingWeek() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    // Calculate the most recent Friday (including today if Friday)
    int daysSinceFriday = (today.weekday - DateTime.friday + 7) % 7;
    DateTime currentFriday = today.subtract(Duration(days: daysSinceFriday));

    // If today is Friday and it's NOT the same as the currentFriday, move to today
    if (today.weekday == DateTime.friday && today.isAfter(currentFriday)) {
      currentFriday = today;
    }

    // Define the 9-day range: Friday to next Sunday (inclusive)
    DateTime rangeStart = currentFriday;
    DateTime rangeEnd =
        rangeStart.add(Duration(days: 9)); // Exclusive of this date

    List<PlaqueModel> nineDayPlaques = appController.plaqueList.where((plaque) {
      DateTime dodDate = DateTime.parse(plaque.dod);
      return !dodDate.isBefore(rangeStart) && dodDate.isBefore(rangeEnd);
    }).toList();

    plaqueList = nineDayPlaques;
    setState(() {});
  }

  void generatePdf() async {
    final pdf = pw.Document();
    final malePlaques = plaqueList
        .where((plaque) => plaque.gender.toUpperCase() == 'MALE')
        .toList();
    final femalePlaques = plaqueList
        .where((plaque) => plaque.gender.toUpperCase() == 'FEMALE')
        .toList();

    final hebrewFont = pw.Font.ttf(
      await rootBundle.load('assets/fonts/Alef-Regular.ttf'),
    );

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Plaque List', style: const pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 20),
            if (plaqueList.isEmpty)
              pw.Text('No Plaques found')
            else
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Text('Male List',
                            style: const pw.TextStyle(fontSize: 18)),
                        pw.SizedBox(height: 20),
                        pw.Table(
                          border: pw.TableBorder.all(width: 2),
                          columnWidths: {
                            0: const pw.FlexColumnWidth(),
                            1: const pw.FlexColumnWidth(),
                            // 2: const pw.FlexColumnWidth(),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text('Name',
                                    textAlign: pw.TextAlign.center,
                                    style: const pw.TextStyle(fontSize: 20)),
                                pw.Text('Date',
                                    textAlign: pw.TextAlign.center,
                                    style: const pw.TextStyle(fontSize: 20)),
                                // pw.Text('Led',
                                //     textAlign: pw.TextAlign.center,
                                //     style: const pw.TextStyle(fontSize: 20)),
                              ],
                            ),
                            for (var plaque in malePlaques)
                              pw.TableRow(
                                children: [
                                  pw.Text(plaque.hebruname,
                                      textDirection: pw.TextDirection.rtl,
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: 16, font: hebrewFont)),
                                  pw.Text(
                                      hebrewDateFormatter.format(
                                          JewishDate.fromDateTime(
                                              DateTime.tryParse(
                                                  plaque.predate)!)),
                                      textDirection: pw.TextDirection.rtl,
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          font: hebrewFont,
                                          fontSize:
                                              16)), // Replace this with formatted date
                                  // pw.Text(plaque.led,
                                  //     textAlign: pw.TextAlign.center,
                                  //     style: const pw.TextStyle(fontSize: 16)),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 20),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Text('Female List',
                            style: const pw.TextStyle(fontSize: 18)),
                        pw.SizedBox(height: 20),
                        pw.Table(
                          border: pw.TableBorder.all(width: 2),
                          columnWidths: {
                            0: const pw.FlexColumnWidth(),
                            1: const pw.FlexColumnWidth(),
                            // 2: const pw.FlexColumnWidth(),
                          },
                          children: [
                            pw.TableRow(
                              children: [
                                pw.Text('Name',
                                    textAlign: pw.TextAlign.center,
                                    style: const pw.TextStyle(fontSize: 20)),
                                pw.Text('Date',
                                    textAlign: pw.TextAlign.center,
                                    style: const pw.TextStyle(fontSize: 20)),
                                // pw.Text('Led',
                                //     textAlign: pw.TextAlign.center,
                                //     style: const pw.TextStyle(fontSize: 20)),
                              ],
                            ),
                            for (var plaque in femalePlaques)
                              pw.TableRow(
                                children: [
                                  pw.Text(plaque.hebruname,
                                      textDirection: pw.TextDirection.rtl,
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          fontSize: 16, font: hebrewFont)),
                                  pw.Text(
                                      hebrewDateFormatter.format(
                                          JewishDate.fromDateTime(
                                              DateTime.tryParse(
                                                  plaque.predate)!)),
                                      textDirection: pw.TextDirection.rtl,
                                      textAlign: pw.TextAlign.center,
                                      style: pw.TextStyle(
                                          font: hebrewFont,
                                          fontSize:
                                              16)), // Replace this with formatted date
                                  // pw.Text(plaque.led,
                                  //     textAlign: pw.TextAlign.center,
                                  //     style: const pw.TextStyle(fontSize: 16)),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );

    // Save or share the PDF document
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Print Plaque',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: generatePdf,
              icon: const Icon(Icons.download_outlined)),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? 15 : 18),
            child: Column(
              children: [
                SizedBox(
                  height: Responsive.isMobile(context) ? 5 : 18,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () async {
                            followingWeek();
                          },
                          child: Container(
                              child: const Center(
                            child:
                                CustomCard(child: Text('Print Following Week')),
                          ))),
                      GestureDetector(
                          onTap: () async {
                            wholeList();
                          },
                          child: Container(
                              child: const Center(
                            child: CustomCard(child: Text('Print Whole List')),
                          ))),
                    ],
                  ),
                ),
                height(context),
                const Text(
                  'Plaque List',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                height(context),
                plaqueList.isEmpty
                    ? const Text('No Plaques found')
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text(
                                  'Male List',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Table(
                                  defaultColumnWidth: const FlexColumnWidth(),
                                  border: TableBorder.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  children: [
                                    const TableRow(children: [
                                      Column(children: [
                                        Text('Name',
                                            style: TextStyle(fontSize: 20.0))
                                      ]),
                                      Column(children: [
                                        Text('Date',
                                            style: TextStyle(fontSize: 20.0))
                                      ]),
                                      // Column(children: [
                                      //   Text('Led',
                                      //       style: TextStyle(fontSize: 20.0))
                                      // ]),
                                    ]),

                                    for (var plaque in plaqueList)
                                      if (plaque.gender.toUpperCase() == 'MALE')
                                        TableRow(children: [
                                          Column(
                                            children: [
                                              Text(plaque.hebruname,
                                                  style: const TextStyle(
                                                      fontSize: 16.0))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                  hebrewDateFormatter.format(
                                                      JewishDate.fromDateTime(
                                                          DateTime.tryParse(
                                                              plaque
                                                                  .predate)!)),
                                                  style: const TextStyle(
                                                      fontSize: 16.0))
                                            ],
                                          ),
                                          // Column(
                                          //   children: [
                                          //     Text(plaque.led,
                                          //         style: const TextStyle(
                                          //             fontSize: 16.0))
                                          //   ],
                                          // )
                                        ])

                                    // appController.plaqueList.map((element)=>TableRow()).toList()
                                    // TableRow(children: [
                                    //   Column(children: [Text('Javatpoint')]),
                                    //   Column(children: [Text('Flutter')]),
                                    //   Column(children: [Text('5*')]),
                                    // ]),
                                    // TableRow(children: [
                                    //   Column(children: [Text('Javatpoint')]),
                                    //   Column(children: [Text('MySQL')]),
                                    //   Column(children: [Text('5*')]),
                                    // ]),
                                    // TableRow(children: [
                                    //   Column(children: [Text('Javatpoint')]),
                                    //   Column(children: [Text('ReactJS')]),
                                    //   Column(children: [Text('5*')]),
                                    // ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text(
                                  'Female List',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Table(
                                  defaultColumnWidth: const FlexColumnWidth(),
                                  border: TableBorder.all(
                                      color: Colors.white,
                                      style: BorderStyle.solid,
                                      width: 2),
                                  children: [
                                    const TableRow(children: [
                                      Column(children: [
                                        Text('Name',
                                            style: TextStyle(fontSize: 20.0))
                                      ]),
                                      Column(children: [
                                        Text('Date',
                                            style: TextStyle(fontSize: 20.0))
                                      ]),
                                      // Column(children: [
                                      //   Text('Led',
                                      //       style: TextStyle(fontSize: 20.0))
                                      // ]),
                                    ]),

                                    for (var plaque in plaqueList)
                                      if (plaque.gender.toUpperCase() ==
                                          'FEMALE')
                                        TableRow(children: [
                                          Column(
                                            children: [
                                              Text(plaque.hebruname,
                                                  style: const TextStyle(
                                                      fontSize: 16.0))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                  hebrewDateFormatter.format(
                                                      JewishDate.fromDateTime(
                                                          DateTime.tryParse(
                                                              plaque
                                                                  .predate)!)),
                                                  style: const TextStyle(
                                                      fontSize: 16.0))
                                            ],
                                          ),
                                          // Column(
                                          //   children: [
                                          //     Text(plaque.led,
                                          //         style: const TextStyle(
                                          //             fontSize: 16.0))
                                          //   ],
                                          // )
                                        ])

                                    // appController.plaqueList.map((element)=>TableRow()).toList()
                                    // TableRow(children: [
                                    //   Column(children: [Text('Javatpoint')]),
                                    //   Column(children: [Text('Flutter')]),
                                    //   Column(children: [Text('5*')]),
                                    // ]),
                                    // TableRow(children: [
                                    //   Column(children: [Text('Javatpoint')]),
                                    //   Column(children: [Text('MySQL')]),
                                    //   Column(children: [Text('5*')]),
                                    // ]),
                                    // TableRow(children: [
                                    //   Column(children: [Text('Javatpoint')]),
                                    //   Column(children: [Text('ReactJS')]),
                                    //   Column(children: [Text('5*')]),
                                    // ]),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ))),
    );
  }
}
