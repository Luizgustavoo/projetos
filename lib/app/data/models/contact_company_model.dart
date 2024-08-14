class ContactCompany {
  int? id;
  int? userId;
  int? companyId;
  String? dateContact;
  String? nomePessoa;
  String? observacoes;
  String? createdAt;
  String? updatedAt;
  String? empresa;
  String? dataRetorno;
  String? previsaoValor;
  String? mesDeposito;
  String? cargoContato;
  String? ultimaCaptacao;

  ContactCompany({
    this.id,
    this.userId,
    this.companyId,
    this.dateContact,
    this.nomePessoa,
    this.observacoes,
    this.createdAt,
    this.updatedAt,
    this.dataRetorno,
    this.previsaoValor,
    this.mesDeposito,
    this.cargoContato,
    this.empresa,
    this.ultimaCaptacao,
  });

  ContactCompany.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    companyId = json['company_id'];
    dateContact = json['date_contact'];
    nomePessoa = json['nome_pessoa'];
    observacoes = json['observacoes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    empresa = json['empresa'];
    dataRetorno = json['data_retorno'];
    previsaoValor = json['previsao_valor'];
    mesDeposito = json['mes_deposito'];
    cargoContato = json['cargo_contato'];
    ultimaCaptacao = json['ultima_captacao'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['company_id'] = companyId;
    data['date_contact'] = dateContact;
    data['nome_pessoa'] = nomePessoa;
    data['observacoes'] = observacoes;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['empresa'] = empresa;
    data['data_retorno'] = dataRetorno;
    data['previsao_valor'] = previsaoValor;
    data['mes_deposito'] = mesDeposito;
    data['cargo_contato'] = cargoContato;
    data['ultima_captacao'] = ultimaCaptacao;
    return data;
  }
}
