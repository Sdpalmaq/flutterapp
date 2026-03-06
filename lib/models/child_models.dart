// ============ ACCIONISTAS ============
class AccionistaModel {
  int? id;
  int? personalDataId;
  String? zNombreApellidos;
  String? zNacionalidad;
  double? zPorcentajeParticipacion;

  AccionistaModel({
    this.id,
    this.personalDataId,
    this.zNombreApellidos,
    this.zNacionalidad,
    this.zPorcentajeParticipacion,
  });

  factory AccionistaModel.fromJson(Map<String, dynamic> json) {
    return AccionistaModel(
      id: json['id'],
      personalDataId: json['zC_BP_PersonalData_ID']?['id'],
      zNombreApellidos: json['zNombreApellidos'],
      zNacionalidad: json['zNacionalidad_'],
      zPorcentajeParticipacion: json['zPorcentajeParticipacion']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson(int personalDataId) {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    map['zC_BP_PersonalData_ID'] = {'id': personalDataId};
    if (zNombreApellidos != null) map['zNombreApellidos'] = zNombreApellidos;
    if (zNacionalidad != null) map['zNacionalidad_'] = zNacionalidad;
    if (zPorcentajeParticipacion != null)
      map['zPorcentajeParticipacion'] = zPorcentajeParticipacion;
    return map;
  }
}

// ============ PRINCIPALES CLIENTES ============
class PrincipalClienteModel {
  int? id;
  int? personalDataId;
  String? zNombre;
  double? zPorcentajeVentas;
  int? zPaisId;
  String? zPaisIdentifier;
  String? zTelefono;

  PrincipalClienteModel({
    this.id,
    this.personalDataId,
    this.zNombre,
    this.zPorcentajeVentas,
    this.zPaisId,
    this.zPaisIdentifier,
    this.zTelefono,
  });

  factory PrincipalClienteModel.fromJson(Map<String, dynamic> json) {
    return PrincipalClienteModel(
      id: json['id'],
      personalDataId: json['zC_BP_PersonalData_ID']?['id'],
      zNombre: json['zNombrePrincipalesClientes'],
      zPorcentajeVentas: json['zPorcentajeVentasPClientes']?.toDouble(),
      zPaisId: json['zPaisPClientes_ID']?['id'],
      zPaisIdentifier: json['zPaisPClientes_ID']?['identifier'],
      zTelefono: json['zTelefonoPClientes'],
    );
  }

  Map<String, dynamic> toJson(int personalDataId) {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    map['zC_BP_PersonalData_ID'] = {'id': personalDataId};
    if (zNombre != null) map['zNombrePrincipalesClientes'] = zNombre;
    if (zPorcentajeVentas != null)
      map['zPorcentajeVentasPClientes'] = zPorcentajeVentas;
    if (zPaisId != null) map['zPaisPClientes_ID'] = {'id': zPaisId};
    if (zTelefono != null) map['zTelefonoPClientes'] = zTelefono;
    return map;
  }
}

// ============ PEP ============
class PepModel {
  int? id;
  int? personalDataId;
  String? zNombresApellidos;
  String? zCedula;
  String? zVinculacion;

  PepModel({
    this.id,
    this.personalDataId,
    this.zNombresApellidos,
    this.zCedula,
    this.zVinculacion,
  });

  factory PepModel.fromJson(Map<String, dynamic> json) {
    return PepModel(
      id: json['id'],
      personalDataId: json['zC_BP_PersonalData_ID']?['id'],
      zNombresApellidos: json['ZNombresApellidosPEP'],
      zCedula: json['ZCedulaPEP'],
      zVinculacion: json['ZVinculacionPEP'],
    );
  }

  Map<String, dynamic> toJson(int personalDataId) {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    map['zC_BP_PersonalData_ID'] = {'id': personalDataId};
    if (zNombresApellidos != null)
      map['ZNombresApellidosPEP'] = zNombresApellidos;
    if (zCedula != null) map['ZCedulaPEP'] = zCedula;
    if (zVinculacion != null) map['ZVinculacionPEP'] = zVinculacion;
    return map;
  }
}

// ============ REFERENCIAS BANCARIAS ============
class ReferenciaBancariaModel {
  int? id;
  int? personalDataId;
  String? bankName;
  String? bankAccountNo;
  String? bankAccountType;

  ReferenciaBancariaModel({
    this.id,
    this.personalDataId,
    this.bankName,
    this.bankAccountNo,
    this.bankAccountType,
  });

  factory ReferenciaBancariaModel.fromJson(Map<String, dynamic> json) {
    return ReferenciaBancariaModel(
      id: json['id'],
      personalDataId: json['zC_BP_PersonalData_ID']?['id'],
      bankName: json['BankName'],
      bankAccountNo: json['BankAccountNo'],
      bankAccountType: json['BankAccountType']?['id'],
    );
  }

  Map<String, dynamic> toJson(int personalDataId) {
    final map = <String, dynamic>{};
    if (id != null) map['id'] = id;
    map['zC_BP_PersonalData_ID'] = {'id': personalDataId};
    if (bankName != null) map['BankName'] = bankName;
    if (bankAccountNo != null) map['BankAccountNo'] = bankAccountNo;
    if (bankAccountType != null)
      map['BankAccountType'] = {'id': bankAccountType};
    return map;
  }
}
