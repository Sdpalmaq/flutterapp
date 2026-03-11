import 'package:flutter/material.dart';
import '../models/child_models.dart';
import '../services/idempiere_service.dart';

class TablasHijas extends StatefulWidget {
  final int? personalDataId;
  final bool isPpe;
  final IdempiereService service;
  final VoidCallback onTokenExpirado;
  // ✅ Notifica al padre si las tablas obligatorias están completas
  final void Function(bool validas)? onValidacionChanged;

  const TablasHijas({
    super.key,
    required this.personalDataId,
    required this.isPpe,
    required this.service,
    required this.onTokenExpirado,
    this.onValidacionChanged,
  });

  @override
  State<TablasHijas> createState() => _TablasHijasState();
}

class _TablasHijasState extends State<TablasHijas>
    with SingleTickerProviderStateMixin {
  IdempiereService get _service => widget.service;
  late TabController _tabController;

  List<AccionistaModel> _accionistas = [];
  List<PrincipalClienteModel> _clientes = [];
  List<PepModel> _peps = [];
  List<ReferenciaBancariaModel> _referencias = [];
  List<Map<String, dynamic>> _paises = [];
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    if (widget.personalDataId != null) {
      _cargarDatos();
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    if (!mounted) return;
    setState(() => _cargando = true);
    try {
      final accionistas =
          await _service.obtenerAccionistas(widget.personalDataId!);
      final clientes = await _service.obtenerClientes(widget.personalDataId!);
      final peps = await _service.obtenerPEP(widget.personalDataId!);
      final referencias =
          await _service.obtenerReferenciasBancarias(widget.personalDataId!);
      final paises = await _service.obtenerPaises();
      if (!mounted) return;
      setState(() {
        _accionistas = accionistas;
        _clientes = clientes;
        _peps = peps;
        _referencias = referencias;
        _paises = paises;
        _cargando = false;
      });
      // ✅ Notificar validación al padre después de cargar
      _notificarValidacion();
    } on TokenExpiradoException {
      widget.onTokenExpirado();
    } catch (e) {
      print('Error cargando datos tablas hijas: $e');
      if (mounted) setState(() => _cargando = false);
    }
  }

  // ✅ Valida que las tablas obligatorias tengan al menos 1 registro
  // Si isPpe está activo, la tabla PEP también es obligatoria
  void _notificarValidacion() {
    final tablasBase = _accionistas.isNotEmpty &&
        _clientes.isNotEmpty &&
        _referencias.isNotEmpty;
    final pepValido = !widget.isPpe || _peps.isNotEmpty;
    widget.onValidacionChanged?.call(tablasBase && pepValido);
  }

  // ── Suma porcentajes excluyendo el registro en edición ──
  double _sumaAccionistas({int? excludeId}) => _accionistas
      .where((a) => a.id != excludeId)
      .fold(0.0, (sum, a) => sum + (a.zPorcentajeParticipacion ?? 0));

  double _sumaClientes({int? excludeId}) => _clientes
      .where((c) => c.id != excludeId)
      .fold(0.0, (sum, c) => sum + (c.zPorcentajeVentas ?? 0));

  @override
  Widget build(BuildContext context) {
    if (widget.personalDataId == null) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Primero guarde el formulario principal para poder\nagregar accionistas, clientes y referencias bancarias.',
                style: TextStyle(color: Colors.orange),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // ✅ Indicador global de estado de las tablas
        _buildIndicadorEstado(),
        const SizedBox(height: 8),
        TabBar(
          controller: _tabController,
          labelColor: Colors.blue[800],
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue[800],
          isScrollable: true,
          tabs: [
            _buildTab('Accionistas', _accionistas.isNotEmpty),
            _buildTab('Principales Clientes', _clientes.isNotEmpty),
            _buildTab('Referencias Bancarias', _referencias.isNotEmpty),
            _buildTab(
              'PEP',
              !widget.isPpe || _peps.isNotEmpty,
              obligatorio: widget.isPpe,
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_cargando)
          const Center(child: CircularProgressIndicator())
        else
          SizedBox(
            height: 400,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTablaAccionistas(),
                _buildTablaClientes(),
                _buildTablaReferencias(),
                _buildTablaPEP(),
              ],
            ),
          ),
      ],
    );
  }

  // ✅ Tab con indicador de completo/pendiente
  Widget _buildTab(String label, bool completo, {bool obligatorio = true}) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          if (obligatorio)
            Icon(
              completo ? Icons.check_circle : Icons.error_outline,
              size: 14,
              color: completo ? Colors.green : Colors.orange,
            ),
        ],
      ),
    );
  }

  // ✅ Barra de estado global en la parte superior
  Widget _buildIndicadorEstado() {
    final faltantes = <String>[];
    if (_accionistas.isEmpty) faltantes.add('accionistas');
    if (_clientes.isEmpty) faltantes.add('clientes');
    if (_referencias.isEmpty) faltantes.add('referencias bancarias');
    if (widget.isPpe && _peps.isEmpty) faltantes.add('registros PEP');

    if (faltantes.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.green[50],
          border: Border.all(color: Colors.green[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 18),
            SizedBox(width: 8),
            Text(
              'Todas las secciones requeridas están completas.',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        border: Border.all(color: Colors.orange[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange[700], size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Faltan registros obligatorios: ${faltantes.join(', ')}.',
              style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helper para ejecutar operaciones del servicio con manejo de token ──
  Future<void> _ejecutar(Future<void> Function() accion) async {
    try {
      await accion();
    } on TokenExpiradoException {
      widget.onTokenExpirado();
    } catch (e) {
      print('Error operación tablas hijas: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // ============ ACCIONISTAS ============
  Widget _buildTablaAccionistas() {
    final sumaAcc = _sumaAccionistas();
    return Column(
      children: [
        // Indicador de porcentaje total
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIndicadorPorcentaje(sumaAcc, 'Participación total'),
              ElevatedButton.icon(
                onPressed: () => _mostrarDialogoAccionista(),
                icon: const Icon(Icons.add),
                label: const Text('Agregar Accionista'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
              ),
            ],
          ),
        ),
        Expanded(
          child: _accionistas.isEmpty
              ? _buildVacioObligatorio('Debe registrar al menos un accionista')
              : ListView.builder(
                  itemCount: _accionistas.length,
                  itemBuilder: (context, index) {
                    final a = _accionistas[index];
                    return Card(
                      child: ListTile(
                        title: Text(a.zNombreApellidos ?? ''),
                        subtitle: Text(
                          'Nacionalidad: ${a.zNacionalidad ?? '-'} | '
                          'Participación: ${a.zPorcentajeParticipacion ?? 0}%',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _mostrarDialogoAccionista(accionista: a),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _ejecutar(() => _eliminarAccionista(a)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ============ PRINCIPALES CLIENTES ============
  Widget _buildTablaClientes() {
    final sumaCli = _sumaClientes();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIndicadorPorcentaje(sumaCli, 'Ventas total'),
              ElevatedButton.icon(
                onPressed: () => _mostrarDialogoCliente(),
                icon: const Icon(Icons.add),
                label: const Text('Agregar Cliente'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
              ),
            ],
          ),
        ),
        Expanded(
          child: _clientes.isEmpty
              ? _buildVacioObligatorio('Debe registrar al menos un cliente principal')
              : ListView.builder(
                  itemCount: _clientes.length,
                  itemBuilder: (context, index) {
                    final c = _clientes[index];
                    return Card(
                      child: ListTile(
                        title: Text(c.zNombre ?? ''),
                        subtitle: Text(
                          'Teléfono: ${c.zTelefono ?? '-'} | '
                          'Ventas: ${c.zPorcentajeVentas ?? 0}%',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _mostrarDialogoCliente(cliente: c),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _ejecutar(() => _eliminarCliente(c)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ============ PEP ============
  Widget _buildTablaPEP() {
    if (!widget.isPpe) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          border: Border.all(color: Colors.orange[200]!),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, color: Colors.orange[400], size: 40),
            const SizedBox(height: 12),
            Text(
              'Sección bloqueada',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Esta sección solo está disponible si el Representante Legal\n'
              'o algún Accionista es una Persona Políticamente Expuesta (PEP).\n\n'
              'Active la opción en la pestaña "Representante Legal".',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.orange[700]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // ✅ Aviso de que PEP es obligatorio cuando está activado
        if (_peps.isEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red[50],
              border: Border.all(color: Colors.red[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Debe registrar al menos un PEP porque marcó que existe una Persona Políticamente Expuesta.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () => _mostrarDialogoPEP(),
            icon: const Icon(Icons.add),
            label: const Text('Agregar PEP'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _peps.isEmpty
              ? _buildVacioObligatorio('Debe registrar al menos un registro PEP')
              : ListView.builder(
                  itemCount: _peps.length,
                  itemBuilder: (context, index) {
                    final p = _peps[index];
                    return Card(
                      child: ListTile(
                        title: Text(p.zNombresApellidos ?? ''),
                        subtitle: Text(
                          'RUC/Cédula: ${p.zCedula ?? '-'} | '
                          'Vinculación: ${p.zVinculacion ?? '-'}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _mostrarDialogoPEP(pep: p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _ejecutar(() => _eliminarPEP(p)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ============ REFERENCIAS BANCARIAS ============
  Widget _buildTablaReferencias() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () => _mostrarDialogoReferencia(),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Referencia'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _referencias.isEmpty
              ? _buildVacioObligatorio('Debe registrar al menos una referencia bancaria')
              : ListView.builder(
                  itemCount: _referencias.length,
                  itemBuilder: (context, index) {
                    final r = _referencias[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.account_balance,
                            color: Colors.blue),
                        title: Text(r.bankName ?? ''),
                        subtitle: Text(
                          'No. Cuenta: ${r.bankAccountNo ?? '-'} | '
                          'Tipo: ${r.bankAccountType == 'C' ? 'Corriente' : r.bankAccountType == 'S' ? 'Ahorros' : '-'}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () =>
                                  _mostrarDialogoReferencia(referencia: r),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _ejecutar(() => _eliminarReferencia(r)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // ── Widgets helpers ──

  /// Mensaje cuando una tabla obligatoria está vacía
  Widget _buildVacioObligatorio(String mensaje) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange[400], size: 40),
          const SizedBox(height: 8),
          Text(
            mensaje,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Pastilla de porcentaje total (verde=100%, naranja=<100%, rojo=>100%)
  Widget _buildIndicadorPorcentaje(double suma, String etiqueta) {
    final color = suma == 100
        ? Colors.green
        : suma > 100
            ? Colors.red
            : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$etiqueta: ${suma.toStringAsFixed(1)}% / 100%',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  // ============ DIÁLOGOS ============

  Future<void> _mostrarDialogoAccionista({AccionistaModel? accionista}) async {
    final model = accionista ?? AccionistaModel();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(accionista == null ? 'Nuevo Accionista' : 'Editar Accionista'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: model.zNombreApellidos,
                  decoration: const InputDecoration(
                    labelText: 'Nombres y Apellidos *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo requerido' : null,
                  onChanged: (v) => model.zNombreApellidos = v,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: model.zNacionalidad,
                  decoration: const InputDecoration(
                    labelText: 'Nacionalidad',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => model.zNacionalidad = v,
                ),
                const SizedBox(height: 12),
                // ✅ Porcentaje con validación de suma <= 100%
                TextFormField(
                  initialValue: model.zPorcentajeParticipacion?.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Porcentaje de Participación *',
                    border: OutlineInputBorder(),
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) =>
                      model.zPorcentajeParticipacion = double.tryParse(v),
                  validator: (v) {
                    final val = double.tryParse(v ?? '');
                    if (val == null || val <= 0) {
                      return 'Ingrese un porcentaje mayor a 0';
                    }
                    final sumaExistente =
                        _sumaAccionistas(excludeId: accionista?.id);
                    if (sumaExistente + val > 100) {
                      return 'Supera el 100% (disponible: ${(100 - sumaExistente).toStringAsFixed(1)}%)';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              await _ejecutar(() async {
                final ok = await _service.guardarAccionista(
                    model, widget.personalDataId!);
                if (ok) {
                  if (mounted) _cargarDatos();
                  messenger.showSnackBar(
                    const SnackBar(
                        content: Text('✅ Accionista guardado'),
                        backgroundColor: Colors.green),
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoCliente({PrincipalClienteModel? cliente}) async {
    final model = cliente ?? PrincipalClienteModel();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(cliente == null ? 'Nuevo Cliente' : 'Editar Cliente'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: model.zNombre,
                  decoration: const InputDecoration(
                    labelText: 'Nombre *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo requerido' : null,
                  onChanged: (v) => model.zNombre = v,
                ),
                const SizedBox(height: 12),
                // ✅ Porcentaje con validación de suma <= 100%
                TextFormField(
                  initialValue: model.zPorcentajeVentas?.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Porcentaje de Ventas *',
                    border: OutlineInputBorder(),
                    suffixText: '%',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) =>
                      model.zPorcentajeVentas = double.tryParse(v),
                  validator: (v) {
                    final val = double.tryParse(v ?? '');
                    if (val == null || val <= 0) {
                      return 'Ingrese un porcentaje mayor a 0';
                    }
                    final sumaExistente =
                        _sumaClientes(excludeId: cliente?.id);
                    if (sumaExistente + val > 100) {
                      return 'Supera el 100% (disponible: ${(100 - sumaExistente).toStringAsFixed(1)}%)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: model.zPaisId,
                  decoration: const InputDecoration(
                    labelText: 'País',
                    border: OutlineInputBorder(),
                  ),
                  items: _paises
                      .map((p) => DropdownMenuItem<int>(
                            value: p['id'] as int,
                            child: Text(p['Name'] ?? ''),
                          ))
                      .toList(),
                  onChanged: (v) {
                    model.zPaisId = v;
                    model.zPaisIdentifier =
                        _paises.firstWhere((p) => p['id'] == v)['Name'];
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: model.zTelefono,
                  decoration: const InputDecoration(
                    labelText: 'Teléfono',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  onChanged: (v) => model.zTelefono = v,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              await _ejecutar(() async {
                final ok = await _service.guardarCliente(
                    model, widget.personalDataId!);
                if (ok) {
                  if (mounted) _cargarDatos();
                  messenger.showSnackBar(
                    const SnackBar(
                        content: Text('✅ Cliente guardado'),
                        backgroundColor: Colors.green),
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoPEP({PepModel? pep}) async {
    final model = pep ?? PepModel();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pep == null ? 'Nuevo PEP' : 'Editar PEP'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: model.zNombresApellidos,
                  decoration: const InputDecoration(
                    labelText: 'Nombres y Apellidos *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo requerido' : null,
                  onChanged: (v) => model.zNombresApellidos = v,
                ),
                const SizedBox(height: 12),
                // ✅ Renombrado de "Cédula" a "RUC / Cédula" porque es persona jurídica
                TextFormField(
                  initialValue: model.zCedula,
                  decoration: const InputDecoration(
                    labelText: 'RUC / Cédula',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => model.zCedula = v,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: model.zVinculacion,
                  decoration: const InputDecoration(
                    labelText: 'Vinculación',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (v) => model.zVinculacion = v,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              await _ejecutar(() async {
                final ok =
                    await _service.guardarPEP(model, widget.personalDataId!);
                if (ok) {
                  if (mounted) _cargarDatos();
                  messenger.showSnackBar(
                    const SnackBar(
                        content: Text('✅ PEP guardado'),
                        backgroundColor: Colors.green),
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _mostrarDialogoReferencia(
      {ReferenciaBancariaModel? referencia}) async {
    final model = referencia ?? ReferenciaBancariaModel();
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(referencia == null
            ? 'Nueva Referencia Bancaria'
            : 'Editar Referencia Bancaria'),
        content: SizedBox(
          width: 500,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: model.bankName,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del Banco *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo requerido' : null,
                  onChanged: (v) => model.bankName = v,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: model.bankAccountNo,
                  decoration: const InputDecoration(
                    labelText: 'Número de Cuenta *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Campo requerido' : null,
                  onChanged: (v) => model.bankAccountNo = v,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: model.bankAccountType ?? 'C',
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Cuenta *',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'C', child: Text('Corriente')),
                    DropdownMenuItem(value: 'S', child: Text('Ahorros')),
                  ],
                  onChanged: (v) => model.bankAccountType = v,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              await _ejecutar(() async {
                final ok = await _service.guardarReferenciaBancaria(
                    model, widget.personalDataId!);
                if (ok) {
                  if (mounted) _cargarDatos();
                  messenger.showSnackBar(
                    const SnackBar(
                        content: Text('✅ Referencia bancaria guardada'),
                        backgroundColor: Colors.green),
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  // ============ ELIMINAR ============
  Future<void> _eliminarAccionista(AccionistaModel a) async {
    final confirm = await _mostrarConfirmacion('¿Eliminar este accionista?');
    if (confirm) {
      await _service.eliminarAccionista(a.id!);
      if (mounted) _cargarDatos();
    }
  }

  Future<void> _eliminarCliente(PrincipalClienteModel c) async {
    final confirm = await _mostrarConfirmacion('¿Eliminar este cliente?');
    if (confirm) {
      await _service.eliminarCliente(c.id!);
      if (mounted) _cargarDatos();
    }
  }

  Future<void> _eliminarPEP(PepModel p) async {
    final confirm = await _mostrarConfirmacion('¿Eliminar este registro PEP?');
    if (confirm) {
      await _service.eliminarPEP(p.id!);
      if (mounted) _cargarDatos();
    }
  }

  Future<void> _eliminarReferencia(ReferenciaBancariaModel r) async {
    final confirm =
        await _mostrarConfirmacion('¿Eliminar esta referencia bancaria?');
    if (confirm) {
      await _service.eliminarReferenciaBancaria(r.id!);
      if (mounted) _cargarDatos();
    }
  }

  Future<bool> _mostrarConfirmacion(String mensaje) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Confirmar'),
            content: Text(mensaje),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
            ],
          ),
        ) ??
        false;
  }
}