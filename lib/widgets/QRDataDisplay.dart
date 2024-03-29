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
  late String dueCalibDate = "";
  late String dueMsaDate = "";
  late Map<String, dynamic> modData = {};
  late var decodedImage = null;

  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.data.toJson();
      for (final qrKey in excludeQrData) {
        final modKey = qrKey.substring(0, 1).toUpperCase() +
            qrKey.substring(1).replaceAllMapped(
                RegExp(r'(.)([A-Z])'), (match) => '${match[1]} ${match[2]}');

        if (qrKey.contains('Date') && data[qrKey] != 0) {
          modData[modKey] = DateFormat('MM/dd/yyyy')
              .format(DateTime.fromMillisecondsSinceEpoch(data[qrKey]));
        } else {
          modData[modKey] = data[qrKey];
        }
      }
    });
    init();
  }

  init() async {
    final date = DateTime.now();

    if (data['nextCalibrationDate'] != 0) {
      final dueCalibTime =
          DateTime.fromMillisecondsSinceEpoch(data['nextCalibrationDate']);
      dueCalibDate = dueCalibTime.difference(date).inDays.toString();
    }

    if (data['nextMsaDate'] != 0) {
      final dueMsaTime =
          DateTime.fromMillisecondsSinceEpoch(data['nextMsaDate']);
      dueMsaDate = dueMsaTime.difference(date).inDays.toString();
    }

    if (data['gaugeProfile'] != "") {
      try {
        decodedImage = base64Decode(data['gaugeProfile'].split(',')[1]);
      } catch (e) {
        print(e);
      }
    } else {
      //display a default image for Image.memory
      decodedImage=base64Decode(defaultImage);
    }
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
                Image.memory(decodedImage, fit: BoxFit.fill),
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
                            color: data['storageLoc'] == 'ISSUED'
                                ? const Color(0xFFFFE2E5)
                                : data['storageLoc'] == 'OUT FOR CALIBRATION'
                                    ? const Color(0xFFE1F0FF)
                                    : data['storageLoc'] == 'OUT FOR LINEARITY'
                                        ? const Color(0xFFC9F7F5)
                                        : data['storageLoc'] == 'OUT FOR BIAS'
                                            ? const Color(0xFFEEE5FF)
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
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(
                                "Gauge Status: ${data['gaugeStatus']}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: data['gaugeStatus'] == 'ACTIVE'
                                      ? const Color(0xFF28a745)
                                      : data['gaugeStatus'] == 'DELETED'
                                          ? const Color(0xFFdc3545)
                                          : data['gaugeStatus'] == 'INACTIVE'
                                              ? const Color(0xFFffc107)
                                              : Colors.black,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 0, 10),
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
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                                  const EdgeInsets.fromLTRB(10, 10, 0, 10),
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
                        fontWeight: FontWeight.w600,
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
