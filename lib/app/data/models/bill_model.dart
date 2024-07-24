import 'package:projetos/app/data/models/fundraisings_model.dart';

class Bill {
  int? id;
  String? nome;
  int? ano;
  String? status;
  Null observacoes;
  int? valorAprovado;
  List<FundRaising>? fundraisings;

  Bill(
      {this.id,
      this.nome,
      this.ano,
      this.status,
      this.observacoes,
      this.valorAprovado,
      this.fundraisings});

  Bill.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nome = json['nome'];
    ano = json['ano'];
    status = json['status'];
    observacoes = json['observacoes'];
    valorAprovado = json['valor_aprovado'];
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
    data['ano'] = ano;
    data['status'] = status;
    data['observacoes'] = observacoes;
    data['valor_aprovado'] = valorAprovado;
    if (fundraisings != null) {
      data['fundraisings'] = fundraisings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
