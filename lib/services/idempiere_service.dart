import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.config.dart';
import '../models/child_models.dart';

// Excepción lanzada cuando el token expira o es inválido
// El widget que llame al servicio debe capturarla y redirigir al login
class TokenExpiradoException implements Exception {
  const TokenExpiradoException();
}

class IdempiereService {
  String? _token;
  int? _orgId;
  int? _clientId;
  int? _roleId; // ✅ NUEVO

  void setSession({
    required String token,
    required int orgId,
    required int clientId,
    required int roleId, // ✅ NUEVO
  }) {
    _token = token;
    _orgId = orgId;
    _clientId = clientId;
    _roleId = roleId; // ✅ NUEVO
  }

  // ✅ login() eliminado — ya no se usa, el login lo maneja LoginScreen

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  // ✅ Verifica si la respuesta es 401 y lanza TokenExpiradoException
  void _verificarAutenticacion(http.Response response) {
    if (response.statusCode == 401) {
      _token = null;
      throw const TokenExpiradoException();
    }
  }

  // ── KYC ──

  Future<bool> crearKYC(Map<String, dynamic> data) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}'),
      headers: _headers,
      body: jsonEncode(data),
    );
    _verificarAutenticacion(response);
    print('Crear KYC: ${response.statusCode} ${response.body}');
    return response.statusCode == 201;
  }

  Future<int?> crearKYCConId(Map<String, dynamic> data) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}'),
      headers: _headers,
      body: jsonEncode(data),
    );
    _verificarAutenticacion(response);
    print('Crear KYC: ${response.statusCode} ${response.body}');
    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return responseData['id'];
    }
    return null;
  }

  Future<bool> actualizarKYC(int id, Map<String, dynamic> data) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.put(
      Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}/$id'),
      headers: _headers,
      body: jsonEncode(data),
    );
    _verificarAutenticacion(response);
    print('Actualizar KYC: ${response.statusCode} ${response.body}');
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> obtenerKYC(int id) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}/$id'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  Future<Map<String, dynamic>?> obtenerListaKYC() async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}?\$top=5'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    if (response.statusCode == 200) return jsonDecode(response.body);
    print('Error: ${response.statusCode} ${response.body}');
    return null;
  }

  Future<Map<String, dynamic>?> buscarKYCporRUC(String ruc) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}'
          '?\$filter=TaxID eq \'$ruc\'&\$top=1'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final records = data['records'] as List;
      if (records.isNotEmpty) return records.first;
    }
    return null;
  }

  // ── Business Partners ──

  Future<List<Map<String, dynamic>>> obtenerBPartners() async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.get(
      Uri.parse(
          '${ApiConfig.baseUrl}/models/C_BPartner?\$filter=IsActive eq \'Y\''),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['records']);
    }
    return [];
  }

  // ── Países ──

  Future<List<Map<String, dynamic>>> obtenerPaises() async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/models/C_Country'
          '?\$orderby=Name&\$top=300'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['records']);
    }
    return [];
  }

  // ── Organizaciones ──

  Future<List<Map<String, dynamic>>> obtenerOrganizaciones() async {
    if (_token == null) throw const TokenExpiradoException();
    final urlString =
        '${ApiConfig.baseUrl}/models/AD_Org?\$filter=IsActive eq true and IsSummary eq false&\$orderby=Name&\$top=100';
    final response = await http.get(
      Uri.parse(Uri.encodeFull(urlString)),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final records = data['records'] as List;
      print('✅ Orgs cargadas: ${records.length}');
      return records.map((e) => Map<String, dynamic>.from(e)).toList();
    }
    return [];
  }

  // ── Tenants ──

  Future<List<Map<String, dynamic>>> obtenerTenants() async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.get(
      Uri.parse(
          '${ApiConfig.baseUrl}/models/AD_Client?\$filter=IsActive eq true&\$orderby=Name&\$top=50'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['records']);
    }
    return [];
  }

  // ── Accionistas ──

  Future<List<AccionistaModel>> obtenerAccionistas(int personalDataId) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_Accionistas'
          '?\$filter=zC_BP_PersonalData_ID eq $personalDataId'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['records'] as List)
          .map((e) => AccionistaModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<bool> guardarAccionista(
      AccionistaModel accionista, int personalDataId) async {
    if (_token == null) throw const TokenExpiradoException();
    if (accionista.id != null) {
      final response = await http.put(
        Uri.parse(
            '${ApiConfig.baseUrl}/models/ZC_BP_Accionistas/${accionista.id}'),
        headers: _headers,
        body: jsonEncode(accionista.toJson(personalDataId)),
      );
      _verificarAutenticacion(response);
      return response.statusCode == 200;
    } else {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_Accionistas'),
        headers: _headers,
        body: jsonEncode(accionista.toJson(personalDataId)),
      );
      _verificarAutenticacion(response);
      return response.statusCode == 201;
    }
  }

  Future<bool> eliminarAccionista(int id) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_Accionistas/$id'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    return response.statusCode == 200;
  }

  // ── Principales Clientes ──

  Future<List<PrincipalClienteModel>> obtenerClientes(
      int personalDataId) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PrincipalesClientes'
          '?\$filter=zC_BP_PersonalData_ID eq $personalDataId'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['records'] as List)
          .map((e) => PrincipalClienteModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<bool> guardarCliente(
      PrincipalClienteModel cliente, int personalDataId) async {
    if (_token == null) throw const TokenExpiradoException();
    if (cliente.id != null) {
      final response = await http.put(
        Uri.parse(
            '${ApiConfig.baseUrl}/models/ZC_BP_PrincipalesClientes/${cliente.id}'),
        headers: _headers,
        body: jsonEncode(cliente.toJson(personalDataId)),
      );
      _verificarAutenticacion(response);
      return response.statusCode == 200;
    } else {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PrincipalesClientes'),
        headers: _headers,
        body: jsonEncode(cliente.toJson(personalDataId)),
      );
      _verificarAutenticacion(response);
      return response.statusCode == 201;
    }
  }

  Future<bool> eliminarCliente(int id) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PrincipalesClientes/$id'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    return response.statusCode == 200;
  }

  // ── PEP ──

  Future<List<PepModel>> obtenerPEP(int personalDataId) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PEP'
          '?\$filter=zC_BP_PersonalData_ID eq $personalDataId'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['records'] as List)
          .map((e) => PepModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<bool> guardarPEP(PepModel pep, int personalDataId) async {
    if (_token == null) throw const TokenExpiradoException();
    if (pep.id != null) {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PEP/${pep.id}'),
        headers: _headers,
        body: jsonEncode(pep.toJson(personalDataId)),
      );
      _verificarAutenticacion(response);
      return response.statusCode == 200;
    } else {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PEP'),
        headers: _headers,
        body: jsonEncode(pep.toJson(personalDataId)),
      );
      _verificarAutenticacion(response);
      return response.statusCode == 201;
    }
  }

  Future<bool> eliminarPEP(int id) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PEP/$id'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    return response.statusCode == 200;
  }

  // ── Referencias Bancarias ──

  Future<List<ReferenciaBancariaModel>> obtenerReferenciasBancarias(
      int personalDataId) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_ReferenciasBancarias'
          '?\$filter=zC_BP_PersonalData_ID eq $personalDataId'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['records'] as List)
          .map((e) => ReferenciaBancariaModel.fromJson(e))
          .toList();
    }
    return [];
  }

  Future<bool> guardarReferenciaBancaria(
      ReferenciaBancariaModel ref, int personalDataId) async {
    if (_token == null) throw const TokenExpiradoException();
    if (ref.id != null) {
      final response = await http.put(
        Uri.parse(
            '${ApiConfig.baseUrl}/models/ZC_BP_ReferenciasBancarias/${ref.id}'),
        headers: _headers,
        body: jsonEncode(ref.toJson(personalDataId)),
      );
      _verificarAutenticacion(response);
      return response.statusCode == 200;
    } else {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_ReferenciasBancarias'),
        headers: _headers,
        body: jsonEncode(ref.toJson(personalDataId)),
      );
      _verificarAutenticacion(response);
      return response.statusCode == 201;
    }
  }

  Future<bool> eliminarReferenciaBancaria(int id) async {
    if (_token == null) throw const TokenExpiradoException();
    final response = await http.delete(
      Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_ReferenciasBancarias/$id'),
      headers: _headers,
    );
    _verificarAutenticacion(response);
    return response.statusCode == 200;
  }

  // ── Cerrar sesión ──

  Future<void> logout() async {
    if (_token == null) return;
    try {
      await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/auth/tokens'),
        headers: _headers,
      );
    } catch (e) {
      print('Error al cerrar sesión en el servidor: $e');
    } finally {
      _token = null;
    }
  }
}
