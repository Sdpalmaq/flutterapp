import 'package:flutter/material.dart';
import '../services/idempiere_service.dart';
import 'kyc_form_screen.dart'; // Tu pantalla actual jurídica
// import 'kyc_natural_screen.dart'; // La futura pantalla natural

class KycRouterScreen extends StatefulWidget {
  final String token;
  final int orgId;
  final int clientId;
  final String usuarioLogin; // Cédula o RUC ingresado en el login
  final int roleId;

  const KycRouterScreen({
    super.key,
    required this.token,
    required this.orgId,
    required this.clientId,
    required this.usuarioLogin,
    required this.roleId,
  });

  @override
  State<KycRouterScreen> createState() => _KycRouterScreenState();
}

class _KycRouterScreenState extends State<KycRouterScreen> {
  final IdempiereService _service = IdempiereService();
  bool _cargando = true;
  bool _mostrarOpciones = false;

  @override
  void initState() {
    super.initState();
    _service.setSession(
      token: widget.token,
      orgId: widget.orgId,
      clientId: widget.clientId,
      roleId: widget.roleId,
    );
    _verificarKycExistente();
  }

  Future<void> _verificarKycExistente() async {
    try {
      // Usamos la función que ya tienes para buscar por RUC/Cédula
      final data = await _service.buscarKYCporRUC(widget.usuarioLogin);

      if (data != null) {
        // ✅ ESCENARIO A: Ya existe un registro en iDempiere
        final esJuridica = data['zIsPJuridica'] ?? true;

        if (mounted) {
          if (esJuridica) {
            // Lo enviamos directo al formulario jurídico
            _irAFormularioJuridico();
          } else {
            // Lo enviamos directo al formulario natural (cuando lo tengas)
            // _irAFormularioNatural();
          }
        }
      } else {
        // ✅ ESCENARIO B: Es un cliente nuevo, debemos preguntarle
        if (mounted) {
          setState(() {
            _cargando = false;
            _mostrarOpciones = true;
          });
        }
      }
    } catch (e) {
      print('Error al verificar: $e');
      setState(() => _cargando = false); // Por seguridad mostramos las opciones
    }
  }

  void _irAFormularioJuridico() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => KycFormScreen(
          token: widget.token,
          orgId: widget.orgId,
          clientId: widget.clientId,
          roleId: widget.roleId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _cargando
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Verificando perfil...'),
                ],
              )
            : _mostrarOpciones
                ? _buildSeleccionPerfil()
                : const SizedBox(),
      ),
    );
  }

  Widget _buildSeleccionPerfil() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.account_box, size: 64, color: Colors.blue),
          const SizedBox(height: 24),
          const Text(
            '¡Bienvenido!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'No hemos encontrado un perfil registrado con esta identificación.\n¿Qué tipo de registro desea crear?',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBotonOpcion(
                icono: Icons.person,
                titulo: 'Persona\nNatural',
                onTap: () {
                  // _irAFormularioNatural();
                },
              ),
              const SizedBox(width: 24),
              _buildBotonOpcion(
                icono: Icons.business,
                titulo: 'Persona\nJurídica',
                onTap: _irAFormularioJuridico,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBotonOpcion(
      {required IconData icono,
      required String titulo,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icono, size: 48, color: Colors.blue[800]),
            const SizedBox(height: 12),
            Text(titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
