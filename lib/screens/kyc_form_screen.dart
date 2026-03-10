import 'package:flutter/material.dart';
import '../models/kyc_model.dart';
import '../services/idempiere_service.dart';
import '../styles/web_styles.dart';
import '../widgets/datos_generales.dart';
import '../widgets/verificacion_info.dart';
import '../widgets/direccion.dart';
import '../widgets/persona_transaccion.dart';
import '../widgets/situacion_financiera.dart';
import '../widgets/representante_legal.dart';
import '../widgets/tablas_hijas.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../screens/login_screen.dart';

class KycFormScreen extends StatefulWidget {
  final String token;
  final int orgId;
  final int clientId;
  final int roleId; // ✅ NUEVO

  const KycFormScreen({
    super.key,
    required this.token,
    required this.orgId,
    required this.clientId,
    required this.roleId, // ✅ NUEVO
  });

  @override
  State<KycFormScreen> createState() => _KycFormScreenState();
}

class _KycFormScreenState extends State<KycFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final IdempiereService _service = IdempiereService();

  @override
  void initState() {
    super.initState();
    _service.setSession(
      token: widget.token,
      orgId: widget.orgId,
      clientId: widget.clientId,
      roleId: widget.roleId, // ✅ NUEVO
    );
  }

  final KycJuridicaModel _model = KycJuridicaModel();
  bool _guardando = false;
  int _seccionActual = 0;

  final List<Map<String, dynamic>> _secciones = [
    {'titulo': 'Datos Generales', 'icono': Icons.business},
    {'titulo': 'Verificación', 'icono': Icons.verified_user},
    {'titulo': 'Dirección', 'icono': Icons.location_on},
    {'titulo': 'Transacción', 'icono': Icons.person},
    {'titulo': 'Situación Financiera', 'icono': Icons.bar_chart},
    {'titulo': 'Representante Legal', 'icono': Icons.account_circle},
    {'titulo': 'Accionistas y PEP', 'icono': Icons.group},
  ];

  // ✅ Manejo centralizado de token expirado
  // Llama a este método desde cualquier catch que reciba TokenExpiradoException
  Future<void> _manejarTokenExpirado() async {
    if (!mounted) return;

    // Limpiar storage
    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    if (!mounted) return;

    // Mostrar aviso y redirigir al login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('⏱️ Tu sesión expiró. Por favor inicia sesión nuevamente.'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _irASeccion(int index) {
    if (index < _seccionActual) {
      _formKey.currentState?.save();
      setState(() => _seccionActual = index);
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _seccionActual = index);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Corrija los errores de esta sección antes de avanzar'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Por favor complete los campos requeridos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    _formKey.currentState!.save();
    setState(() => _guardando = true);

    try {
      final registroId = _model.idMutable ?? _model.id;

      if (registroId != null) {
        final ok = await _service.actualizarKYC(registroId, _model.toJsonUpdate());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ok
                  ? '✅ Formulario actualizado exitosamente'
                  : '❌ Error al actualizar'),
              backgroundColor: ok ? Colors.green : Colors.red,
            ),
          );
        }
      } else {
        final idCreado = await _service.crearKYCConId(_model.toJsonCreate());
        if (idCreado != null) {
          setState(() => _model.idMutable = idCreado);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Formulario guardado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('❌ Error al guardar el formulario'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } on TokenExpiradoException {
      // ✅ Token expirado durante guardado → redirigir al login
      await _manejarTokenExpirado();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) setState(() => _guardando = false);
  }

  Future<void> _cerrarSesion() async {
    try {
      await _service.logout();
    } catch (_) {}

    const storage = FlutterSecureStorage();
    await storage.deleteAll();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _abrirMenuMovil(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _buildMenuMovil(),
    );
  }

  Widget _buildMenuMovil() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              'Ir a sección',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: WebStyles.primaryBlue,
              ),
            ),
          ),
          const Divider(height: 1),
          ...List.generate(_secciones.length, (index) {
            final esActual = _seccionActual == index;
            return ListTile(
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: esActual ? WebStyles.primaryBlue : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: esActual ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              title: Text(
                _secciones[index]['titulo'],
                style: TextStyle(
                  color: esActual ? WebStyles.primaryBlue : Colors.black87,
                  fontWeight: esActual ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: esActual
                  ? const Icon(Icons.check_circle, color: WebStyles.cyanAccent)
                  : null,
              onTap: () {
                Navigator.pop(context);
                _irASeccion(index);
              },
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 600;
        final isTablet = constraints.maxWidth >= 600 && constraints.maxWidth < 900;
        final isDesktop = constraints.maxWidth >= 900;

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [WebStyles.primaryBlue, WebStyles.secondaryBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // HEADER
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 24,
                      vertical: isMobile ? 10 : 16,
                    ),
                    child: Row(
                      children: [
                        if (!isDesktop)
                          IconButton(
                            onPressed: () => _abrirMenuMovil(context),
                            icon: const Icon(Icons.menu, color: Colors.white),
                            tooltip: 'Ver secciones',
                          ),
                        const Icon(Icons.assignment, color: Colors.white, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isMobile
                                ? 'KYC - P. Jurídica'
                                : 'Conozca a su Cliente - Persona Jurídica',
                            style: WebStyles.titleStyle.copyWith(
                              fontSize: isMobile ? 16 : isTablet ? 20 : 26,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 8 : 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: (_model.idMutable ?? _model.id) != null
                                ? Colors.orange
                                : WebStyles.cyanAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            (_model.idMutable ?? _model.id) != null
                                ? '✏️ Editando'
                                : '🆕 Nuevo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: isMobile ? 11 : 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red[400],
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.logout,
                                color: Colors.white, size: 20),
                            tooltip: 'Cerrar Sesión',
                            onPressed: _cerrarSesion,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // CUERPO
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        isMobile ? 8 : 24,
                        0,
                        isMobile ? 8 : 24,
                        isMobile ? 8 : 24,
                      ),
                      child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(isMobile ? 12 : 20),
                        ),
                        child: isDesktop
                            ? _buildDesktopLayout()
                            : _buildMobileTabletLayout(isTablet),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        Container(
          width: 220,
          decoration: const BoxDecoration(
            color: Color(0xFFF8F9FA),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: WebStyles.primaryBlue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20)),
                ),
                child: const Text(
                  'Secciones',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _secciones.length,
                  itemBuilder: (context, index) {
                    final esActual = _seccionActual == index;
                    return InkWell(
                      onTap: () => _irASeccion(index),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: esActual
                              ? WebStyles.primaryBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: esActual
                                    ? WebStyles.cyanAccent
                                    : Colors.grey[300],
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: esActual
                                        ? WebStyles.primaryBlue
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _secciones[index]['titulo'],
                                style: TextStyle(
                                  color: esActual
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: esActual
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Container(width: 1, color: Colors.grey[200]),
        Expanded(child: _buildContenido()),
      ],
    );
  }

  Widget _buildMobileTabletLayout(bool isTablet) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: WebStyles.primaryBlue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Icon(
                      _secciones[_seccionActual]['icono'] as IconData,
                      color: WebStyles.cyanAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _secciones[_seccionActual]['titulo'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${_seccionActual + 1}/${_secciones.length}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  itemCount: _secciones.length,
                  itemBuilder: (context, index) {
                    final esActual = _seccionActual == index;
                    return GestureDetector(
                      onTap: () => _irASeccion(index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: esActual
                              ? WebStyles.cyanAccent
                              : Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: esActual
                                ? WebStyles.primaryBlue
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              LinearProgressIndicator(
                value: (_seccionActual + 1) / _secciones.length,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  WebStyles.cyanAccent,
                ),
                minHeight: 3,
              ),
            ],
          ),
        ),
        Expanded(child: _buildContenido(isMobile: true)),
      ],
    );
  }

  Widget _buildContenido({bool isMobile = false}) {
    return Column(
      children: [
        if (!isMobile)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: WebStyles.primaryBlue,
              borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Icon(
                  _secciones[_seccionActual]['icono'] as IconData,
                  color: WebStyles.cyanAccent,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  _secciones[_seccionActual]['titulo'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_seccionActual + 1} / ${_secciones.length}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        if (!isMobile)
          LinearProgressIndicator(
            value: (_seccionActual + 1) / _secciones.length,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(
              WebStyles.cyanAccent,
            ),
            minHeight: 4,
          ),
        Expanded(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(isMobile ? 12 : 24),
                    child: _buildSeccion(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(isMobile ? 10 : 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: isMobile
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          )
                        : const BorderRadius.only(
                            bottomRight: Radius.circular(20),
                          ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_seccionActual > 0)
                        ElevatedButton.icon(
                          onPressed: () =>
                              setState(() => _seccionActual--),
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: Text(isMobile ? '' : 'Anterior'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[400],
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 12 : 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      else
                        const SizedBox(),
                      Row(
                        children: [
                          if (_seccionActual == _secciones.length - 1)
                            SizedBox(
                              height: 45,
                              child: ElevatedButton.icon(
                                onPressed: _guardando ? null : _guardar,
                                icon: _guardando
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Icon(
                                        (_model.idMutable ?? _model.id) != null
                                            ? Icons.update
                                            : Icons.save,
                                        size: 18,
                                      ),
                                label: Text(
                                  _guardando
                                      ? 'Guardando...'
                                      : (_model.idMutable ?? _model.id) != null
                                          ? 'Actualizar'
                                          : 'Guardar',
                                  style: WebStyles.buttonTextStyle
                                      .copyWith(fontSize: 14),
                                ),
                                style: WebStyles.primaryButtonStyle,
                              ),
                            ),
                          const SizedBox(width: 8),
                          if (_seccionActual < _secciones.length - 1)
                            ElevatedButton.icon(
                              onPressed: () =>
                                  _irASeccion(_seccionActual + 1),
                              icon: const Icon(Icons.arrow_forward, size: 18),
                              label: Text(isMobile ? '' : 'Siguiente'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: WebStyles.primaryBlue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  horizontal: isMobile ? 12 : 20,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSeccion() {
    switch (_seccionActual) {
      case 0:
        return DatosGenerales(
          model: _model,
          service: _service,
          loginOrgId: widget.orgId,
          loginClientId: widget.clientId,
          onTokenExpirado: _manejarTokenExpirado,
        );
      case 1:
        return VerificacionInfo(model: _model);
      case 2:
        return Direccion(model: _model);
      case 3:
        return PersonaTransaccion(model: _model);
      case 4:
        return SituacionFinanciera(model: _model);
      case 5:
        return RepresentanteLegal(model: _model);
      case 6:
        return TablasHijas(
          personalDataId: _model.idMutable ?? _model.id,
          isPpe: _model.isPpe,
          service: _service,
          onTokenExpirado: _manejarTokenExpirado,
        );
      default:
        return const SizedBox();
    }
  }
}