class User {
  int? id;
  String? name;
  String? email;
  String? password;
  Null emailVerifiedAt;
  String? createdAt;
  String? updatedAt;
  String? startDate;
  int? status;
  String? contact;
  int? usertypeId;
  String? cpfCnpj;

  User(
      {this.id,
      this.name,
      this.email,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt,
      this.startDate,
      this.status,
      this.contact,
      this.password,
      this.usertypeId,
      this.cpfCnpj});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    startDate = json['start_date'];
    status = json['status'];
    contact = json['contact'];
    usertypeId = json['usertype_id'];
    cpfCnpj = json['cpf_cnpj'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['start_date'] = startDate;
    data['status'] = status;
    data['contact'] = contact;
    data['usertype_id'] = usertypeId;
    data['cpf_cnpj'] = cpfCnpj;
    return data;
  }

  map(Function(dynamic u) param0) {}
}
