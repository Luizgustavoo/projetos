import 'package:projetos/app/data/models/company_model.dart';
import 'package:projetos/app/data/models/fund_raiser_comission_model.dart';
import 'package:projetos/app/data/models/user_model.dart';

class FundRaising {
  int? id;
  int? userId;
  int? companyId;
  String? expectedDate;
  dynamic predictedValue;
  dynamic capturedValue;
  dynamic dateOfCapture;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? empresa;
  String? pago;
  dynamic payDay;
  User? user;
  Company? company;
  FundRaiserComission? fundRaiserComission;

  FundRaising(
      {this.id,
      this.userId,
      this.companyId,
      this.expectedDate,
      this.predictedValue,
      this.capturedValue,
      this.dateOfCapture,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.empresa,
      this.pago,
      this.payDay,
      this.company,
      this.fundRaiserComission,
      this.user});

  FundRaising.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyId = json['company_id'];
    expectedDate = json['expected_date'];
    predictedValue = json['predicted_value'];
    capturedValue = json['captured_value'];
    dateOfCapture = json['date_of_capture'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    empresa = json['empresa'];
    pago = json['pago'];
    payDay = json['payday'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    fundRaiserComission = json['fundraisercomission'] != null ? FundRaiserComission.fromJson(json['fundraisercomission']) : null;
    company =
        json['company'] != null ? Company.fromJson(json['company']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['company_id'] = companyId;
    data['expected_date'] = expectedDate;
    data['predicted_value'] = predictedValue;
    data['captured_value'] = capturedValue;
    data['date_of_capture'] = dateOfCapture;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['empresa'] = empresa;
    data['pago'] = pago;
    data['payday'] = payDay;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (company != null) {
      data['company'] = company!.toJson();
    }
    if (fundRaiserComission != null) {
      data['fundraisercomission'] = fundRaiserComission!.toJson();
    }
    return data;
  }
}
