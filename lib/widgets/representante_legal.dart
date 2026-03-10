import 'package:flutter/material.dart';
import '../models/kyc_model.dart';
import '../styles/web_styles.dart';
import 'responsive_row.dart';

class RepresentanteLegal extends StatefulWidget {
  final KycJuridicaModel model;
  const RepresentanteLegal({super.key, required this.model});

  @override
  State<RepresentanteLegal> createState() => _RepresentanteLegalState();
}

class _RepresentanteLegalState extends State<RepresentanteLegal> {
  bool get _esRegistroExistente =>
      widget.model.idMutable != null || widget.model.id != null;

  // ✅ Switch cónyuge — se inicializa en true si ya hay datos cargados
  late bool _tieneConyuge;

  @override
  void initState() {
    super.initState();
    _tieneConyuge = (widget.model.zNombreConyugue?.isNotEmpty ?? false) ||
        (widget.model.zDocConyugue?.isNotEmpty ?? false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila 1 - Nombre y Documento
        ResponsiveRow(children: [
          _buildTextField(
            label: 'Nombre Representante Legal',
            icon: Icons.person,
            required: true,
            initialValue: widget.model.zNombreRespresentanteLegal,
            onSaved: (v) => widget.model.zNombreRespresentanteLegal = v,
          ),
          _buildLockedField(
            label: 'No. Documento',
            icon: Icons.badge,
            required: true,
            value: widget.model.zDocumentoRepLegal ?? '',
            locked: _esRegistroExistente,
            tooltipMsg: 'El documento del Representante Legal no puede modificarse',
            onSaved: (v) => widget.model.zDocumentoRepLegal = v,
          ),
        ]),

        // Fila 2 - Género, Correo y Nacionalidad
        ResponsiveRow(children: [
          DropdownButtonFormField<String>(
            value: widget.model.zGeneroRepLegal,
            decoration: InputDecoration(
              labelText: 'Género *',
              prefixIcon: Icon(Icons.wc, color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: WebStyles.cyanAccent, width: 2),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'M', child: Text('Masculino')),
              DropdownMenuItem(value: 'F', child: Text('Femenino')),
            ],
            onChanged: (v) => setState(() => widget.model.zGeneroRepLegal = v),
            onSaved: (v) => widget.model.zGeneroRepLegal = v,
            validator: (v) => v == null ? 'Campo requerido' : null,
          ),
          _buildTextField(
            label: 'Correo Electrónico',
            icon: Icons.email,
            required: true,
            keyboardType: TextInputType.emailAddress,
            initialValue: widget.model.zCorreoRepLegal,
            onSaved: (v) => widget.model.zCorreoRepLegal = v,
          ),
          _buildTextField(
            label: 'Nacionalidad',
            icon: Icons.public,
            initialValue: widget.model.zPaisRepLega,
            onSaved: (v) => widget.model.zPaisRepLega = v,
          ),
        ]),

        // Fila 3 - Provincia, Ciudad, Cantón
        ResponsiveRow(children: [
          _buildTextField(
            label: 'Provincia',
            icon: Icons.map,
            initialValue: widget.model.zProvinciaRepLegal,
            onSaved: (v) => widget.model.zProvinciaRepLegal = v,
          ),
          _buildTextField(
            label: 'Ciudad',
            icon: Icons.location_city,
            initialValue: widget.model.zCiudadRepLegal,
            onSaved: (v) => widget.model.zCiudadRepLegal = v,
          ),
          _buildTextField(
            label: 'Cantón',
            icon: Icons.place,
            initialValue: widget.model.zCantonRepLegal,
            onSaved: (v) => widget.model.zCantonRepLegal = v,
          ),
        ]),

        // Fila 4 - Calle, Número e Intersección
        ResponsiveRow(children: [
          _buildTextField(
            label: 'Calle',
            icon: Icons.signpost,
            initialValue: widget.model.zCalleRepLegal,
            onSaved: (v) => widget.model.zCalleRepLegal = v,
          ),
          _buildTextField(
            label: 'Número',
            icon: Icons.tag,
            initialValue: widget.model.zNumeroRepLegal,
            onSaved: (v) => widget.model.zNumeroRepLegal = v,
          ),
          _buildTextField(
            label: 'Intersección',
            icon: Icons.add_road,
            initialValue: widget.model.zInterseccionRepLegal,
            onSaved: (v) => widget.model.zInterseccionRepLegal = v,
          ),
        ]),

        // Fila 5 - Teléfono
        ResponsiveRow(children: [
          _buildTextField(
            label: 'Teléfono',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            initialValue: widget.model.zTelefonoRepLegal,
            onSaved: (v) => widget.model.zTelefonoRepLegal = v,
          ),
          const SizedBox(),
        ]),

        const SizedBox(height: 8),
        const Divider(thickness: 1),
        const SizedBox(height: 8),

        // ── SECCIÓN CÓNYUGE ──
        // ✅ Switch que muestra/oculta los campos de cónyuge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: _tieneConyuge
                ? WebStyles.primaryBlue.withOpacity(0.05)
                : Colors.grey[50],
            border: Border.all(
              color: _tieneConyuge
                  ? WebStyles.primaryBlue
                  : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.people,
                    color: _tieneConyuge
                        ? WebStyles.primaryBlue
                        : Colors.grey[400],
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '¿El Representante Legal tiene cónyuge?',
                    style: TextStyle(
                      fontSize: 15,
                      color: _tieneConyuge
                          ? WebStyles.primaryBlue
                          : Colors.black87,
                      fontWeight: _tieneConyuge
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              Switch(
                value: _tieneConyuge,
                activeColor: WebStyles.cyanAccent,
                activeTrackColor: WebStyles.primaryBlue,
                onChanged: (v) {
                  setState(() {
                    _tieneConyuge = v;
                    // ✅ Al desactivar se limpian los datos del modelo
                    if (!v) {
                      widget.model.zNombreConyugue = null;
                      widget.model.zDocConyugue = null;
                    }
                  });
                },
              ),
            ],
          ),
        ),

        // ✅ Campos de cónyuge — solo visibles si _tieneConyuge es true
        if (_tieneConyuge) ...[
          const SizedBox(height: 16),
          ResponsiveRow(children: [
            _buildTextField(
              label: 'Nombre del Cónyuge',
              icon: Icons.person_outline,
              required: true,
              initialValue: widget.model.zNombreConyugue,
              onSaved: (v) => widget.model.zNombreConyugue = v,
            ),
            _buildTextField(
              label: 'Documento del Cónyuge',
              icon: Icons.badge_outlined,
              required: true,
              initialValue: widget.model.zDocConyugue,
              onSaved: (v) => widget.model.zDocConyugue = v,
            ),
          ]),
        ],

        const SizedBox(height: 8),
        const Divider(thickness: 1),
        const SizedBox(height: 8),

        // ── SECCIÓN PEP ──
        // ✅ Texto actualizado con la pregunta exacta del formulario PDF
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: widget.model.isPpe
                ? Colors.orange.withOpacity(0.05)
                : Colors.grey[50],
            border: Border.all(
              color: widget.model.isPpe
                  ? Colors.orange
                  : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                color: widget.model.isPpe
                    ? Colors.orange
                    : Colors.grey[400],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '¿Es el Representante Legal o algún Accionista una Persona Políticamente Expuesta (PEP)?',
                  style: TextStyle(
                    fontSize: 14,
                    color: widget.model.isPpe
                        ? Colors.orange[800]
                        : Colors.black87,
                    fontWeight: widget.model.isPpe
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              Switch(
                value: widget.model.isPpe,
                activeColor: Colors.orange,
                activeTrackColor: Colors.orange[200],
                onChanged: (v) => setState(() => widget.model.isPpe = v),
              ),
            ],
          ),
        ),

        // ✅ Aviso de recordatorio cuando PEP está activo
        if (widget.model.isPpe) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Recuerde completar la tabla de PEP en la sección "Accionistas y PEP".',
                    style: TextStyle(fontSize: 13, color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 16),

        // Observaciones
        TextFormField(
          initialValue: widget.model.zObservacionesKyc,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Observaciones',
            prefixIcon: Icon(Icons.notes, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: WebStyles.cyanAccent, width: 2),
            ),
          ),
          onChanged: (v) => widget.model.zObservacionesKyc = v,
          onSaved: (v) => widget.model.zObservacionesKyc = v,
        ),
      ],
    );
  }

  Widget _buildLockedField({
    required String label,
    required IconData icon,
    required String value,
    required bool locked,
    required String tooltipMsg,
    bool required = false,
    void Function(String?)? onSaved,
  }) {
    final controller = TextEditingController(text: value);
    return TextFormField(
      controller: controller,
      readOnly: locked,
      style: TextStyle(color: locked ? Colors.grey[600] : Colors.black),
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: locked ? Colors.grey[100] : Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: locked ? Colors.grey : WebStyles.cyanAccent,
            width: 2,
          ),
        ),
        suffixIcon: locked
            ? Tooltip(
                message: tooltipMsg,
                child: Icon(Icons.lock, color: Colors.grey[400]),
              )
            : null,
      ),
      validator: required
          ? (v) => (v == null || v.isEmpty) ? 'Campo requerido' : null
          : null,
      onChanged: locked ? null : onSaved,
      onSaved: locked ? null : onSaved,
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    bool required = false,
    TextInputType? keyboardType,
    String? initialValue,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
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
}