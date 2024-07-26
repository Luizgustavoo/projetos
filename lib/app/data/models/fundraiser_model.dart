import 'package:projetos/app/data/models/user_model.dart';

class FundRaiser {
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
  User? user;

  FundRaiser(
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
      this.user});

  FundRaiser.fromJson(Map<String, dynamic> json) {
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
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
