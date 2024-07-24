class Statistic {
  int? expiredCompanies;
  int? availableCompanies;
  int? totalCompanies;

  Statistic(
      {this.expiredCompanies, this.availableCompanies, this.totalCompanies});

  Statistic.fromJson(Map<String, dynamic> json) {
    expiredCompanies = json['expired_companies'];
    availableCompanies = json['available_companies'];
    totalCompanies = json['total_companies'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['expired_companies'] = expiredCompanies;
    data['available_companies'] = availableCompanies;
    data['total_companies'] = totalCompanies;
    return data;
  }
}
