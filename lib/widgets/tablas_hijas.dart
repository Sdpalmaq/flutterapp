import 'package:flutter/material.dart';
import '../models/child_models.dart';
import '../services/idempiere_service.dart';

class TablasHijas extends StatefulWidget {
  final int? personalDataId;
  final bool isPpe;
  final IdempiereService service;

  const TablasHijas({
    super.key,
    required this.personalDataId,
    required this.isPpe,
    required this.service,
  });

  @override
  State<TablasHijas> createState() => _TablasHijasState();
}

class _TablasHijasState extends State<TablasHijas>
    with SingleTickerProviderStateMixin {
  //final IdempiereService _service = IdempiereService();
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
    setState(() => _cargando = true);
    await _service.login();
    final accionistas =
        await _service.obtenerAccionistas(widget.personalDataId!);
    final clientes = await _service.obtenerClientes(widget.personalDataId!);
    final peps = await _service.obtenerPEP(widget.personalDataId!);
    final referencias =
        await _service.obtenerReferenciasBancarias(widget.personalDataId!);
    final paises = await _service.obtenerPaises();
    setState(() {
      _accionistas = accionistas;
      _clientes = clientes;
      _peps = peps;
      _referencias = referencias;
      _paises = paises;
      _cargando = false;
    });
  }

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
            Text(
              'Primero guarde el formulario principal para poder\nagregar accionistas, clientes y PEP.',
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Colors.blue[800],
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue[800],
          tabs: const [
            Tab(text: 'Accionistas'),
            Tab(text: 'Principales Clientes'),
            Tab(text: 'Referencias Bancarias'),
            Tab(text: 'PEP'),
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

  // ============ ACCIONISTAS ============
  Widget _buildTablaAccionistas() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () => _mostrarDialogoAccionista(),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Accionista'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _accionistas.isEmpty
              ? const Center(child: Text('No hay accionistas registrados'))
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
                              onPressed: () => _eliminarAccionista(a),
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
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () => _mostrarDialogoCliente(),
            icon: const Icon(Icons.add),
            label: const Text('Agregar Cliente'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _clientes.isEmpty
              ? const Center(child: Text('No hay clientes registrados'))
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
                              onPressed: () => _eliminarCliente(c),
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
          color: Colors.grey[100],
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.info, color: Colors.grey),
            SizedBox(width: 10),
            Text('Active el campo PEP en Datos del Representante Legal'),
          ],
        ),
      );
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: () => _mostrarDialogoPEP(),
            icon: const Icon(Icons.add),
            label: const Text('Agregar PEP'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _peps.isEmpty
              ? const Center(child: Text('No hay registros PEP'))
              : ListView.builder(
                  itemCount: _peps.length,
                  itemBuilder: (context, index) {
                    final p = _peps[index];
                    return Card(
                      child: ListTile(
                        title: Text(p.zNombresApellidos ?? ''),
                        subtitle: Text(
                          'Cédula: ${p.zCedula ?? '-'} | '
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
                              onPressed: () => _eliminarPEP(p),
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
                TextFormField(
                  initialValue: model.zPorcentajeParticipacion?.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Porcentaje de Participación %',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) =>
                      model.zPorcentajeParticipacion = double.tryParse(v),
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
              final ok = await _service.guardarAccionista(
                  model, widget.personalDataId!);
              if (ok) {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                _cargarDatos();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('✅ Accionista guardado'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
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
                TextFormField(
                  initialValue: model.zPorcentajeVentas?.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Porcentaje de Ventas %',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (v) =>
                      model.zPorcentajeVentas = double.tryParse(v),
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
              final ok =
                  await _service.guardarCliente(model, widget.personalDataId!);
              if (ok) {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                _cargarDatos();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('✅ Cliente guardado'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
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
                TextFormField(
                  initialValue: model.zCedula,
                  decoration: const InputDecoration(
                    labelText: 'Cédula',
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
              final ok =
                  await _service.guardarPEP(model, widget.personalDataId!);
              if (ok) {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                _cargarDatos();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('✅ PEP guardado'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
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
      _cargarDatos();
    }
  }

  Future<void> _eliminarCliente(PrincipalClienteModel c) async {
    final confirm = await _mostrarConfirmacion('¿Eliminar este cliente?');
    if (confirm) {
      await _service.eliminarCliente(c.id!);
      _cargarDatos();
    }
  }

  Future<void> _eliminarPEP(PepModel p) async {
    final confirm = await _mostrarConfirmacion('¿Eliminar este registro PEP?');
    if (confirm) {
      await _service.eliminarPEP(p.id!);
      _cargarDatos();
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: _referencias.isEmpty
              ? const Center(
                  child: Text('No hay referencias bancarias registradas'))
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
                              onPressed: () => _eliminarReferencia(r),
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
              final ok = await _service.guardarReferenciaBancaria(
                  model, widget.personalDataId!);
              if (ok) {
                final messenger = ScaffoldMessenger.of(context);
                Navigator.pop(context);
                _cargarDatos();
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('✅ Referencia bancaria guardada'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800]),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarReferencia(ReferenciaBancariaModel r) async {
    final confirm =
        await _mostrarConfirmacion('¿Eliminar esta referencia bancaria?');
    if (confirm) {
      await _service.eliminarReferenciaBancaria(r.id!);
      _cargarDatos();
    }
  }
}
