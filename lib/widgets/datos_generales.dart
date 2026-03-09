import 'package:flutter/material.dart';
import '../models/kyc_model.dart';
import '../services/idempiere_service.dart';
import '../styles/web_styles.dart';
import 'responsive_row.dart';

class DatosGenerales extends StatefulWidget {
  final KycJuridicaModel model;
  final IdempiereService service; // ← agregar
  final int loginOrgId; // ← agregar
  final int loginClientId; // ← agregar

  const DatosGenerales({
    super.key,
    required this.model,
    required this.service, // ← agregar
    required this.loginOrgId, // ← agregar
    required this.loginClientId, // ← agregar
  });
  @override
  State<DatosGenerales> createState() => _DatosGeneralesState();
}

class _DatosGeneralesState extends State<DatosGenerales> {
  //final IdempiereService _service = IdempiereService();
  IdempiereService get _service => widget.service;

  bool _buscando = false;

  late final TextEditingController _nameController;
  late final TextEditingController _taxIdController;
  late final TextEditingController _actividadController;
  late final TextEditingController _correoController;
  late final TextEditingController _agenciaController;
  late final TextEditingController _objetoSocialController;
  late final TextEditingController _paginaInternetController;
  List<Map<String, dynamic>> _organizaciones = [];
  List<Map<String, dynamic>> _tenants = []; // ← nuevo

  // true si el registro ya existe en iDempiere
  bool get _esRegistroExistente =>
      widget.model.idMutable != null || widget.model.id != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.model.name ?? '');
    _taxIdController = TextEditingController(text: widget.model.taxId ?? '');
    _actividadController =
        TextEditingController(text: widget.model.actividadEconomica ?? '');
    _correoController =
        TextEditingController(text: widget.model.zCorreoCliente ?? '');
    _agenciaController =
        TextEditingController(text: widget.model.zAgencia ?? '');
    _objetoSocialController =
        TextEditingController(text: widget.model.zObjetoSocial ?? '');
    _paginaInternetController =
        TextEditingController(text: widget.model.zPaginaInternet ?? '');
    if (widget.model.adOrgId == null) {
      widget.model.adOrgId = IdempiereRef(
        id: widget.loginOrgId,
        identifier: '',
      );
    }

    // Preseleccionar client del login si el modelo no tiene uno ya
    if (widget.model.adClientId == null) {
      widget.model.adClientId = IdempiereRef(
        id: widget.loginClientId,
        identifier: '',
      );
    }
    _cargarOrganizaciones();
    _cargarClientes(); // ← nuevo método
  }

  @override
  void dispose() {
    _nameController.dispose();
    _taxIdController.dispose();
    _actividadController.dispose();
    _correoController.dispose();
    _agenciaController.dispose();
    _objetoSocialController.dispose();
    _paginaInternetController.dispose();
    super.dispose();
  }

  Future<void> _cargarOrganizaciones() async {
    //await _service.login();
    final orgs = await _service.obtenerOrganizaciones();
    setState(() => _organizaciones = orgs);
  }

  Future<void> _cargarClientes() async {
    final tenants = await _service.obtenerTenants();
    setState(() => _tenants = tenants);
  }

  Future<void> _buscarPorRUC(String ruc) async {
    if (ruc.length < 10) return;
    setState(() => _buscando = true);
    try {
      //await _service.login();
      final data = await _service.buscarKYCporRUC(ruc);
      if (data != null) {
        final kyc = KycJuridicaModel.fromJson(data);
        setState(() {
          widget.model.name = kyc.name;
          widget.model.taxId = kyc.taxId;
          widget.model.actividadEconomica = kyc.actividadEconomica;
          widget.model.tipoActividad = kyc.tipoActividad;
          widget.model.zCorreoCliente = kyc.zCorreoCliente;
          widget.model.zAgencia = kyc.zAgencia;
          widget.model.zObjetoSocial = kyc.zObjetoSocial;
          widget.model.zPaginaInternet = kyc.zPaginaInternet;
          widget.model.zFecha = kyc.zFecha;
          widget.model.registroCivil = kyc.registroCivil;
          widget.model.sri = kyc.sri;
          widget.model.funcionJudicial = kyc.funcionJudicial;
          widget.model.zSuperintendenciaCias = kyc.zSuperintendenciaCias;
          widget.model.antecedentespenales = kyc.antecedentespenales;
          widget.model.otros = kyc.otros;
          widget.model.zProvinciaTrabCliente = kyc.zProvinciaTrabCliente;
          widget.model.zCiudadTrabCliente = kyc.zCiudadTrabCliente;
          widget.model.zCantonTrabCliente = kyc.zCantonTrabCliente;
          widget.model.zCalleTrabCliente = kyc.zCalleTrabCliente;
          widget.model.zNumeroTrabCliente = kyc.zNumeroTrabCliente;
          widget.model.zInterseccionDomicilio = kyc.zInterseccionDomicilio;
          widget.model.zTelefonoTrabCliente = kyc.zTelefonoTrabCliente;
          widget.model.zNombrePersonaTransaccion =
              kyc.zNombrePersonaTransaccion;
          widget.model.zDocumentoPersonaTransa = kyc.zDocumentoPersonaTransa;
          widget.model.zVinculacionEmpresa = kyc.zVinculacionEmpresa;
          widget.model.zBienTransaccion = kyc.zBienTransaccion;
          widget.model.zPvpTransaccion = kyc.zPvpTransaccion;
          widget.model.zFormaPago = kyc.zFormaPago;
          widget.model.zOrigenFondos = kyc.zOrigenFondos;
          widget.model.zActivos = kyc.zActivos;
          widget.model.zPasivos = kyc.zPasivos;
          widget.model.zPatrimonio = kyc.zPatrimonio;
          widget.model.zVentas = kyc.zVentas;
          widget.model.zCostVentas = kyc.zCostVentas;
          widget.model.zGastosDeOperacion = kyc.zGastosDeOperacion;
          widget.model.zUtilidadNeta = kyc.zUtilidadNeta;
          widget.model.zMargenOperacional = kyc.zMargenOperacional;
          widget.model.zActivos2 = kyc.zActivos2;
          widget.model.zPasivos2 = kyc.zPasivos2;
          widget.model.zPatrimonio2 = kyc.zPatrimonio2;
          widget.model.zVentas2 = kyc.zVentas2;
          widget.model.zCostVentas2 = kyc.zCostVentas2;
          widget.model.zGastosDeOperacion2 = kyc.zGastosDeOperacion2;
          widget.model.zUtilidadNeta2 = kyc.zUtilidadNeta2;
          widget.model.zMargenOperacional2 = kyc.zMargenOperacional2;
          widget.model.zActivos3 = kyc.zActivos3;
          widget.model.zPasivos3 = kyc.zPasivos3;
          widget.model.zPatrimonio3 = kyc.zPatrimonio3;
          widget.model.zVentas3 = kyc.zVentas3;
          widget.model.zCostVentas3 = kyc.zCostVentas3;
          widget.model.zGastosDeOperacion3 = kyc.zGastosDeOperacion3;
          widget.model.zUtilidadNeta3 = kyc.zUtilidadNeta3;
          widget.model.zMargenOperacional3 = kyc.zMargenOperacional3;
          widget.model.zNombreRespresentanteLegal =
              kyc.zNombreRespresentanteLegal;
          widget.model.zDocumentoRepLegal = kyc.zDocumentoRepLegal;
          widget.model.zGeneroRepLegal = kyc.zGeneroRepLegal;
          widget.model.zCorreoRepLegal = kyc.zCorreoRepLegal;
          widget.model.zPaisRepLega = kyc.zPaisRepLega;
          widget.model.zProvinciaRepLegal = kyc.zProvinciaRepLegal;
          widget.model.zCiudadRepLegal = kyc.zCiudadRepLegal;
          widget.model.zCantonRepLegal = kyc.zCantonRepLegal;
          widget.model.zCalleRepLegal = kyc.zCalleRepLegal;
          widget.model.zNumeroRepLegal = kyc.zNumeroRepLegal;
          widget.model.zInterseccionRepLegal = kyc.zInterseccionRepLegal;
          widget.model.zTelefonoRepLegal = kyc.zTelefonoRepLegal;
          widget.model.zNombreConyugue = kyc.zNombreConyugue;
          widget.model.zDocConyugue = kyc.zDocConyugue;
          widget.model.zObservacionesKyc = kyc.zObservacionesKyc;
          widget.model.isPpe = kyc.isPpe;
          if (kyc.id != null) widget.model.idMutable = kyc.id;

          _nameController.text = kyc.name ?? '';
          _actividadController.text = kyc.actividadEconomica ?? '';
          _correoController.text = kyc.zCorreoCliente ?? '';
          _agenciaController.text = kyc.zAgencia ?? '';
          _objetoSocialController.text = kyc.zObjetoSocial ?? '';
          _paginaInternetController.text = kyc.zPaginaInternet ?? '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Registro encontrado y cargado'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ℹ️ No se encontró registro con ese RUC'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() => _buscando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila 1 - Agencia y Fecha
        ResponsiveRow(children: [
          // ── AGENCIA (AD_Org_ID) ──
          DropdownButtonFormField<int>(
            value: widget.model.adOrgId?.id,
            decoration: InputDecoration(
              labelText: 'Agencia',
              prefixIcon: Icon(Icons.store, color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[50],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: WebStyles.cyanAccent, width: 2),
              ),
            ),
            items: _organizaciones
                .map((o) => DropdownMenuItem<int>(
                      value: o['id'] as int,
                      child: Text(o['Name'] ?? o['name'] ?? ''),
                    ))
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              final org = _organizaciones.firstWhere((o) => o['id'] == v);
              setState(() {
                widget.model.adOrgId = IdempiereRef(
                  id: v,
                  identifier: org['Name'] ?? '',
                );
              });
            },
          ),
          // ── VENDEDOR/TENANT (AD_Client_ID) ──
          DropdownButtonFormField<int>(
            value: widget.model.adClientId?.id,
            decoration: InputDecoration(
              labelText: 'Vendedor',
              prefixIcon: Icon(Icons.person_pin, color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[50],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: WebStyles.cyanAccent, width: 2),
              ),
            ),
            items: _tenants
                .map((t) => DropdownMenuItem<int>(
                      value: t['id'] as int,
                      child: Text(t['Name'] ?? t['name'] ?? ''),
                    ))
                .toList(),
            onChanged: (v) {
              if (v == null) return;
              final tenant = _tenants.firstWhere((t) => t['id'] == v);
              setState(() {
                widget.model.adClientId = IdempiereRef(
                  id: v,
                  identifier: tenant['Name'] ?? '',
                );
              });
            },
          ),
          // ── FECHA ──
          _buildDateField(
            label: 'Fecha',
            required: true,
            onSaved: (v) => widget.model.zFecha = v,
          ),
        ]),
        // Fila 2 - RUC y Razón Social
        ResponsiveRow(children: [
          // ── RUC: bloqueado si el registro ya existe ──
          TextFormField(
            controller: _taxIdController,
            readOnly: _esRegistroExistente,
            style: TextStyle(
              color: _esRegistroExistente ? Colors.grey[600] : Colors.black,
            ),
            decoration: InputDecoration(
              labelText: 'RUC *',
              prefixIcon: Icon(Icons.badge, color: Colors.grey[600]),
              filled: true,
              fillColor:
                  _esRegistroExistente ? Colors.grey[100] : Colors.grey[50],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color:
                      _esRegistroExistente ? Colors.grey : WebStyles.cyanAccent,
                  width: 2,
                ),
              ),
              // Candado cuando está bloqueado, lupa cuando es nuevo
              suffixIcon: _esRegistroExistente
                  ? Tooltip(
                      message: 'El RUC no puede modificarse',
                      child: Icon(Icons.lock, color: Colors.grey[400]),
                    )
                  : _buscando
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search,
                              color: WebStyles.primaryBlue),
                          onPressed: () => _buscarPorRUC(_taxIdController.text),
                        ),
            ),
            onChanged: _esRegistroExistente
                ? null
                : (v) {
                    widget.model.taxId = v;
                    if (v.length >= 10) _buscarPorRUC(v);
                  },
            onSaved: (v) => widget.model.taxId = v,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Campo requerido' : null,
          ),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Razón Social *',
              prefixIcon: Icon(Icons.business, color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[50],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: WebStyles.cyanAccent, width: 2),
              ),
            ),
            onChanged: (v) => widget.model.name = v,
            onSaved: (v) => widget.model.name = v,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Campo requerido' : null,
          ),
        ]),
        // Objeto Social
        _buildTextField(
          label: 'Objeto Social',
          icon: Icons.description,
          controller: _objetoSocialController,
          onSaved: (v) => widget.model.zObjetoSocial = v,
        ),
        const SizedBox(height: 16),
        // Tipo de Actividad Económica
        StatefulBuilder(
          builder: (context, setDropState) {
            return DropdownButtonFormField<String>(
              value: widget.model.tipoActividad,
              decoration: InputDecoration(
                labelText: 'Tipo de Actividad Económica *',
                prefixIcon: Icon(Icons.category, color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[50],
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: WebStyles.cyanAccent, width: 2),
                ),
              ),
              items: const [
                DropdownMenuItem(value: 'IN', child: Text('Independiente')),
                DropdownMenuItem(value: 'OT', child: Text('Otros')),
                DropdownMenuItem(value: 'PR', child: Text('Empleado Privado')),
                DropdownMenuItem(
                    value: 'PU', child: Text('Funcionario Publico')),
              ],
              onChanged: (v) {
                setDropState(() => widget.model.tipoActividad = v);
              },
              onSaved: (v) => widget.model.tipoActividad = v,
              validator: (v) => v == null ? 'Campo requerido' : null,
            );
          },
        ),
        const SizedBox(height: 16),
        // Actividad Económica
        _buildTextField(
          label: 'Actividad Económica',
          icon: Icons.work,
          required: true,
          controller: _actividadController,
          onSaved: (v) => widget.model.actividadEconomica = v,
        ),
        const SizedBox(height: 16),
        // Página Internet y Correo
        ResponsiveRow(children: [
          _buildTextField(
            label: 'Página Internet',
            icon: Icons.language,
            controller: _paginaInternetController,
            onSaved: (v) => widget.model.zPaginaInternet = v,
          ),
          TextFormField(
            controller: _correoController,
            decoration: InputDecoration(
              labelText: 'Correo Electrónico *',
              prefixIcon: Icon(Icons.email, color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[50],
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: WebStyles.cyanAccent, width: 2),
              ),
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) => widget.model.zCorreoCliente = v,
            onSaved: (v) => widget.model.zCorreoCliente = v,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Campo requerido';
              if (!v.contains('@')) return 'Correo inválido';
              return null;
            },
          ),
        ]),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool required = false,
    TextInputType? keyboardType,
    TextEditingController? controller,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: WebStyles.cyanAccent, width: 2),
        ),
      ),
      validator: required
          ? (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null
          : null,
      onSaved: onSaved,
      onChanged: onSaved,
    );
  }

  Widget _buildDateField({
    required String label,
    bool required = false,
    void Function(DateTime?)? onSaved,
  }) {
    final controller = TextEditingController(
      text: widget.model.zFecha != null
          ? '${widget.model.zFecha!.day}/${widget.model.zFecha!.month}/${widget.model.zFecha!.year}'
          : '',
    );
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: WebStyles.cyanAccent, width: 2),
        ),
      ),
      validator: required
          ? (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null
          : null,
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: widget.model.zFecha ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          controller.text = '${date.day}/${date.month}/${date.year}';
          onSaved?.call(date);
        }
      },
    );
  }
}
