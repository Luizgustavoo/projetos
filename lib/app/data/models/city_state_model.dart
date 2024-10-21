class CityState {
  String? cidadeEstado;
  String? cidade;
  String? estado;

  CityState({
    this.cidadeEstado,
    this.cidade,
    this.estado,
  });

  CityState.fromJson(Map<String, dynamic> json) {
    cidadeEstado = json['cidade_estado'];
    cidade = json['cidade'];
    estado = json['estado'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cidade_estado'] = cidadeEstado;
    data['cidade'] = cidade;
    data['estado'] = estado;

    return data;
  }

  bool isEmpty() {
    return cidadeEstado == null;
  }
}
