import 'package:calendar_dashboard/network/app_controller.dart';
import 'package:calendar_dashboard/pages/add_relative/add_relative.dart';
import 'package:calendar_dashboard/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:calendar_dashboard/responsive.dart';
import 'package:get/get.dart';
import 'package:kosher_dart/kosher_dart.dart';
import 'package:intl/intl.dart';

class PlaqueDetailPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int index;
  final bool isMale;

  const PlaqueDetailPage(
      {super.key,
      required this.index,
      required this.isMale,
      required this.scaffoldKey});

  @override
  State<PlaqueDetailPage> createState() => _PlaqueDetailPageState();
}

class _PlaqueDetailPageState extends State<PlaqueDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getPlaques();
    hebrewDateFormatter.hebrewFormat = true;
  }

  HebrewDateFormatter hebrewDateFormatter = HebrewDateFormatter();
  final appController = Get.find<MyAppController>();

  @override
  Widget build(BuildContext context) {
    SizedBox height(BuildContext context) => SizedBox(
          height: Responsive.isDesktop(context) ? 30 : 20,
        );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plaque Details',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        centerTitle: true,
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
                height(context),
                Container(
                  margin: const EdgeInsets.only(top: 5, bottom: 5),
                  child: CustomCard(
                      child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      // maxWidth: 200,
                      minWidth: 100,
                      // maxHeight: 60,
                      minHeight: 40,
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text(
                                  "Name: ${widget.isMale ? appController.maleList[widget.index].hebruname : appController.femaleList[widget.index].hebruname}"),
                            ),
                            Obx(
                              () => Text(
                                  "Led: ${widget.isMale ? appController.maleList[widget.index].led : appController.femaleList[widget.index].led}"),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => Text(
                                  "Hebrew Date: ${hebrewDateFormatter.format(JewishDate.fromDateTime(DateTime.parse(widget.isMale ? appController.maleList[widget.index].dod : appController.femaleList[widget.index].dod)))}"),
                            ),
                            Obx(
                              () => Text(
                                  "Gregorian Date: ${DateFormat('dd MMM yyyy').format(DateTime.parse(widget.isMale ? appController.maleList[widget.index].dod : appController.femaleList[widget.index].dod))}"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
                ),
                height(context),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(),
                    const Text(
                      'Relatives',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.to(() => AddRelative(
                              plaqueId: widget.isMale
                                  ? appController
                                      .maleList[widget.index].plaqueId
                                  : appController
                                      .femaleList[widget.index].plaqueId,
                              scaffoldKey: widget.scaffoldKey));
                        },
                        icon: const Icon(Icons.add))
                  ],
                ),
                height(context),
                Obx(
                  () => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.isMale
                        ? appController.maleList[widget.index].relatives.length
                        : appController
                            .femaleList[widget.index].relatives.length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(top: 5, bottom: 5),
                      child: CustomCard(
                          child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 200,
                          minWidth: 100,
                          maxHeight: 60,
                          minHeight: 40,
                        ),
                        child: ListTile(
                          trailing: IconButton(
                              onPressed: () async {
                                String id = widget.isMale
                                    ? appController.maleList[widget.index]
                                        .relatives[index].id
                                    : appController.femaleList[widget.index]
                                        .relatives[index].id;
                                await appController.deleteRelative(id);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              )),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(widget.isMale
                                  ? appController.maleList[widget.index]
                                      .relatives[index].relativeFullname
                                  : appController.femaleList[widget.index]
                                      .relatives[index].relativeFullname),
                              Text(widget.isMale
                                  ? appController.maleList[widget.index]
                                      .relatives[index].number
                                  : appController.femaleList[widget.index]
                                      .relatives[index].number),
                            ],
                          ),
                        ),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}
