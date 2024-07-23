import 'package:projetos/app/data/models/user_model.dart';

class FundRaising {
  int? id;
  int? userId;
  int? companyId;
  String? expectedDate;
  int? predictedValue;
  dynamic capturedValue;
  dynamic dateOfCapture;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? empresa;
  User? user;

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
    user = json['user'] != null ? User.fromJson(json['user']) : null;
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
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
