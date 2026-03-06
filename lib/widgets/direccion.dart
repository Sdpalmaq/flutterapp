import 'package:flutter/material.dart';
import '../models/kyc_model.dart';
import '../styles/web_styles.dart';
import 'responsive_row.dart';

class Direccion extends StatelessWidget {
  final KycJuridicaModel model;
  const Direccion({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Fila 1 - Provincia, Ciudad, Cantón
        ResponsiveRow(children: [
          _buildTextField(
            label: 'Provincia', icon: Icons.map,
            onSaved: (v) => model.zProvinciaTrabCliente = v,
            initialValue: model.zProvinciaTrabCliente,
          ),
          _buildTextField(
            label: 'Ciudad', icon: Icons.location_city,
            onSaved: (v) => model.zCiudadTrabCliente = v,
            initialValue: model.zCiudadTrabCliente,
          ),
          _buildTextField(
            label: 'Cantón', icon: Icons.place,
            onSaved: (v) => model.zCantonTrabCliente = v,
            initialValue: model.zCantonTrabCliente,
          ),
        ]),
        // Fila 2 - Calle y Número
        ResponsiveRow(children: [
          _buildTextField(
            label: 'Calle Principal', icon: Icons.signpost,
            onSaved: (v) => model.zCalleTrabCliente = v,
            initialValue: model.zCalleTrabCliente,
          ),
          _buildTextField(
            label: 'Número', icon: Icons.tag,
            onSaved: (v) => model.zNumeroTrabCliente = v,
            initialValue: model.zNumeroTrabCliente,
          ),
        ]),
        // Fila 3 - Teléfono (solo ocupa mitad del ancho en desktop)
        LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 600) {
              return _buildTextField(
                label: 'Teléfono', icon: Icons.phone,
                keyboardType: TextInputType.phone,
                onSaved: (v) => model.zTelefonoTrabCliente = v,
                initialValue: model.zTelefonoTrabCliente,
              );
            }
            return Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Teléfono', icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    onSaved: (v) => model.zTelefonoTrabCliente = v,
                    initialValue: model.zTelefonoTrabCliente,
                  ),
                ),
                const Expanded(child: SizedBox()),
                const Expanded(child: SizedBox()),
              ],
            );
          },
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