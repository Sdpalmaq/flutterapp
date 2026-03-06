import 'package:flutter/material.dart';
import '../models/kyc_model.dart';
import '../styles/web_styles.dart';
import 'responsive_row.dart';

class SituacionFinanciera extends StatefulWidget {
  final KycJuridicaModel model;
  const SituacionFinanciera({super.key, required this.model});

  @override
  State<SituacionFinanciera> createState() => _SituacionFinancieraState();
}

class _SituacionFinancieraState extends State<SituacionFinanciera>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header con tabs
        Container(
          decoration: BoxDecoration(
            color: WebStyles.primaryBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: WebStyles.cyanAccent,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            tabs: const [
              Tab(
                icon: Icon(Icons.looks_one_outlined),
                text: 'Año 1',
              ),
              Tab(
                icon: Icon(Icons.looks_two_outlined),
                text: 'Año 2',
              ),
              Tab(
                icon: Icon(Icons.looks_3_outlined),
                text: 'Año 3',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Contenido de cada tab
        SizedBox(
          height: 520,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildAno(
                ano: 1,
                color: Colors.blue[700]!,
                activos: widget.model.zActivos,
                pasivos: widget.model.zPasivos,
                patrimonio: widget.model.zPatrimonio,
                ventas: widget.model.zVentas,
                costoVentas: widget.model.zCostVentas,
                gastos: widget.model.zGastosDeOperacion,
                utilidad: widget.model.zUtilidadNeta,
                margen: widget.model.zMargenOperacional,
                onActivosChanged: (v) =>
                    widget.model.zActivos = double.tryParse(v ?? ''),
                onPasivosChanged: (v) =>
                    widget.model.zPasivos = double.tryParse(v ?? ''),
                onPatrimonioChanged: (v) =>
                    widget.model.zPatrimonio = double.tryParse(v ?? ''),
                onVentasChanged: (v) =>
                    widget.model.zVentas = double.tryParse(v ?? ''),
                onCostoVentasChanged: (v) =>
                    widget.model.zCostVentas = double.tryParse(v ?? ''),
                onGastosChanged: (v) =>
                    widget.model.zGastosDeOperacion = double.tryParse(v ?? ''),
                onUtilidadChanged: (v) =>
                    widget.model.zUtilidadNeta = double.tryParse(v ?? ''),
                onMargenChanged: (v) =>
                    widget.model.zMargenOperacional = double.tryParse(v ?? ''),
              ),
              _buildAno(
                ano: 2,
                color: Colors.teal[700]!,
                activos: widget.model.zActivos2,
                pasivos: widget.model.zPasivos2,
                patrimonio: widget.model.zPatrimonio2,
                ventas: widget.model.zVentas2,
                costoVentas: widget.model.zCostVentas2,
                gastos: widget.model.zGastosDeOperacion2,
                utilidad: widget.model.zUtilidadNeta2,
                margen: widget.model.zMargenOperacional2,
                onActivosChanged: (v) =>
                    widget.model.zActivos2 = double.tryParse(v ?? ''),
                onPasivosChanged: (v) =>
                    widget.model.zPasivos2 = double.tryParse(v ?? ''),
                onPatrimonioChanged: (v) =>
                    widget.model.zPatrimonio2 = double.tryParse(v ?? ''),
                onVentasChanged: (v) =>
                    widget.model.zVentas2 = double.tryParse(v ?? ''),
                onCostoVentasChanged: (v) =>
                    widget.model.zCostVentas2 = double.tryParse(v ?? ''),
                onGastosChanged: (v) =>
                    widget.model.zGastosDeOperacion2 = double.tryParse(v ?? ''),
                onUtilidadChanged: (v) =>
                    widget.model.zUtilidadNeta2 = double.tryParse(v ?? ''),
                onMargenChanged: (v) =>
                    widget.model.zMargenOperacional2 = double.tryParse(v ?? ''),
              ),
              _buildAno(
                ano: 3,
                color: Colors.purple[700]!,
                activos: widget.model.zActivos3,
                pasivos: widget.model.zPasivos3,
                patrimonio: widget.model.zPatrimonio3,
                ventas: widget.model.zVentas3,
                costoVentas: widget.model.zCostVentas3,
                gastos: widget.model.zGastosDeOperacion3,
                utilidad: widget.model.zUtilidadNeta3,
                margen: widget.model.zMargenOperacional3,
                onActivosChanged: (v) =>
                    widget.model.zActivos3 = double.tryParse(v ?? ''),
                onPasivosChanged: (v) =>
                    widget.model.zPasivos3 = double.tryParse(v ?? ''),
                onPatrimonioChanged: (v) =>
                    widget.model.zPatrimonio3 = double.tryParse(v ?? ''),
                onVentasChanged: (v) =>
                    widget.model.zVentas3 = double.tryParse(v ?? ''),
                onCostoVentasChanged: (v) =>
                    widget.model.zCostVentas3 = double.tryParse(v ?? ''),
                onGastosChanged: (v) =>
                    widget.model.zGastosDeOperacion3 = double.tryParse(v ?? ''),
                onUtilidadChanged: (v) =>
                    widget.model.zUtilidadNeta3 = double.tryParse(v ?? ''),
                onMargenChanged: (v) =>
                    widget.model.zMargenOperacional3 = double.tryParse(v ?? ''),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAno({
    required int ano,
    required Color color,
    double? activos,
    double? pasivos,
    double? patrimonio,
    double? ventas,
    double? costoVentas,
    double? gastos,
    double? utilidad,
    double? margen,
    required void Function(String?) onActivosChanged,
    required void Function(String?) onPasivosChanged,
    required void Function(String?) onPatrimonioChanged,
    required void Function(String?) onVentasChanged,
    required void Function(String?) onCostoVentasChanged,
    required void Function(String?) onGastosChanged,
    required void Function(String?) onUtilidadChanged,
    required void Function(String?) onMargenChanged,
  }) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge de año
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              border: Border.all(color: color.withOpacity(0.4)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today, color: color, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Datos Financieros - Año $ano',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // Sección Balance
          _buildSectionHeader('Balance General', Icons.account_balance, color),
          const SizedBox(height: 12),
          ResponsiveRow(children: [
            _buildNumberField(
              label: 'Activos',
              icon: Icons.trending_up,
              color: color,
              initialValue: activos,
              onSaved: onActivosChanged,
            ),
            _buildNumberField(
              label: 'Pasivos',
              icon: Icons.trending_down,
              color: color,
              initialValue: pasivos,
              onSaved: onPasivosChanged,
            ),
            _buildNumberField(
              label: 'Patrimonio',
              icon: Icons.savings,
              color: color,
              initialValue: patrimonio,
              onSaved: onPatrimonioChanged,
            ),
          ]),
          const SizedBox(height: 20),

          // Sección Estado de Resultados
          _buildSectionHeader(
              'Estado de Resultados', Icons.bar_chart, color),
          const SizedBox(height: 12),
          ResponsiveRow(children: [
            _buildNumberField(
              label: 'Ventas',
              icon: Icons.point_of_sale,
              color: color,
              initialValue: ventas,
              onSaved: onVentasChanged,
            ),
            _buildNumberField(
              label: 'Costo de Ventas',
              icon: Icons.receipt_long,
              color: color,
              initialValue: costoVentas,
              onSaved: onCostoVentasChanged,
            ),
          ]),
          //const SizedBox(height: 16),
          ResponsiveRow(children: [
            _buildNumberField(
              label: 'Gastos de Operación',
              icon: Icons.paid,
              color: color,
              initialValue: gastos,
              onSaved: onGastosChanged,
            ),
            _buildNumberField(
              label: 'Utilidad Neta',
              icon: Icons.monetization_on,
              color: color,
              initialValue: utilidad,
              onSaved: onUtilidadChanged,
            ),
          ]),
          //const SizedBox(height: 16),
          ResponsiveRow(children: [
            _buildNumberField(
              label: 'Margen Operacional',
              icon: Icons.percent,
              color: color,
              initialValue: margen,
              onSaved: onMargenChanged,
            ),
            const SizedBox(), // espacio vacío
          ]),
          //const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Divider(color: color.withOpacity(0.3))),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required IconData icon,
    required Color color,
    double? initialValue,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue?.toString() ?? '',
      keyboardType:
          const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color, size: 18),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      onSaved: onSaved,
      onChanged: onSaved,
    );
  }
}