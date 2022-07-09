import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_app/constants.dart';
import 'package:flutter_qr_app/types/qr.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class QrDataDisplay extends StatefulWidget {
  final Data data;

  QrDataDisplay({Key? key, required this.data}) : super(key: key);

  @override
  QrDataDisplayState createState() => QrDataDisplayState();
}

class QrDataDisplayState extends State<QrDataDisplay> {
  late Map<String, dynamic> data;
  late String dueCalibDate;
  late String dueMsaDate;
  late Map<String, dynamic> modData = {};
  late final decodedImage;

  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.data.toJson();
      for (final qrKey in excludeQrData) {
        final modKey =  qrKey.substring(0, 1).toUpperCase() + qrKey.substring(1).replaceAllMapped(RegExp(r'(.)([A-Z])'), (match) => '${match[1]} ${match[2]}');

        if (qrKey.contains('Date')) {
          modData[modKey] = DateFormat('MM/dd/yyyy').format(DateTime.fromMillisecondsSinceEpoch(data[qrKey]));
        } else {
          modData[modKey] = data[qrKey];
        }
      }
    });
    init();
  }

  init() async {
    final date = DateTime.now();
    //convert timestamp String to DateTime
    final dueCalibTime =
        DateTime.fromMillisecondsSinceEpoch(data['nextCalibrationDate']);
    final dueMsaTime = DateTime.fromMillisecondsSinceEpoch(data['nextMsaDate']);

    //calculate current date minus data.nextCalibrationDate
    dueCalibDate = date.difference(dueCalibTime).inDays.toString();

    //calculate current date minus data.nextMsaDate
    dueMsaDate = date.difference(dueMsaTime).inDays.toString();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget _titleOtherDetails() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
        child: Text(
          'Other Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gauge Profile"),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
           finish(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 2,
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                Image.memory(base64Decode(data['gaugeProfile']),
                    fit: BoxFit.fill),
                SizedBox(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child: Text(
                          "Storage Location: ${data['storageLoc']}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: data['storageLoc'] == 'LOC-2'
                                ? Colors.blue
                                : data['storageLoc'] == 'B'
                                    ? Colors.blue
                                    : data['storageLoc'] == 'C'
                                        ? Colors.red
                                        : Colors.black,
                          ),
                        ),
                      ),
                      GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 10, 10),
                              child: Text(
                                "Gauge Status: ${data['gaugeStatus']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: data['gaugeStatus'] == 'ACTIVE'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(
                                "Gauge Type: ${data['gaugeType']}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10, 10, 10),
                              child: Text(
                                "Calib Due In(Days): $dueCalibDate",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(
                                "Msa Due In(Days): $dueMsaDate",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ])
                    ],
                  ),
                ),
              ],
            ),
          ),
          _titleOtherDetails(),
          Expanded(
              child: SizedBox(
                  child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                borderOnForeground: true,
                child: ListTile(
                  // tileColor: Colors.white54,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey, width: 0),
                      borderRadius: BorderRadius.circular(5)),
                  title: Text(modData.keys.elementAt(index),
                      style: const TextStyle(
                        fontSize: 16,
                      )),
                  trailing: Text(modData.values.elementAt(index).toString(),
                      style: const TextStyle(
                        fontSize: 16,
                      )),
                ),
              );
            },
            itemCount: modData.length,
          )))
        ],
      ),
    );
  }
}
