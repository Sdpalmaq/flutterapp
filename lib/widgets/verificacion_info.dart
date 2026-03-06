import 'package:flutter/material.dart';
import '../models/kyc_model.dart';
import '../styles/web_styles.dart';

class VerificacionInfo extends StatefulWidget {
  final KycJuridicaModel model;

  const VerificacionInfo({super.key, required this.model});

  @override
  State<VerificacionInfo> createState() => _VerificacionInfoState();
}

class _VerificacionInfoState extends State<VerificacionInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Marque las fuentes verificadas:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 16),
        _buildSwitch('Registro Civil', Icons.how_to_reg, 'registroCivil',
            widget.model.registroCivil, (v) {
          setState(() => widget.model.registroCivil = v);
        }),
        _buildSwitch('SRI (Servicio de Rentas Internas)', Icons.receipt, 'sri',
            widget.model.sri, (v) {
          setState(() => widget.model.sri = v);
        }),
        _buildSwitch('Función Judicial', Icons.gavel, 'funcionJudicial',
            widget.model.funcionJudicial, (v) {
          setState(() => widget.model.funcionJudicial = v);
        }),
        _buildSwitch('Bureau de Crédito', Icons.credit_score, 'bureauCredito',
            widget.model.bureauCredito, (v) {
          setState(() => widget.model.bureauCredito = v);
        }),
        _buildSwitch('Antecedentes Penales', Icons.security,
            'antecedentespenales', widget.model.antecedentespenales, (v) {
          setState(() => widget.model.antecedentespenales = v);
        }),
        _buildSwitch('Otros', Icons.more_horiz, 'otros', widget.model.otros,
            (v) {
          setState(() => widget.model.otros = v);
        }),
      ],
    );
  }

  Widget _buildSwitch(String label, IconData icon, String key, bool value,
      void Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color:
            value ? WebStyles.primaryBlue.withOpacity(0.05) : Colors.grey[50],
        border: Border.all(
          color: value ? WebStyles.primaryBlue : Colors.grey[300]!,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon,
              color: value ? WebStyles.primaryBlue : Colors.grey[400],
              size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: value ? WebStyles.primaryBlue : Colors.black87,
                fontWeight: value ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          Switch(
            value: value,
            activeColor: WebStyles.cyanAccent,
            activeTrackColor: WebStyles.primaryBlue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
