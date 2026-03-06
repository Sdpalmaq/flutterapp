import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api.config.dart';
import '../models/child_models.dart';

class IdempiereService {
  String? _token;

  // Login y obtener token
  Future<bool> login() async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/tokens'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': ApiConfig.username,
          'password': ApiConfig.password,
          'parameters': {
            'clientId': ApiConfig.clientId,
            'roleId': ApiConfig.roleId,
            'organizationId': ApiConfig.orgId,
            'warehouseId': ApiConfig.warehouseId,
            'language': 'es_EC',
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        print('Token obtenido: $_token');
        return true;
      }
      print('Error login: ${response.statusCode} ${response.body}');
      return false;
    } catch (e) {
      print('Error login: $e');
      return false;
    }
  }

  // Headers con token
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      };

  // Crear registro KYC
  Future<bool> crearKYC(Map<String, dynamic> data) async {
    try {
      if (_token == null) await login();

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}'),
        headers: _headers,
        body: jsonEncode(data),
      );

      print('Crear KYC: ${response.statusCode} ${response.body}');
      return response.statusCode == 201;
    } catch (e) {
      print('Error crear KYC: $e');
      return false;
    }
  }

  // Actualizar registro KYC
  Future<bool> actualizarKYC(int id, Map<String, dynamic> data) async {
    try {
      if (_token == null) await login();

      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}/$id'),
        headers: _headers,
        body: jsonEncode(data),
      );

      print('Actualizar KYC: ${response.statusCode} ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error actualizar KYC: $e');
      return false;
    }
  }

  // Obtener registro KYC por ID
  Future<Map<String, dynamic>?> obtenerKYC(int id) async {
    try {
      if (_token == null) await login();

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}/$id'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('Error obtener KYC: $e');
      return null;
    }
  }

  // Obtener lista de Business Partners
  Future<List<Map<String, dynamic>>> obtenerBPartners() async {
    try {
      if (_token == null) await login();

      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}/models/C_BPartner?\$filter=IsActive eq \'Y\''),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['records']);
      }
      return [];
    } catch (e) {
      print('Error obtener BPartners: $e');
      return [];
    }
  }

  // Obtener lista de registros KYC
  Future<Map<String, dynamic>?> obtenerListaKYC() async {
    try {
      if (_token == null) await login();

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}?'
            '\$top=5'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      print('Error: ${response.statusCode} ${response.body}');
      return null;
    } catch (e) {
      print('Error obtener lista KYC: $e');
      return null;
    }
  }

  // Buscar KYC por RUC
  Future<Map<String, dynamic>?> buscarKYCporRUC(String ruc) async {
    try {
      if (_token == null) await login();

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}'
            '?\$filter=TaxID eq \'$ruc\''
            '&\$top=1'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final records = data['records'] as List;
        if (records.isNotEmpty) {
          return records.first;
        }
      }
      return null;
    } catch (e) {
      print('Error buscar KYC: $e');
      return null;
    }
  }

  // ======= ACCIONISTAS =======
  Future<List<AccionistaModel>> obtenerAccionistas(int personalDataId) async {
    try {
      if (_token == null) await login();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_Accionistas'
            '?\$filter=zC_BP_PersonalData_ID eq $personalDataId'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['records'] as List)
            .map((e) => AccionistaModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error accionistas: $e');
      return [];
    }
  }

  Future<bool> guardarAccionista(
      AccionistaModel accionista, int personalDataId) async {
    try {
      if (_token == null) await login();
      if (accionista.id != null) {
        final response = await http.put(
          Uri.parse(
              '${ApiConfig.baseUrl}/models/ZC_BP_Accionistas/${accionista.id}'),
          headers: _headers,
          body: jsonEncode(accionista.toJson(personalDataId)),
        );
        return response.statusCode == 200;
      } else {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_Accionistas'),
          headers: _headers,
          body: jsonEncode(accionista.toJson(personalDataId)),
        );
        return response.statusCode == 201;
      }
    } catch (e) {
      print('Error guardar accionista: $e');
      return false;
    }
  }

  Future<bool> eliminarAccionista(int id) async {
    try {
      if (_token == null) await login();
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_Accionistas/$id'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error eliminar accionista: $e');
      return false;
    }
  }

// ======= PRINCIPALES CLIENTES =======
  Future<List<PrincipalClienteModel>> obtenerClientes(
      int personalDataId) async {
    try {
      if (_token == null) await login();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PrincipalesClientes'
            '?\$filter=zC_BP_PersonalData_ID eq $personalDataId'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['records'] as List)
            .map((e) => PrincipalClienteModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error clientes: $e');
      return [];
    }
  }

  Future<bool> guardarCliente(
      PrincipalClienteModel cliente, int personalDataId) async {
    try {
      if (_token == null) await login();
      if (cliente.id != null) {
        final response = await http.put(
          Uri.parse(
              '${ApiConfig.baseUrl}/models/ZC_BP_PrincipalesClientes/${cliente.id}'),
          headers: _headers,
          body: jsonEncode(cliente.toJson(personalDataId)),
        );
        return response.statusCode == 200;
      } else {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PrincipalesClientes'),
          headers: _headers,
          body: jsonEncode(cliente.toJson(personalDataId)),
        );
        return response.statusCode == 201;
      }
    } catch (e) {
      print('Error guardar cliente: $e');
      return false;
    }
  }

  Future<bool> eliminarCliente(int id) async {
    try {
      if (_token == null) await login();
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PrincipalesClientes/$id'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error eliminar cliente: $e');
      return false;
    }
  }

// ======= PEP =======
  Future<List<PepModel>> obtenerPEP(int personalDataId) async {
    try {
      if (_token == null) await login();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PEP'
            '?\$filter=zC_BP_PersonalData_ID eq $personalDataId'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['records'] as List)
            .map((e) => PepModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error PEP: $e');
      return [];
    }
  }

  Future<bool> guardarPEP(PepModel pep, int personalDataId) async {
    try {
      if (_token == null) await login();
      if (pep.id != null) {
        final response = await http.put(
          Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PEP/${pep.id}'),
          headers: _headers,
          body: jsonEncode(pep.toJson(personalDataId)),
        );
        return response.statusCode == 200;
      } else {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PEP'),
          headers: _headers,
          body: jsonEncode(pep.toJson(personalDataId)),
        );
        return response.statusCode == 201;
      }
    } catch (e) {
      print('Error guardar PEP: $e');
      return false;
    }
  }

  Future<bool> eliminarPEP(int id) async {
    try {
      if (_token == null) await login();
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_PEP/$id'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error eliminar PEP: $e');
      return false;
    }
  }

  // Crear KYC y retornar el ID creado
  Future<int?> crearKYCConId(Map<String, dynamic> data) async {
    try {
      if (_token == null) await login();

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/models/${ApiConfig.tableName}'),
        headers: _headers,
        body: jsonEncode(data),
      );

      print('Crear KYC: ${response.statusCode} ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return responseData['id'];
      }
      return null;
    } catch (e) {
      print('Error crear KYC: $e');
      return null;
    }
  }

  // ======= REFERENCIAS BANCARIAS =======
  Future<List<ReferenciaBancariaModel>> obtenerReferenciasBancarias(
      int personalDataId) async {
    try {
      if (_token == null) await login();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_ReferenciasBancarias'
            '?\$filter=zC_BP_PersonalData_ID eq $personalDataId'),
        headers: _headers,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['records'] as List)
            .map((e) => ReferenciaBancariaModel.fromJson(e))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error referencias bancarias: $e');
      return [];
    }
  }

  Future<bool> guardarReferenciaBancaria(
      ReferenciaBancariaModel ref, int personalDataId) async {
    try {
      if (_token == null) await login();
      if (ref.id != null) {
        final response = await http.put(
          Uri.parse(
              '${ApiConfig.baseUrl}/models/ZC_BP_ReferenciasBancarias/${ref.id}'),
          headers: _headers,
          body: jsonEncode(ref.toJson(personalDataId)),
        );
        return response.statusCode == 200;
      } else {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_ReferenciasBancarias'),
          headers: _headers,
          body: jsonEncode(ref.toJson(personalDataId)),
        );
        return response.statusCode == 201;
      }
    } catch (e) {
      print('Error guardar referencia bancaria: $e');
      return false;
    }
  }

  Future<bool> eliminarReferenciaBancaria(int id) async {
    try {
      if (_token == null) await login();
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/models/ZC_BP_ReferenciasBancarias/$id'),
        headers: _headers,
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Error eliminar referencia bancaria: $e');
      return false;
    }
  }
}
