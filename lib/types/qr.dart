// To parse this JSON data, do
//
//     final qrData = qrDataFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

class QrData {
  QrData({
    required this.status,
    required this.gmsErrors,
    required this.data,
  });

  String status;
  List<dynamic> gmsErrors;
  Data data;

  factory QrData.fromRawJson(String str) => QrData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory QrData.fromJson(Map<String, dynamic> json) => QrData(
    status: json["status"],
    gmsErrors: List<dynamic>.from(json["gmsErrors"].map((x) => x)),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "gmsErrors": List<dynamic>.from(gmsErrors.map((x) => x)),
    "data": data.toJson(),
  };
}

class Data {
  Data({
    required this.id,
    required this.controlNo,
    required this.serialNo,
    required this.assetNo,
    required this.nistNo,
    required this.gaugeType,
    required this.model,
    required this.manufacturer,
    required this.manufacturerDet,
    required this.measurementTypes,
    required this.measurementUnit,
    required this.rangeOrSize,
    required this.accuracy,
    required this.sourceVendor,
    required this.guageCost,
    required this.gaugeDesc,
    required this.storageLoc,
    required this.gaugeStatus,
    required this.conditionAcquired,
    required this.divId,
    required this.grId,
    required this.deptId,
    required this.createdTs,
    required this.updatedTs,
    required this.lastCalibrationDate,
    required this.nextCalibrationDate,
    required this.acquiredDate,
    required this.certId,
    required this.billId,
    required this.imageId,
    required this.gaugeProfile,
    required this.lastMsaDate,
    required this.msaFrequency,
    required this.nextMsaDate,
    required this.calibFrequency,
    required this.qr,
  });

  int id;
  String controlNo;
  String serialNo;
  String assetNo;
  String nistNo;
  String gaugeType;
  String model;
  String manufacturer;
  String manufacturerDet;
  String measurementTypes;
  String measurementUnit;
  String rangeOrSize;
  String accuracy;
  String sourceVendor;
  int guageCost;
  String gaugeDesc;
  String storageLoc;
  String gaugeStatus;
  String conditionAcquired;
  int divId;
  int grId;
  int deptId;
  int createdTs;
  dynamic updatedTs;
  int lastCalibrationDate;
  int nextCalibrationDate;
  int acquiredDate;
  int certId;
  dynamic billId;
  dynamic imageId;
  String gaugeProfile;
  dynamic lastMsaDate;
  dynamic msaFrequency;
  dynamic nextMsaDate;
  int calibFrequency;
  dynamic qr;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    controlNo: json["controlNo"],
    serialNo: json["serialNo"],
    assetNo: json["assetNo"],
    nistNo: json["nistNo"],
    gaugeType: json["gaugeType"],
    model: json["model"],
    manufacturer: json["manufacturer"],
    manufacturerDet: json["manufacturerDet"],
    measurementTypes: json["measurementTypes"],
    measurementUnit: json["measurementUnit"],
    rangeOrSize: json["rangeOrSize"],
    accuracy: json["accuracy"],
    sourceVendor: json["sourceVendor"],
    guageCost: json["guageCost"],
    gaugeDesc: json["gaugeDesc"],
    storageLoc: json["storageLoc"],
    gaugeStatus: json["gaugeStatus"],
    conditionAcquired: json["conditionAcquired"],
    divId: json["divId"],
    grId: json["grId"],
    deptId: json["deptId"],
    createdTs: json["createdTs"],
    updatedTs: json["updatedTs"],
    lastCalibrationDate: json["lastCalibrationDate"],
    nextCalibrationDate: json["nextCalibrationDate"],
    acquiredDate: json["acquiredDate"],
    certId: json["certId"],
    billId: json["billId"],
    imageId: json["imageId"],
    gaugeProfile: json["gaugeProfile"],
    lastMsaDate: json["lastMsaDate"],
    msaFrequency: json["msaFrequency"],
    nextMsaDate: json["nextMsaDate"],
    calibFrequency: json["calibFrequency"],
    qr: json["qr"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "controlNo": controlNo,
    "serialNo": serialNo,
    "assetNo": assetNo,
    "nistNo": nistNo,
    "gaugeType": gaugeType,
    "model": model,
    "manufacturer": manufacturer,
    "manufacturerDet": manufacturerDet,
    "measurementTypes": measurementTypes,
    "measurementUnit": measurementUnit,
    "rangeOrSize": rangeOrSize,
    "accuracy": accuracy,
    "sourceVendor": sourceVendor,
    "guageCost": guageCost,
    "gaugeDesc": gaugeDesc,
    "storageLoc": storageLoc,
    "gaugeStatus": gaugeStatus,
    "conditionAcquired": conditionAcquired,
    "divId": divId,
    "grId": grId,
    "deptId": deptId,
    "createdTs": createdTs,
    "updatedTs": updatedTs,
    "lastCalibrationDate": lastCalibrationDate,
    "nextCalibrationDate": nextCalibrationDate,
    "acquiredDate": acquiredDate,
    "certId": certId,
    "billId": billId,
    "imageId": imageId,
    "gaugeProfile": gaugeProfile,
    "lastMsaDate": lastMsaDate,
    "msaFrequency": msaFrequency,
    "nextMsaDate": nextMsaDate,
    "calibFrequency": calibFrequency,
    "qr": qr,
  };
}
