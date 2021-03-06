// To parse this JSON data, do
//
//     final sourceResponse = sourceResponseFromJson(jsonString);

import 'dart:convert';

import 'source_model.dart';

SourceResponse sourceResponseFromJson(String str) =>
    SourceResponse.fromJson(json.decode(str));

String sourceResponseToJson(SourceResponse data) => json.encode(data.toJson());

class SourceResponse {
  SourceResponse({this.status, this.sources, this.error});

  String error;
  String status;
  List<Source> sources;

  factory SourceResponse.fromJson(Map<String, dynamic> json) => SourceResponse(
        error: "",
        status: json["status"],
        sources:
            List<Source>.from(json["sources"].map((x) => Source.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
        "sources": List<dynamic>.from(sources.map((x) => x.toJson())),
      };

  factory SourceResponse.withError(String errorValue) => SourceResponse(
        error: errorValue,
        status: "error",
        sources: List(),
      );
}
