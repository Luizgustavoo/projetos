class MaterialModel {
  int? id;
  String? descricao;
  String? tipo;
  String? arquivoVideo;
  int? status;
  String? createdAt;
  String? updatedAt;

  MaterialModel({
    this.id,
    this.descricao,
    this.tipo,
    this.arquivoVideo,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  MaterialModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descricao = json['descricao'];
    tipo = json['tipo'];
    arquivoVideo = json['arquivo_video'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['descricao'] = descricao;
    data['tipo'] = tipo;
    data['arquivo_video'] = arquivoVideo;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
