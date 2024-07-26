import 'package:projetos/app/data/models/fundraisings_model.dart';

class FundRaiserComission {
  int? id;
  String? status;
  String? payday;
  dynamic amount;
  FundRaising? fundraisings;

  FundRaiserComission({
    this.id,
    this.status,
    this.payday,
    this.fundraisings
  });

  FundRaiserComission.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    payday = json['payday'];
    status = json['status'];
    fundraisings = json['fundraisings'] != null ? FundRaising.fromJson(json['fundraisings']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status;
    data['payday'] = payday;
    if (fundraisings != null) {
      data['fundraisings'] = fundraisings!.toJson();
    }
    return data;
  }
}
