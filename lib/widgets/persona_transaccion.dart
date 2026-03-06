import 'package:flutter/material.dart';
import '../models/kyc_model.dart';
import '../styles/web_styles.dart';
import 'responsive_row.dart';

class PersonaTransaccion extends StatefulWidget {
  final KycJuridicaModel model;
  const PersonaTransaccion({super.key, required this.model});

  @override
  State<PersonaTransaccion> createState() => _PersonaTransaccionState();
}

class _PersonaTransaccionState extends State<PersonaTransaccion> {

  bool get _esRegistroExistente =>
      widget.model.idMutable != null || widget.model.id != null;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Persona que hace la Transacción ──
        _buildSectionTitle('Persona que hace la Transacción', Icons.person),
        const SizedBox(height: 16),
        ResponsiveRow(children: [
          _buildTextField(
            label: 'Nombres y Apellidos',
            icon: Icons.person,
            required: true,
            onSaved: (v) => widget.model.zNombrePersonaTransaccion = v,
            initialValue: widget.model.zNombrePersonaTransaccion,
          ),
          // ── Cédula: bloqueada si el registro ya existe ──
          _buildLockedField(
            label: 'No. Documento',
            icon: Icons.badge,
            required: true,
            value: widget.model.zDocumentoPersonaTransa ?? '',
            locked: _esRegistroExistente,
            tooltipMsg: 'El documento de identidad no puede modificarse',
            onSaved: (v) => widget.model.zDocumentoPersonaTransa = v,
          ),
        ]),
        LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return _buildTextField(
              label: 'Vinculación con la Empresa',
              icon: Icons.business_center,
              onSaved: (v) => widget.model.zVinculacionEmpresa = v,
              initialValue: widget.model.zVinculacionEmpresa,
            );
          }
          return Row(children: [
            Expanded(
              child: _buildTextField(
                label: 'Vinculación con la Empresa',
                icon: Icons.business_center,
                onSaved: (v) => widget.model.zVinculacionEmpresa = v,
                initialValue: widget.model.zVinculacionEmpresa,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(child: SizedBox()),
          ]);
        }),
        const SizedBox(height: 8),

        // ── Información de la Transacción ──
        _buildSectionTitle('Información de la Transacción', Icons.receipt_long),
        const SizedBox(height: 16),
        ResponsiveRow(children: [
          _buildTextField(
            label: 'Bien / Servicio a adquirir',
            icon: Icons.directions_car,
            required: true,
            onSaved: (v) => widget.model.zBienTransaccion = v,
            initialValue: widget.model.zBienTransaccion,
          ),
          _buildTextField(
            label: 'PVP',
            icon: Icons.attach_money,
            required: true,
            keyboardType: TextInputType.number,
            onSaved: (v) =>
                widget.model.zPvpTransaccion = double.tryParse(v ?? '0'),
            initialValue: widget.model.zPvpTransaccion?.toString(),
          ),
        ]),
        ResponsiveRow(children: [
          DropdownButtonFormField<String>(
            value: widget.model.zFormaPago ?? 'P',
            decoration: InputDecoration(
              labelText: 'Forma de Pago *',
              prefixIcon: Icon(Icons.payment, color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: WebStyles.cyanAccent, width: 2),
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'B', child: Text('Cheque')),
              DropdownMenuItem(value: 'P', child: Text('Crédito Directo')),
              DropdownMenuItem(value: 'C', child: Text('Efectivo')),
              DropdownMenuItem(value: 'K', child: Text('Tarjeta De Crédito')),
              DropdownMenuItem(value: 'T', child: Text('Transferencia (Pago)')),
            ],
            onChanged: (v) => setState(() => widget.model.zFormaPago = v),
            onSaved: (v) => widget.model.zFormaPago = v,
            validator: (v) => v == null ? 'Campo requerido' : null,
          ),
          _buildTextField(
            label: 'Origen de Fondos',
            icon: Icons.account_balance_wallet,
            required: true,
            onSaved: (v) => widget.model.zOrigenFondos = v,
            initialValue: widget.model.zOrigenFondos,
          ),
        ]),
      ],
    );
  }

  // Campo que se bloquea (readOnly + candado) cuando locked=true
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

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: WebStyles.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: WebStyles.primaryBlue, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: WebStyles.primaryBlue,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(color: WebStyles.primaryBlue, thickness: 0.3),
        ),
      ],
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