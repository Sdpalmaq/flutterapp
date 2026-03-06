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

  Map<String, dynamic> toJson() => {'id': id, 'identifier': identifier};
}

class KycJuridicaModel {
  final int? id;
  int? idMutable;
  final String? uid;

  IdempiereRef? adOrgId;
  String? name;
  String? taxId;
  IdempiereRef? cBpartnerId;
  String? actividadEconomica;
  String? tipoActividad;
  String? zCorreoCliente;
  String? zAgencia;
  String? zObjetoSocial;
  String? zPaginaInternet;
  DateTime? zFecha;

  bool registroCivil;
  bool sri;
  bool funcionJudicial;
  bool bureauCredito;
  bool antecedentespenales;
  bool otros;

  String? zProvinciaTrabCliente;
  String? zCiudadTrabCliente;
  String? zCantonTrabCliente;
  String? zCalleTrabCliente;
  String? zNumeroTrabCliente;
  String? zInterseccionDomicilio;
  String? zTelefonoTrabCliente;

  String? zNombrePersonaTransaccion;
  String? zDocumentoPersonaTransa;
  String? zVinculacionEmpresa;

  String? zBienTransaccion;
  double? zPvpTransaccion;
  String? zFormaPago;
  String? zOrigenFondos;

  double? zActivos;
  double? zPasivos;
  double? zPatrimonio;
  double? zVentas;
  double? zCostVentas;
  double? zGastosDeOperacion;
  double? zUtilidadNeta;
  double? zMargenOperacional;

  double? zActivos2;
  double? zPasivos2;
  double? zPatrimonio2;
  double? zVentas2;
  double? zCostVentas2;
  double? zGastosDeOperacion2;
  double? zUtilidadNeta2;
  double? zMargenOperacional2;

  double? zActivos3;
  double? zPasivos3;
  double? zPatrimonio3;
  double? zVentas3;
  double? zCostVentas3;
  double? zGastosDeOperacion3;
  double? zUtilidadNeta3;
  double? zMargenOperacional3;

  String? zNombreRespresentanteLegal;
  String? zDocumentoRepLegal;
  String? zGeneroRepLegal;
  String? zCorreoRepLegal;
  String? zPaisRepLega;
  String? zProvinciaRepLegal;
  String? zCiudadRepLegal;
  String? zCantonRepLegal;
  String? zCalleRepLegal;
  String? zNumeroRepLegal;
  String? zInterseccionRepLegal;
  String? zTelefonoRepLegal;
  String? zNombreConyugue;
  String? zDocConyugue;
  String? zObservacionesKyc;

  bool isPpe;
  String? zDetallePep;
  bool zIsPJuridica;

  // ─── Snapshot para detectar campos cambiados ───
  // Se llena cuando se carga un registro existente desde iDempiere.
  // toJsonUpdate() compara el estado actual contra este snapshot
  // y solo envía los campos que cambiaron → evita el error
  // "Cannot update column X" de iDempiere.
  Map<String, dynamic>? _originalJson;

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
    this.zInterseccionDomicilio,
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
    this.zPaisRepLega,
    this.zProvinciaRepLegal,
    this.zCiudadRepLegal,
    this.zCantonRepLegal,
    this.zCalleRepLegal,
    this.zNumeroRepLegal,
    this.zInterseccionRepLegal,
    this.zTelefonoRepLegal,
    this.zNombreConyugue,
    this.zDocConyugue,
    this.zObservacionesKyc,
    this.isPpe = false,
    this.zDetallePep,
    this.zIsPJuridica = true,
  });

  factory KycJuridicaModel.fromJson(Map<String, dynamic> json) {
    final model = KycJuridicaModel(
      id: json['id'],
      uid: json['uid'],
      adOrgId: json['AD_Org_ID'] != null ? IdempiereRef.fromJson(json['AD_Org_ID']) : null,
      name: json['Name'],
      taxId: json['TaxID'],
      cBpartnerId: json['C_BPartner_ID'] != null ? IdempiereRef.fromJson(json['C_BPartner_ID']) : null,
      actividadEconomica: json['ActividadEconomica'],
      tipoActividad: json['TipoActividad'] is Map ? json['TipoActividad']['id'] as String? : json['TipoActividad'] as String?,
      zCorreoCliente: json['zCorreoCliente'],
      zObjetoSocial: json['ZObjetoSocial'],
      zPaginaInternet: json['ZPaginaInternet'],
      zAgencia: json['ZAgencia'],
      zFecha: json['ZFecha'] != null ? DateTime.tryParse(json['ZFecha']) : null,
      registroCivil: json['RegistroCivil'] ?? false,
      sri: json['SRI'] ?? false,
      funcionJudicial: json['FuncionJudicial'] ?? false,
      bureauCredito: json['BureauCredito'] ?? false,
      antecedentespenales: json['AntecedentesPenales'] ?? false,
      otros: json['Otros'] ?? false,
      zProvinciaTrabCliente: json['zProvinciaTrabajoCliente'],
      zCiudadTrabCliente: json['zCiudadTrabajoCliente'],
      zCantonTrabCliente: json['zCantonTrabajoCliente'],
      zCalleTrabCliente: json['zCalleTrabajoCliente'],
      zNumeroTrabCliente: json['zNumeroTrabajoCliente'],
      zInterseccionDomicilio: json['zInterseccionDomicilio'],
      zTelefonoTrabCliente: json['zTelefonoTrabajoCliente'],
      zNombrePersonaTransaccion: json['zNombrePersonaTransaccion'],
      zDocumentoPersonaTransa: json['zDocumentoPersonaTransa'],
      zVinculacionEmpresa: json['zVinculacionEmpresa'],
      zBienTransaccion: json['zBienTransaccion'],
      zPvpTransaccion: json['zPVPTransaccion']?.toDouble(),
      zFormaPago: json['PaymentRule'] != null ? json['PaymentRule']['id'] : null,
      zOrigenFondos: json['zOrigenFondos'],
      zActivos: json['zActivos']?.toDouble(),
      zPasivos: json['zPasivos']?.toDouble(),
      zPatrimonio: json['zPatrimonio']?.toDouble(),
      zVentas: json['zVentas']?.toDouble(),
      zCostVentas: json['zCostoVentas']?.toDouble(),
      zGastosDeOperacion: json['zGastosdeOperacion']?.toDouble(),
      zUtilidadNeta: json['zUtilidadNeta']?.toDouble(),
      zMargenOperacional: json['zMargenOperacional']?.toDouble(),
      zActivos2: json['ZActivos2']?.toDouble(),
      zPasivos2: json['ZPasivos2']?.toDouble(),
      zPatrimonio2: json['ZPatrimonio2']?.toDouble(),
      zVentas2: json['ZVentas2']?.toDouble(),
      zCostVentas2: json['ZCostVentas2']?.toDouble(),
      zGastosDeOperacion2: json['ZGastosDeOperacion2']?.toDouble(),
      zUtilidadNeta2: json['ZUtildadNeta2']?.toDouble(),
      zMargenOperacional2: json['ZMargenOperacional2']?.toDouble(),
      zActivos3: json['ZActivos3']?.toDouble(),
      zPasivos3: json['ZPasivos3']?.toDouble(),
      zPatrimonio3: json['ZPatrimonio3']?.toDouble(),
      zVentas3: json['ZVentas3']?.toDouble(),
      zCostVentas3: json['ZCostVentas3']?.toDouble(),
      zGastosDeOperacion3: json['ZGastosDeOperacion3']?.toDouble(),
      zUtilidadNeta3: json['ZUtildadNeta3']?.toDouble(),
      zMargenOperacional3: json['ZMargenOperacional3']?.toDouble(),
      zNombreRespresentanteLegal: json['zNombreRespresentanteLegal'],
      zDocumentoRepLegal: json['zDocumentoRepLegal'],
      zGeneroRepLegal: json['zGeneroLegalRep'] != null ? json['zGeneroLegalRep']['id'] : null,
      zCorreoRepLegal: json['zEmailRepLegal'],
      zPaisRepLega: json['zPaisRepLega'],
      zProvinciaRepLegal: json['zProvinciaRepLegal'],
      zCiudadRepLegal: json['zCiudadRepLegal'],
      zCantonRepLegal: json['zCantonRepLegal'],
      zCalleRepLegal: json['zCalleRepLegal'],
      zNumeroRepLegal: json['zNoRepLegal'],
      zInterseccionRepLegal: json['zInterseccionRepLegal'],
      zTelefonoRepLegal: json['zPhoneRepLegal'],
      zNombreConyugue: json['zNombreConyugueRepLegal'],
      zDocConyugue: json['zDocumentoConyugueRepLegal'],
      zObservacionesKyc: json['zObservacionesKYC'],
      isPpe: json['IsPPE'] ?? false,
      zIsPJuridica: json['zIsPJuridica'] ?? true,
    );

    // Guardar snapshot del JSON original para detectar cambios en UPDATE
    model._originalJson = Map<String, dynamic>.from(json);
    return model;
  }

  // ─────────────────────────────────────────────
  // toJsonCreate — para POST (registro nuevo)
  // Envía todos los campos disponibles
  // ─────────────────────────────────────────────
  Map<String, dynamic> toJsonCreate() {
    final map = <String, dynamic>{};

    if (adOrgId != null) map['AD_Org_ID'] = {'id': adOrgId!.id};
    if (cBpartnerId != null) map['C_BPartner_ID'] = {'id': cBpartnerId!.id};
    if (tipoActividad != null) map['TipoActividad'] = tipoActividad;
    if (name != null) map['Name'] = name;
    if (taxId != null) map['TaxID'] = taxId;
    if (actividadEconomica != null) map['ActividadEconomica'] = actividadEconomica;
    if (zCorreoCliente != null) map['zCorreoCliente'] = zCorreoCliente;
    if (zAgencia != null) map['ZAgencia'] = zAgencia;
    if (zObjetoSocial != null) map['ZObjetoSocial'] = zObjetoSocial;
    if (zPaginaInternet != null) map['ZPaginaInternet'] = zPaginaInternet;
    if (zFecha != null) map['ZFecha'] = zFecha!.toIso8601String().split('T')[0];
    map['RegistroCivil'] = registroCivil;
    map['SRI'] = sri;
    map['FuncionJudicial'] = funcionJudicial;
    map['BureauCredito'] = bureauCredito;
    map['AntecedentesPenales'] = antecedentespenales;
    map['Otros'] = otros;
    if (zProvinciaTrabCliente != null) map['zProvinciaTrabajoCliente'] = zProvinciaTrabCliente;
    if (zCiudadTrabCliente != null) map['zCiudadTrabajoCliente'] = zCiudadTrabCliente;
    if (zCantonTrabCliente != null) map['zCantonTrabajoCliente'] = zCantonTrabCliente;
    if (zCalleTrabCliente != null) map['zCalleTrabajoCliente'] = zCalleTrabCliente;
    if (zNumeroTrabCliente != null) map['zNumeroTrabajoCliente'] = zNumeroTrabCliente;
    if (zInterseccionDomicilio != null) map['zInterseccionDomicilio'] = zInterseccionDomicilio;
    if (zTelefonoTrabCliente != null) map['zTelefonoTrabajoCliente'] = zTelefonoTrabCliente;
    if (zNombrePersonaTransaccion != null) map['zNombrePersonaTransaccion'] = zNombrePersonaTransaccion;
    if (zDocumentoPersonaTransa != null) map['zDocumentoPersonaTransa'] = zDocumentoPersonaTransa;
    if (zVinculacionEmpresa != null) map['zVinculacionEmpresa'] = zVinculacionEmpresa;
    if (zBienTransaccion != null) map['zBienTransaccion'] = zBienTransaccion;
    if (zPvpTransaccion != null) map['zPVPTransaccion'] = zPvpTransaccion;
    if (zFormaPago != null) map['PaymentRule'] = zFormaPago;
    if (zOrigenFondos != null) map['zOrigenFondos'] = zOrigenFondos;
    if (zActivos != null) map['zActivos'] = zActivos;
    if (zPasivos != null) map['zPasivos'] = zPasivos;
    if (zPatrimonio != null) map['zPatrimonio'] = zPatrimonio;
    if (zVentas != null) map['zVentas'] = zVentas;
    if (zCostVentas != null) map['zCostoVentas'] = zCostVentas;
    if (zGastosDeOperacion != null) map['zGastosdeOperacion'] = zGastosDeOperacion;
    if (zUtilidadNeta != null) map['zUtilidadNeta'] = zUtilidadNeta;
    if (zMargenOperacional != null) map['zMargenOperacional'] = zMargenOperacional;
    if (zActivos2 != null) map['ZActivos2'] = zActivos2;
    if (zPasivos2 != null) map['ZPasivos2'] = zPasivos2;
    if (zPatrimonio2 != null) map['ZPatrimonio2'] = zPatrimonio2;
    if (zVentas2 != null) map['ZVentas2'] = zVentas2;
    if (zCostVentas2 != null) map['ZCostVentas2'] = zCostVentas2;
    if (zGastosDeOperacion2 != null) map['ZGastosDeOperacion2'] = zGastosDeOperacion2;
    if (zUtilidadNeta2 != null) map['ZUtildadNeta2'] = zUtilidadNeta2;
    if (zMargenOperacional2 != null) map['ZMargenOperacional2'] = zMargenOperacional2;
    if (zActivos3 != null) map['ZActivos3'] = zActivos3;
    if (zPasivos3 != null) map['ZPasivos3'] = zPasivos3;
    if (zPatrimonio3 != null) map['ZPatrimonio3'] = zPatrimonio3;
    if (zVentas3 != null) map['ZVentas3'] = zVentas3;
    if (zCostVentas3 != null) map['ZCostVentas3'] = zCostVentas3;
    if (zGastosDeOperacion3 != null) map['ZGastosDeOperacion3'] = zGastosDeOperacion3;
    if (zUtilidadNeta3 != null) map['ZUtildadNeta3'] = zUtilidadNeta3;
    if (zMargenOperacional3 != null) map['ZMargenOperacional3'] = zMargenOperacional3;
    if (zNombreRespresentanteLegal != null) map['zNombreRespresentanteLegal'] = zNombreRespresentanteLegal;
    if (zDocumentoRepLegal != null) map['zDocumentoRepLegal'] = zDocumentoRepLegal;
    if (zGeneroRepLegal != null) map['zGeneroLegalRep'] = zGeneroRepLegal;
    if (zCorreoRepLegal != null) map['zEmailRepLegal'] = zCorreoRepLegal;
    if (zPaisRepLega != null) map['zPaisRepLega'] = zPaisRepLega;
    if (zProvinciaRepLegal != null) map['zProvinciaRepLegal'] = zProvinciaRepLegal;
    if (zCiudadRepLegal != null) map['zCiudadRepLegal'] = zCiudadRepLegal;
    if (zCantonRepLegal != null) map['zCantonRepLegal'] = zCantonRepLegal;
    if (zCalleRepLegal != null) map['zCalleRepLegal'] = zCalleRepLegal;
    if (zNumeroRepLegal != null) map['zNoRepLegal'] = zNumeroRepLegal;
    if (zInterseccionRepLegal != null) map['zInterseccionRepLegal'] = zInterseccionRepLegal;
    if (zTelefonoRepLegal != null) map['zPhoneRepLegal'] = zTelefonoRepLegal;
    if (zNombreConyugue != null) map['zNombreConyugueRepLegal'] = zNombreConyugue;
    if (zDocConyugue != null) map['zDocumentoConyugueRepLegal'] = zDocConyugue;
    if (zObservacionesKyc != null) map['zObservacionesKYC'] = zObservacionesKyc;
    map['IsPPE'] = isPpe;
    map['zIsRelatedPEP'] = isPpe;
    map['zIsPJuridica'] = true;
    map['zIsPNatural'] = false;

    return map;
  }

  // ─────────────────────────────────────────────
  // toJsonUpdate — para PUT (registro existente)
  // Solo envía los campos que cambiaron respecto al snapshot original.
  // Esto evita "Cannot update column X" porque iDempiere solo recibe
  // los campos que el usuario realmente modificó.
  // ─────────────────────────────────────────────
  Map<String, dynamic> toJsonUpdate() {
    final map = <String, dynamic>{};
    final orig = _originalJson ?? {};

    // ID siempre requerido en UPDATE
    final registroId = idMutable ?? id;
    if (registroId != null) map['id'] = registroId;

    // Helper: agrega el campo solo si cambió respecto al original
    void addIfChanged(String key, dynamic currentValue, dynamic originalValue) {
      if (currentValue != null && currentValue != originalValue) {
        map[key] = currentValue;
      }
    }

    // Campos de texto y números — comparación directa
    addIfChanged('Name', name, orig['Name']);
    addIfChanged('TaxID', taxId, orig['TaxID']);
    addIfChanged('ActividadEconomica', actividadEconomica, orig['ActividadEconomica']);

    // TipoActividad — lista simple (IN, OT, PR, PU)
    final tipoActOrig = orig['TipoActividad'] is Map ? orig['TipoActividad']['id'] : orig['TipoActividad'];
    addIfChanged('TipoActividad', tipoActividad, tipoActOrig);
    addIfChanged('zCorreoCliente', zCorreoCliente, orig['zCorreoCliente']);
    addIfChanged('ZAgencia', zAgencia, orig['ZAgencia']);
    addIfChanged('ZObjetoSocial', zObjetoSocial, orig['ZObjetoSocial']);
    addIfChanged('ZPaginaInternet', zPaginaInternet, orig['ZPaginaInternet']);

    // Fecha
    final fechaStr = zFecha != null ? zFecha!.toIso8601String().split('T')[0] : null;
    final fechaOrig = orig['ZFecha'];
    if (fechaStr != null && fechaStr != fechaOrig) map['ZFecha'] = fechaStr;

    // Booleans de verificación — siempre se incluyen (son seguros para update)
    map['RegistroCivil'] = registroCivil;
    map['SRI'] = sri;
    map['FuncionJudicial'] = funcionJudicial;
    map['BureauCredito'] = bureauCredito;
    map['AntecedentesPenales'] = antecedentespenales;
    map['Otros'] = otros;

    // Dirección
    addIfChanged('zProvinciaTrabajoCliente', zProvinciaTrabCliente, orig['zProvinciaTrabajoCliente']);
    addIfChanged('zCiudadTrabajoCliente', zCiudadTrabCliente, orig['zCiudadTrabajoCliente']);
    addIfChanged('zCantonTrabajoCliente', zCantonTrabCliente, orig['zCantonTrabajoCliente']);
    addIfChanged('zCalleTrabajoCliente', zCalleTrabCliente, orig['zCalleTrabajoCliente']);
    addIfChanged('zNumeroTrabajoCliente', zNumeroTrabCliente, orig['zNumeroTrabajoCliente']);
    addIfChanged('zInterseccionDomicilio', zInterseccionDomicilio, orig['zInterseccionDomicilio']);
    addIfChanged('zTelefonoTrabajoCliente', zTelefonoTrabCliente, orig['zTelefonoTrabajoCliente']);

    // Persona Transacción
    addIfChanged('zNombrePersonaTransaccion', zNombrePersonaTransaccion, orig['zNombrePersonaTransaccion']);
    // zDocumentoPersonaTransa NO se incluye — iDempiere no permite actualizarlo
    addIfChanged('zVinculacionEmpresa', zVinculacionEmpresa, orig['zVinculacionEmpresa']);

    // Transacción
    addIfChanged('zBienTransaccion', zBienTransaccion, orig['zBienTransaccion']);
    addIfChanged('zPVPTransaccion', zPvpTransaccion, orig['zPVPTransaccion']);
    addIfChanged('zOrigenFondos', zOrigenFondos, orig['zOrigenFondos']);

    // Forma de pago — iDempiere lo devuelve como objeto, se envía como string
    final formaPagoOrig = orig['PaymentRule'] is Map ? orig['PaymentRule']['id'] : orig['PaymentRule'];
    addIfChanged('PaymentRule', zFormaPago, formaPagoOrig);

    // Financiera Año 1
    addIfChanged('zActivos', zActivos, orig['zActivos']);
    addIfChanged('zPasivos', zPasivos, orig['zPasivos']);
    addIfChanged('zPatrimonio', zPatrimonio, orig['zPatrimonio']);
    addIfChanged('zVentas', zVentas, orig['zVentas']);
    addIfChanged('zCostoVentas', zCostVentas, orig['zCostoVentas']);
    addIfChanged('zGastosdeOperacion', zGastosDeOperacion, orig['zGastosdeOperacion']);
    addIfChanged('zUtilidadNeta', zUtilidadNeta, orig['zUtilidadNeta']);
    addIfChanged('zMargenOperacional', zMargenOperacional, orig['zMargenOperacional']);

    // Financiera Año 2
    addIfChanged('ZActivos2', zActivos2, orig['ZActivos2']);
    addIfChanged('ZPasivos2', zPasivos2, orig['ZPasivos2']);
    addIfChanged('ZPatrimonio2', zPatrimonio2, orig['ZPatrimonio2']);
    addIfChanged('ZVentas2', zVentas2, orig['ZVentas2']);
    addIfChanged('ZCostVentas2', zCostVentas2, orig['ZCostVentas2']);
    addIfChanged('ZGastosDeOperacion2', zGastosDeOperacion2, orig['ZGastosDeOperacion2']);
    addIfChanged('ZUtildadNeta2', zUtilidadNeta2, orig['ZUtildadNeta2']);
    addIfChanged('ZMargenOperacional2', zMargenOperacional2, orig['ZMargenOperacional2']);

    // Financiera Año 3
    addIfChanged('ZActivos3', zActivos3, orig['ZActivos3']);
    addIfChanged('ZPasivos3', zPasivos3, orig['ZPasivos3']);
    addIfChanged('ZPatrimonio3', zPatrimonio3, orig['ZPatrimonio3']);
    addIfChanged('ZVentas3', zVentas3, orig['ZVentas3']);
    addIfChanged('ZCostVentas3', zCostVentas3, orig['ZCostVentas3']);
    addIfChanged('ZGastosDeOperacion3', zGastosDeOperacion3, orig['ZGastosDeOperacion3']);
    addIfChanged('ZUtildadNeta3', zUtilidadNeta3, orig['ZUtildadNeta3']);
    addIfChanged('ZMargenOperacional3', zMargenOperacional3, orig['ZMargenOperacional3']);

    // Representante Legal
    addIfChanged('zNombreRespresentanteLegal', zNombreRespresentanteLegal, orig['zNombreRespresentanteLegal']);
    addIfChanged('zDocumentoRepLegal', zDocumentoRepLegal, orig['zDocumentoRepLegal']);
    addIfChanged('zEmailRepLegal', zCorreoRepLegal, orig['zEmailRepLegal']);
    addIfChanged('zPaisRepLega', zPaisRepLega, orig['zPaisRepLega']);
    addIfChanged('zProvinciaRepLegal', zProvinciaRepLegal, orig['zProvinciaRepLegal']);
    addIfChanged('zCiudadRepLegal', zCiudadRepLegal, orig['zCiudadRepLegal']);
    addIfChanged('zCantonRepLegal', zCantonRepLegal, orig['zCantonRepLegal']);
    addIfChanged('zCalleRepLegal', zCalleRepLegal, orig['zCalleRepLegal']);
    addIfChanged('zNoRepLegal', zNumeroRepLegal, orig['zNoRepLegal']);
    addIfChanged('zInterseccionRepLegal', zInterseccionRepLegal, orig['zInterseccionRepLegal']);
    addIfChanged('zPhoneRepLegal', zTelefonoRepLegal, orig['zPhoneRepLegal']);
    addIfChanged('zNombreConyugueRepLegal', zNombreConyugue, orig['zNombreConyugueRepLegal']);
    addIfChanged('zDocumentoConyugueRepLegal', zDocConyugue, orig['zDocumentoConyugueRepLegal']);
    addIfChanged('zObservacionesKYC', zObservacionesKyc, orig['zObservacionesKYC']);

    // Género — iDempiere lo devuelve como objeto
    final generoOrig = orig['zGeneroLegalRep'] is Map ? orig['zGeneroLegalRep']['id'] : orig['zGeneroLegalRep'];
    addIfChanged('zGeneroLegalRep', zGeneroRepLegal, generoOrig);

    // PEP — siempre seguro actualizar
    map['IsPPE'] = isPpe;
    map['zIsRelatedPEP'] = isPpe;
    map['zIsPJuridica'] = true;
    map['zIsPNatural'] = false;

    return map;
  }
}