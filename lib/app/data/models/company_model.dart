import 'package:projetos/app/data/models/fundraisings_model.dart';

class Company {
  int? id;
  String? nome;
  String? cnpj;
  String? responsavel;
  String? telefone;
  String? nomePessoa;
  int? status;
  String? createdAt;
  String? updatedAt;
  List<FundRaising>? fundraisings;

  Company(
      {this.id,
      this.nome,
      this.cnpj,
      this.responsavel,
      this.telefone,
      this.nomePessoa,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.fundraisings});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    cnpj = json['cnpj'];
    responsavel = json['responsavel'];
    telefone = json['telefone'];
    nomePessoa = json['nome_pessoa'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['fundraisings'] != null) {
      fundraisings = <FundRaising>[];
      json['fundraisings'].forEach((v) {
        fundraisings!.add(FundRaising.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nome'] = nome;
    data['cnpj'] = cnpj;
    data['responsavel'] = responsavel;
    data['telefone'] = telefone;
    data['nome_pessoa'] = nomePessoa;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (fundraisings != null) {
      data['fundraisings'] = fundraisings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
