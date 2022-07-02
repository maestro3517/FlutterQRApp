import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qr_app/types/qr.dart';

class QrDataDisplay extends StatefulWidget {
  final Data data;

  QrDataDisplay({Key? key, required this.data}) : super(key: key);

  @override
  QrDataDisplayState createState() => QrDataDisplayState();
}

class QrDataDisplayState extends State<QrDataDisplay> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    setState(() {
      data = widget.data.toJson();
    });
    init();
  }

  init() async {
    //
    final date = DateTime.now();
    //convert timestamp String to DateTime
    final dueCalibTime =
        DateTime.fromMillisecondsSinceEpoch(data['nextCalibrationDate']);
    final dueMsaTime = DateTime.fromMillisecondsSinceEpoch(data['nextMsaDate']);

    //calculate current date minus data.nextCalibrationDate
    dueCalibDate = date.difference(dueCalibTime).inDays.toString();

    //calculate current date minus data.nextMsaDate
    dueMsaDate = date.difference(dueMsaTime).inDays.toString();

    //decode base64 string to Image file
    // final decodedImage = base64Decode(data['gaugeProfile']);
    // print(decodedImage);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gauge Information"),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            alignment: Alignment.topCenter,
            color: Colors.white54,
            child: const Icon(
              CupertinoIcons.gauge,
              size: 150,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 200, 0, 10),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                borderOnForeground: true,
                child: ListTile(
                  tileColor: Colors.white54,
                  shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.circular(5)),
                  title: Text(data.keys.elementAt(index)),
                  trailing: Text(data.values.elementAt(index).toString()),
                ),
              );
            },
            itemCount: data.length,
          )
        ],
      ),
    );
  }
}
