import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../config/api.config.dart';
import '../screens/kyc_form_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _storage = const FlutterSecureStorage();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _userController = TextEditingController();
  final _passController = TextEditingController();

  bool _verificandoToken = true;
  bool _cargando = false;
  bool _ocultarPassword = true;
  String? _error;

  int _paso = 0;
  String? _tokenPreliminar;

  List<Map<String, dynamic>> _clientes = [];
  List<Map<String, dynamic>> _roles = [];
  List<Map<String, dynamic>> _organizaciones = [];
  List<Map<String, dynamic>> _todosLosRoles = [];
  List<Map<String, dynamic>> _todasLasOrgs = [];

  Map<String, dynamic>? _clienteSeleccionado;
  Map<String, dynamic>? _rolSeleccionado;
  Map<String, dynamic>? _orgSeleccionada;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _verificarTokenGuardado();
  }

  @override
  void dispose() {
    _animController.dispose();
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  // ── Verifica si hay sesión activa guardada ──
  Future<void> _verificarTokenGuardado() async {
    try {
      final token = await _storage.read(key: 'idempiere_token');
      final orgId = await _storage.read(key: 'idempiere_org_id');
      final clientId = await _storage.read(key: 'idempiere_client_id');
      final roleId =
          await _storage.read(key: 'idempiere_role_id'); // ✅ leer roleId

      if (token != null && orgId != null && clientId != null) {
        final response = await http.get(
          Uri.parse(
              '${ApiConfig.baseUrl}/models/${ApiConfig.tableName}?\$top=1'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200 && mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => KycFormScreen(
                token: token,
                orgId: int.parse(orgId),
                clientId: int.parse(clientId),
                roleId: int.tryParse(roleId ?? '0') ?? 0, // ✅ pasar roleId
              ),
            ),
          );
          return;
        }
      }
    } catch (_) {}

    setState(() => _verificandoToken = false);
    _animController.forward();
  }

  // ── Paso 1: Login con usuario/contraseña ──
  Future<void> _loginCredenciales() async {
    if (_userController.text.isEmpty || _passController.text.isEmpty) return;
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/tokens'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userName': _userController.text.trim(),
          'password': _passController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _tokenPreliminar = data['token'];
        setState(() {
          _clientes = List<Map<String, dynamic>>.from(data['clients'] ?? []);
          _todosLosRoles = List<Map<String, dynamic>>.from(data['roles'] ?? []);
          _todasLasOrgs =
              List<Map<String, dynamic>>.from(data['organizations'] ?? []);
          _paso = 1;
        });
        _animController
          ..reset()
          ..forward();
      } else {
        final data = jsonDecode(response.body);
        setState(() => _error = data['detail'] ?? 'Credenciales incorrectas');
      }
    } catch (e) {
      setState(() => _error = 'Error de conexión: $e');
    }
    setState(() => _cargando = false);
  }

  // ── Paso 2: Seleccionar cliente → cargar roles ──
  Future<void> _seleccionarCliente(Map<String, dynamic> cliente) async {
    setState(() {
      _clienteSeleccionado = cliente;
      _cargando = true;
      _error = null;
    });

    try {
      final url =
          Uri.parse('${ApiConfig.baseUrl}/auth/roles?client=${cliente['id']}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_tokenPreliminar',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _roles = List<Map<String, dynamic>>.from(data['roles'] ?? []);
          _paso = 2;
          _error = null;
        });
        _animController
          ..reset()
          ..forward();
      } else {
        final data = jsonDecode(response.body);
        setState(() => _error = data['detail'] ?? 'Error al cargar roles');
      }
    } catch (e) {
      setState(() => _error = 'Error de conexión: $e');
    }

    setState(() => _cargando = false);
  }

  // ── Paso 3: Seleccionar rol → cargar organizaciones ──
  Future<void> _seleccionarRol(Map<String, dynamic> rol) async {
    setState(() {
      _rolSeleccionado = rol;
      _cargando = true;
      _error = null;
    });

    try {
      final url = Uri.parse(
          '${ApiConfig.baseUrl}/auth/organizations?client=${_clienteSeleccionado!['id']}&role=${rol['id']}');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_tokenPreliminar',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _organizaciones =
              List<Map<String, dynamic>>.from(data['organizations'] ?? []);
          _paso = 3;
        });
        _animController
          ..reset()
          ..forward();
      } else {
        setState(() => _error = 'Error al cargar organizaciones');
      }
    } catch (e) {
      setState(() => _error = 'Error de red al cargar organizaciones');
    }

    setState(() => _cargando = false);
  }

  // ── Paso 4: Seleccionar org → login final ──
  Future<void> _seleccionarOrg(Map<String, dynamic> org) async {
    setState(() {
      _orgSeleccionada = org;
      _cargando = true;
      _error = null;
    });

    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/auth/tokens'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_tokenPreliminar',
        },
        body: jsonEncode({
          'clientId': _clienteSeleccionado!['id'],
          'roleId': _rolSeleccionado!['id'],
          'organizationId': org['id'],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final tokenFinal = data['token'];

        // Guardar sesión completa incluyendo roleId ✅
        await _storage.write(key: 'idempiere_token', value: tokenFinal);
        await _storage.write(
            key: 'idempiere_org_id', value: org['id'].toString());
        await _storage.write(
            key: 'idempiere_client_id',
            value: _clienteSeleccionado!['id'].toString());
        await _storage.write(
            key: 'idempiere_role_id',
            value: _rolSeleccionado!['id'].toString()); // ✅ ya estaba

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => KycFormScreen(
                token: tokenFinal,
                orgId: org['id'] as int,
                clientId: _clienteSeleccionado!['id'] as int,
                roleId: _rolSeleccionado!['id'] as int, // ✅ NUEVO
              ),
            ),
          );
        }
      } else {
        final data = jsonDecode(response.body);
        setState(
            () => _error = data['detail'] ?? 'Error al establecer el contexto');
      }
    } catch (e) {
      setState(() => _error = 'Error de conexión');
    }

    setState(() => _cargando = false);
  }

  void _volverPaso() {
    setState(() {
      _error = null;
      if (_paso > 0) _paso--;
    });
    _animController
      ..reset()
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_verificandoToken) {
      return const Scaffold(
        body: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: CircularProgressIndicator(color: Color(0xFF00C9FF)),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: Card(
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: _buildContenido(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContenido() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildEncabezado(),
        const SizedBox(height: 28),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: KeyedSubtree(
            key: ValueKey(_paso),
            child: switch (_paso) {
              0 => _buildPasoCredenciales(),
              1 => _buildPasoSeleccion(
                  titulo: 'Grupo Empresarial',
                  icono: Icons.business,
                  items: _clientes,
                  onTap: _seleccionarCliente,
                ),
              2 => _buildPasoSeleccion(
                  titulo: 'Rol',
                  icono: Icons.admin_panel_settings,
                  items: _roles,
                  onTap: _seleccionarRol,
                ),
              3 => _buildPasoSeleccion(
                  titulo: 'Organización / Agencia',
                  icono: Icons.store,
                  items: _organizaciones,
                  onTap: _seleccionarOrg,
                ),
              _ => const SizedBox(),
            },
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _error!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
        if (_paso > 0) ...[
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _cargando ? null : _volverPaso,
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Volver'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1E3C72),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildEncabezado() {
    final titulos = [
      'Iniciar Sesión',
      'Grupo Empresarial',
      'Seleccionar Rol',
      'Seleccionar Agencia',
    ];
    final subtitulos = [
      'Formulario KYC - Persona Jurídica',
      'Seleccione su grupo empresarial',
      'Seleccione su rol',
      'Seleccione su organización',
    ];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child:
              const Icon(Icons.assignment_ind, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 16),
        Text(
          titulos[_paso],
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3C72),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitulos[_paso],
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (i) {
            final activo = i == _paso;
            final completado = i < _paso;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: activo ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: completado || activo
                    ? const Color(0xFF00C9FF)
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildPasoCredenciales() {
    return Column(
      children: [
        TextFormField(
          controller: _userController,
          decoration: InputDecoration(
            labelText: 'Usuario',
            prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00C9FF), width: 2),
            ),
          ),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _passController,
          obscureText: _ocultarPassword,
          decoration: InputDecoration(
            labelText: 'Contraseña',
            prefixIcon: Icon(Icons.lock, color: Colors.grey[600]),
            suffixIcon: IconButton(
              icon: Icon(
                _ocultarPassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[600],
              ),
              onPressed: () =>
                  setState(() => _ocultarPassword = !_ocultarPassword),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF00C9FF), width: 2),
            ),
          ),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _loginCredenciales(),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _cargando ? null : _loginCredenciales,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3C72),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: _cargando
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasoSeleccion({
    required String titulo,
    required IconData icono,
    required List<Map<String, dynamic>> items,
    required void Function(Map<String, dynamic>) onTap,
  }) {
    if (_cargando) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF1E3C72)),
        ),
      );
    }

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(Icons.inbox, color: Colors.grey[400], size: 48),
            const SizedBox(height: 12),
            Text(
              'No hay opciones disponibles',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () => onTap(item),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3C72).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child:
                        Icon(icono, color: const Color(0xFF1E3C72), size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item['name'] ?? item['Name'] ?? item['identifier'] ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
