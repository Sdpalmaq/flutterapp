class IdempiereRef {
  final int id;
  final String identifier;

  IdempiereRef({required this.id, required this.identifier});

  factory IdempiereRef.fromJson(Map<String, dynamic> json) {
    return IdempiereRef(
      id: json['id'] ?? 0,
      identifier: json['identifier'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'identifier': identifier,
      };
}

class KycJuridicaModel {
  // Identificadores
  final int? id;
  int? idMutable;
  final String? uid;

  // Datos Generales
  IdempiereRef? adOrgId;
  String? name;
  String? taxId;
  IdempiereRef? cBpartnerId;
  String? actividadEconomica;
  IdempiereRef? tipoActividad;
  String? zCorreoCliente;
  String? zAgencia;
  String? zObjetoSocial;
  String? zPaginaInternet;
  DateTime? zFecha;

  // Verificación de Información
  bool registroCivil;
  bool sri;
  bool funcionJudicial;
  bool bureauCredito;
  bool antecedentespenales;
  bool otros;

  // Dirección
  String? zProvinciaTrabCliente;
  String? zCiudadTrabCliente;
  String? zCantonTrabCliente;
  String? zCalleTrabCliente;
  String? zNumeroTrabCliente;
  String? zTelefonoTrabCliente;

  // Persona que hace la Transacción
  String? zNombrePersonaTransaccion;
  String? zDocumentoPersonaTransa;
  String? zVinculacionEmpresa;

  // Información de la Transacción
  String? zBienTransaccion;
  double? zPvpTransaccion;
  String? zFormaPago;
  String? zOrigenFondos;

  // Situación Comercial & Financiera Año 1
  double? zActivos;
  double? zPasivos;
  double? zPatrimonio;
  double? zVentas;
  double? zCostVentas;
  double? zGastosDeOperacion;
  double? zUtilidadNeta;
  double? zMargenOperacional;

  // Situación Comercial & Financiera Año 2
  double? zActivos2;
  double? zPasivos2;
  double? zPatrimonio2;
  double? zVentas2;
  double? zCostVentas2;
  double? zGastosDeOperacion2;
  double? zUtilidadNeta2;
  double? zMargenOperacional2;

  // Situación Comercial & Financiera Año 3
  double? zActivos3;
  double? zPasivos3;
  double? zPatrimonio3;
  double? zVentas3;
  double? zCostVentas3;
  double? zGastosDeOperacion3;
  double? zUtilidadNeta3;
  double? zMargenOperacional3;

  // Datos del Representante Legal
  String? zNombreRespresentanteLegal;
  String? zDocumentoRepLegal;
  String? zGeneroRepLegal;
  String? zCorreoRepLegal;
  IdempiereRef? zPaisRepLegal;
  String? zProvinciaRepLegal;
  String? zCiudadRepLegal;
  String? zCantonRepLegal;
  String? zCalleRepLegal;
  String? zNumeroRepLegal;
  String? zTelefonoRepLegal;
  String? zNombreConyugue;
  String? zDocConyugue;
  String? zObservacionesKyc;

  // PEP
  bool isPpe;
  String? zDetallePep;

  // Tipo de persona
  bool zIsPJuridica;

  KycJuridicaModel({
    this.id,
    this.uid,
    this.adOrgId,
    this.name,
    this.taxId,
    this.cBpartnerId,
    this.actividadEconomica,
    this.tipoActividad,
    this.zCorreoCliente,
    this.zAgencia,
    this.zObjetoSocial,
    this.zPaginaInternet,
    this.zFecha,
    this.registroCivil = false,
    this.sri = false,
    this.funcionJudicial = false,
    this.bureauCredito = false,
    this.antecedentespenales = false,
    this.otros = false,
    this.zProvinciaTrabCliente,
    this.zCiudadTrabCliente,
    this.zCantonTrabCliente,
    this.zCalleTrabCliente,
    this.zNumeroTrabCliente,
    this.zTelefonoTrabCliente,
    this.zNombrePersonaTransaccion,
    this.zDocumentoPersonaTransa,
    this.zVinculacionEmpresa,
    this.zBienTransaccion,
    this.zPvpTransaccion,
    this.zFormaPago,
    this.zOrigenFondos,
    this.zActivos,
    this.zPasivos,
    this.zPatrimonio,
    this.zVentas,
    this.zCostVentas,
    this.zGastosDeOperacion,
    this.zUtilidadNeta,
    this.zMargenOperacional,
    this.zActivos2,
    this.zPasivos2,
    this.zPatrimonio2,
    this.zVentas2,
    this.zCostVentas2,
    this.zGastosDeOperacion2,
    this.zUtilidadNeta2,
    this.zMargenOperacional2,
    this.zActivos3,
    this.zPasivos3,
    this.zPatrimonio3,
    this.zVentas3,
    this.zCostVentas3,
    this.zGastosDeOperacion3,
    this.zUtilidadNeta3,
    this.zMargenOperacional3,
    this.zNombreRespresentanteLegal,
    this.zDocumentoRepLegal,
    this.zGeneroRepLegal,
    this.zCorreoRepLegal,
    this.zPaisRepLegal,
    this.zProvinciaRepLegal,
    this.zCiudadRepLegal,
    this.zCantonRepLegal,
    this.zCalleRepLegal,
    this.zNumeroRepLegal,
    this.zTelefonoRepLegal,
    this.zNombreConyugue,
    this.zDocConyugue,
    this.zObservacionesKyc,
    this.isPpe = false,
    this.zDetallePep,
    this.zIsPJuridica = true,
  });

  factory KycJuridicaModel.fromJson(Map<String, dynamic> json) {
    return KycJuridicaModel(
      id: json['id'],
      uid: json['uid'],
      adOrgId: json['AD_Org_ID'] != null
          ? IdempiereRef.fromJson(json['AD_Org_ID'])
          : null,
      name: json['Name'],
      taxId: json['TaxID'],
      cBpartnerId: json['C_BPartner_ID'] != null
          ? IdempiereRef.fromJson(json['C_BPartner_ID'])
          : null,
      actividadEconomica: json['ActividadEconomica'],
      tipoActividad: json['TipoActividad'] != null
          ? IdempiereRef.fromJson(json['TipoActividad'])
          : null,
      zCorreoCliente: json['zCorreoCliente'],
      zObjetoSocial: json['ZObjetoSocial'],
      zPaginaInternet: json['ZPaginaInternet'],
      zAgencia: json['ZAgencia'],
      // Fecha
      zFecha: json['ZFecha'] != null ? DateTime.tryParse(json['ZFecha']) : null,
      // Verificación
      registroCivil: json['RegistroCivil'] ?? false,
      sri: json['SRI'] ?? false,
      funcionJudicial: json['FuncionJudicial'] ?? false,
      bureauCredito: json['BureauCredito'] ?? false,
      antecedentespenales: json['AntecedentesPenales'] ?? false,
      otros: json['Otros'] ?? false,
      // Dirección
      zProvinciaTrabCliente: json['zProvinciaTrabajoCliente'],
      zCiudadTrabCliente: json['zCiudadTrabajoCliente'],
      zCantonTrabCliente: json['zCantonTrabajoCliente'],
      zCalleTrabCliente: json['zCalleTrabajoCliente'],
      zNumeroTrabCliente: json['zNumeroTrabajoCliente'],
      zTelefonoTrabCliente: json['zTelefonoTrabajoCliente'],
      // Persona Transacción
      zNombrePersonaTransaccion: json['zNombrePersonaTransaccion'],
      zDocumentoPersonaTransa: json['zDocumentoPersonaTransa'],
      zVinculacionEmpresa: json['zVinculacionEmpresa'],
      // Información Transacción
      zBienTransaccion: json['zBienTransaccion'],
      zPvpTransaccion: json['zPVPTransaccion']?.toDouble(),
      zFormaPago:
          json['PaymentRule'] != null ? json['PaymentRule']['id'] : null,
      zOrigenFondos: json['zOrigenFondos'],
      // Financiera Año 1
      zActivos: json['zActivos']?.toDouble(),
      zPasivos: json['zPasivos']?.toDouble(),
      zPatrimonio: json['zPatrimonio']?.toDouble(),
      zVentas: json['zVentas']?.toDouble(),
      zCostVentas: json['zCostoVentas']?.toDouble(),
      zGastosDeOperacion: json['zGastosdeOperacion']?.toDouble(),
      zUtilidadNeta: json['zUtilidadNeta']?.toDouble(),
      zMargenOperacional: json['zMargenOperacional']?.toDouble(),
      // Financiera Año 2
      zActivos2: json['ZActivos2']?.toDouble(),
      zPasivos2: json['ZPasivos2']?.toDouble(),
      zPatrimonio2: json['ZPatrimonio2']?.toDouble(),
      zVentas2: json['ZVentas2']?.toDouble(),
      zCostVentas2: json['ZCostVentas2']?.toDouble(),
      zGastosDeOperacion2: json['ZGastosDeOperacion2']?.toDouble(),
      zUtilidadNeta2: json['ZUtildadNeta2']?.toDouble(),
      zMargenOperacional2: json['ZMargenOperacional2']?.toDouble(),
      // Financiera Año 3
      zActivos3: json['ZActivos3']?.toDouble(),
      zPasivos3: json['ZPasivos3']?.toDouble(),
      zPatrimonio3: json['ZPatrimonio3']?.toDouble(),
      zVentas3: json['ZVentas3']?.toDouble(),
      zCostVentas3: json['ZCostVentas3']?.toDouble(),
      zGastosDeOperacion3: json['ZGastosDeOperacion3']?.toDouble(),
      zUtilidadNeta3: json['ZUtildadNeta3']?.toDouble(),
      zMargenOperacional3: json['ZMargenOperacional3']?.toDouble(),
      // Representante Legal
      zNombreRespresentanteLegal: json['zNombreRespresentanteLegal'],
      zDocumentoRepLegal: json['zDocumentoRepLegal'],
      zGeneroRepLegal: json['zGeneroLegalRep'] != null
          ? json['zGeneroLegalRep']['id']
          : null,
      zCorreoRepLegal: json['zEmailRepLegal'],
      zPaisRepLegal: json['zPaisRepLegal_ID'] != null
          ? IdempiereRef.fromJson(json['zPaisRepLegal_ID'])
          : null,
      zProvinciaRepLegal: json['zProvinciaRepLegal'],
      zCiudadRepLegal: json['zCiudadRepLegal'],
      zCantonRepLegal: json['zCantonRepLegal'],
      zCalleRepLegal: json['zCalleRepLegal'],
      zNumeroRepLegal: json['zNoRepLegal'],
      zTelefonoRepLegal: json['zPhoneRepLegal'],
      zNombreConyugue: json['zNombreConyugueRepLegal'],
      zDocConyugue: json['zDocumentoConyugueRepLegal'],
      zObservacionesKyc: json['zObservacionesKYC'],
      // PEP
      isPpe: json['IsPPE'] ?? false,
      zIsPJuridica: json['zIsPJuridica'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (idMutable != null) map['id'] = idMutable;
    if (id != null) map['id'] = id;

    // Datos Generales
    if (adOrgId != null) map['AD_Org_ID'] = {'id': adOrgId!.id};
    if (cBpartnerId != null) map['C_BPartner_ID'] = {'id': cBpartnerId!.id};
    if (tipoActividad != null) map['TipoActividad'] = {'id': tipoActividad!.id};
    if (name != null) map['Name'] = name;
    if (taxId != null) map['TaxID'] = taxId;
    if (actividadEconomica != null)
      map['ActividadEconomica'] = actividadEconomica;
    if (zCorreoCliente != null) map['zCorreoCliente'] = zCorreoCliente;
    if (zAgencia != null) map['ZAgencia'] = zAgencia;
    if (zObjetoSocial != null) map['ZObjetoSocial'] = zObjetoSocial;
    if (zPaginaInternet != null) map['ZPaginaInternet'] = zPaginaInternet;
    if (zFecha != null) map['ZFecha'] = zFecha!.toIso8601String().split('T')[0];

    // Verificación
    map['RegistroCivil'] = registroCivil;
    map['SRI'] = sri;
    map['FuncionJudicial'] = funcionJudicial;
    map['BureauCredito'] = bureauCredito;
    map['AntecedentesPenales'] = antecedentespenales;
    map['Otros'] = otros;

    // Dirección
    if (zProvinciaTrabCliente != null)
      map['zProvinciaTrabajoCliente'] = zProvinciaTrabCliente;
    if (zCiudadTrabCliente != null)
      map['zCiudadTrabajoCliente'] = zCiudadTrabCliente;
    if (zCantonTrabCliente != null)
      map['zCantonTrabajoCliente'] = zCantonTrabCliente;
    if (zCalleTrabCliente != null)
      map['zCalleTrabajoCliente'] = zCalleTrabCliente;
    if (zNumeroTrabCliente != null)
      map['zNumeroTrabajoCliente'] = zNumeroTrabCliente;
    if (zTelefonoTrabCliente != null)
      map['zTelefonoTrabajoCliente'] = zTelefonoTrabCliente;

    // Persona Transacción
    if (zNombrePersonaTransaccion != null)
      map['zNombrePersonaTransaccion'] = zNombrePersonaTransaccion;
    if (zDocumentoPersonaTransa != null)
      map['zDocumentoPersonaTransa'] = zDocumentoPersonaTransa;
    if (zVinculacionEmpresa != null)
      map['zVinculacionEmpresa'] = zVinculacionEmpresa;

    // Información Transacción
    if (zBienTransaccion != null) map['zBienTransaccion'] = zBienTransaccion;
    if (zPvpTransaccion != null) map['zPVPTransaccion'] = zPvpTransaccion;
    if (zFormaPago != null) map['PaymentRule'] = zFormaPago;
    if (zOrigenFondos != null) map['zOrigenFondos'] = zOrigenFondos;

    // Situación Financiera Año 1
    if (zActivos != null) map['zActivos'] = zActivos;
    if (zPasivos != null) map['zPasivos'] = zPasivos;
    if (zPatrimonio != null) map['zPatrimonio'] = zPatrimonio;
    if (zVentas != null) map['zVentas'] = zVentas;
    if (zCostVentas != null) map['zCostoVentas'] = zCostVentas;
    if (zGastosDeOperacion != null)
      map['zGastosdeOperacion'] = zGastosDeOperacion;
    if (zUtilidadNeta != null) map['zUtilidadNeta'] = zUtilidadNeta;
    if (zMargenOperacional != null)
      map['zMargenOperacional'] = zMargenOperacional;

    // Situación Financiera Año 2
    if (zActivos2 != null) map['ZActivos2'] = zActivos2;
    if (zPasivos2 != null) map['ZPasivos2'] = zPasivos2;
    if (zPatrimonio2 != null) map['ZPatrimonio2'] = zPatrimonio2;
    if (zVentas2 != null) map['ZVentas2'] = zVentas2;
    if (zCostVentas2 != null) map['ZCostVentas2'] = zCostVentas2;
    if (zGastosDeOperacion2 != null)
      map['ZGastosDeOperacion2'] = zGastosDeOperacion2;
    if (zUtilidadNeta2 != null) map['ZUtildadNeta2'] = zUtilidadNeta2;
    if (zMargenOperacional2 != null)
      map['ZMargenOperacional2'] = zMargenOperacional2;

    // Situación Financiera Año 3
    if (zActivos3 != null) map['ZActivos3'] = zActivos3;
    if (zPasivos3 != null) map['ZPasivos3'] = zPasivos3;
    if (zPatrimonio3 != null) map['ZPatrimonio3'] = zPatrimonio3;
    if (zVentas3 != null) map['ZVentas3'] = zVentas3;
    if (zCostVentas3 != null) map['ZCostVentas3'] = zCostVentas3;
    if (zGastosDeOperacion3 != null)
      map['ZGastosDeOperacion3'] = zGastosDeOperacion3;
    if (zUtilidadNeta3 != null) map['ZUtildadNeta3'] = zUtilidadNeta3;
    if (zMargenOperacional3 != null)
      map['ZMargenOperacional3'] = zMargenOperacional3;

    // Representante Legal - nombres exactos de iDempiere
    if (zNombreRespresentanteLegal != null)
      map['zNombreRespresentanteLegal'] = zNombreRespresentanteLegal;

    if (zDocumentoRepLegal != null)
      map['zDocumentoRepLegal'] = zDocumentoRepLegal;
    if (zGeneroRepLegal != null) map['zGeneroLegalRep'] = zGeneroRepLegal;
    if (zCorreoRepLegal != null) map['zEmailRepLegal'] = zCorreoRepLegal;
    if (zPaisRepLegal != null)
      map['zPaisRepLegal_ID'] = {'id': zPaisRepLegal!.id};
    if (zProvinciaRepLegal != null)
      map['zProvinciaRepLegal'] = zProvinciaRepLegal;
    if (zCiudadRepLegal != null) map['zCiudadRepLegal'] = zCiudadRepLegal;
    if (zCantonRepLegal != null) map['zCantonRepLegal'] = zCantonRepLegal;
    if (zCalleRepLegal != null) map['zCalleRepLegal'] = zCalleRepLegal;
    if (zNumeroRepLegal != null) map['zNoRepLegal'] = zNumeroRepLegal;
    if (zTelefonoRepLegal != null) map['zPhoneRepLegal'] = zTelefonoRepLegal;
    if (zNombreConyugue != null)
      map['zNombreConyugueRepLegal'] = zNombreConyugue;
    if (zDocConyugue != null) map['zDocumentoConyugueRepLegal'] = zDocConyugue;
    if (zObservacionesKyc != null) map['zObservacionesKYC'] = zObservacionesKyc;

    // PEP
    map['IsPPE'] = isPpe;
    map['zIsRelatedPEP'] = isPpe;

    // Tipo persona
    map['zIsPJuridica'] = true;

    map['zIsPNatural'] = false;

    return map;
  }
}
