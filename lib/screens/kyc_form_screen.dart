// import 'package:flutter/material.dart';
// import '../models/kyc_model.dart';
// import '../services/idempiere_service.dart';
// import '../styles/web_styles.dart';
// import '../widgets/datos_generales.dart';
// import '../widgets/verificacion_info.dart';
// import '../widgets/direccion.dart';
// import '../widgets/persona_transaccion.dart';
// import '../widgets/situacion_financiera.dart';
// import '../widgets/representante_legal.dart';
// import '../widgets/tablas_hijas.dart';

// class KycFormScreen extends StatefulWidget {
//   const KycFormScreen({super.key});

//   @override
//   State<KycFormScreen> createState() => _KycFormScreenState();
// }

// class _KycFormScreenState extends State<KycFormScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final IdempiereService _service = IdempiereService();
//   final KycJuridicaModel _model = KycJuridicaModel();
//   bool _guardando = false;
//   int _seccionActual = 0;

//   final List<Map<String, dynamic>> _secciones = [
//     {'titulo': 'Datos Generales', 'icono': Icons.business},
//     {'titulo': 'Verificación de Información', 'icono': Icons.verified_user},
//     {'titulo': 'Dirección', 'icono': Icons.location_on},
//     {'titulo': 'Persona que hace la Transacción', 'icono': Icons.person},
//     {'titulo': 'Situación Comercial & Financiera', 'icono': Icons.bar_chart},
//     {'titulo': 'Datos del Representante Legal', 'icono': Icons.account_circle},
//     {'titulo': 'Accionistas, Clientes y PEP', 'icono': Icons.group},
//   ];

//   Future<void> _guardar() async {
//     if (!_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('⚠️ Por favor complete los campos requeridos'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     _formKey.currentState!.save();
//     setState(() => _guardando = true);

//     try {
//       await _service.login();
//       final registroId = _model.idMutable ?? _model.id;

//       if (registroId != null) {
//         final ok = await _service.actualizarKYC(registroId, _model.toJson());
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(ok
//                 ? '✅ Formulario actualizado exitosamente'
//                 : '❌ Error al actualizar'),
//             backgroundColor: ok ? Colors.green : Colors.red,
//           ),
//         );
//       } else {
//         final idCreado = await _service.crearKYCConId(_model.toJson());
//         if (idCreado != null) {
//           setState(() => _model.idMutable = idCreado);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('✅ Formulario guardado exitosamente'),
//               backgroundColor: Colors.green,
//             ),
//           );
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('❌ Error al guardar el formulario'),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('❌ Error: $e'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }

//     setState(() => _guardando = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [WebStyles.primaryBlue, WebStyles.secondaryBlue],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // ── HEADER ──
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.assignment, color: Colors.white, size: 32),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Text(
//                         'Conozca a su Cliente - Persona Jurídica',
//                         style: WebStyles.titleStyle,
//                       ),
//                     ),
//                     // Badge de estado
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: (_model.idMutable ?? _model.id) != null
//                             ? Colors.orange
//                             : WebStyles.cyanAccent,
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         (_model.idMutable ?? _model.id) != null
//                             ? '✏️ Editando'
//                             : '🆕 Nuevo',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               // ── CUERPO ──
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
//                   child: Card(
//                     elevation: 10,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       children: [
//                         // ── MENÚ LATERAL ──
//                         Container(
//                           width: 230,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[50],
//                             borderRadius: const BorderRadius.only(
//                               topLeft: Radius.circular(20),
//                               bottomLeft: Radius.circular(20),
//                             ),
//                           ),
//                           child: Column(
//                             children: [
//                               // Cabecera del menú
//                               Container(
//                                 width: double.infinity,
//                                 padding: const EdgeInsets.all(16),
//                                 decoration: const BoxDecoration(
//                                   color: WebStyles.primaryBlue,
//                                   borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(20),
//                                   ),
//                                 ),
//                                 child: const Text(
//                                   'Secciones',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ),
//                               // Lista de secciones
//                               Expanded(
//                                 child: ListView.builder(
//                                   itemCount: _secciones.length,
//                                   itemBuilder: (context, index) {
//                                     final esActual = _seccionActual == index;
//                                     return InkWell(
//                                       onTap: () => setState(
//                                           () => _seccionActual = index),
//                                       child: Container(
//                                         margin: const EdgeInsets.symmetric(
//                                             horizontal: 8, vertical: 4),
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 12, vertical: 10),
//                                         decoration: BoxDecoration(
//                                           color: esActual
//                                               ? WebStyles.primaryBlue
//                                               : Colors.transparent,
//                                           borderRadius:
//                                               BorderRadius.circular(10),
//                                         ),
//                                         child: Row(
//                                           children: [
//                                             Container(
//                                               width: 28,
//                                               height: 28,
//                                               decoration: BoxDecoration(
//                                                 color: esActual
//                                                     ? WebStyles.cyanAccent
//                                                     : Colors.grey[300],
//                                                 shape: BoxShape.circle,
//                                               ),
//                                               child: Center(
//                                                 child: Text(
//                                                   '${index + 1}',
//                                                   style: TextStyle(
//                                                     color: esActual
//                                                         ? WebStyles.primaryBlue
//                                                         : Colors.grey[600],
//                                                     fontWeight: FontWeight.bold,
//                                                     fontSize: 12,
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(width: 10),
//                                             Expanded(
//                                               child: Text(
//                                                 _secciones[index]['titulo'],
//                                                 style: TextStyle(
//                                                   color: esActual
//                                                       ? Colors.white
//                                                       : Colors.black87,
//                                                   fontWeight: esActual
//                                                       ? FontWeight.bold
//                                                       : FontWeight.normal,
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Divisor
//                         Container(width: 1, color: Colors.grey[200]),
//                         // ── CONTENIDO ──
//                         Expanded(
//                           child: Form(
//                             key: _formKey,
//                             child: Column(
//                               children: [
//                                 // Cabecera de sección
//                                 Container(
//                                   width: double.infinity,
//                                   padding: const EdgeInsets.all(16),
//                                   decoration: const BoxDecoration(
//                                     color: WebStyles.primaryBlue,
//                                     borderRadius: BorderRadius.only(
//                                       topRight: Radius.circular(20),
//                                     ),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Icon(
//                                         _secciones[_seccionActual]['icono']
//                                             as IconData,
//                                         color: WebStyles.cyanAccent,
//                                         size: 22,
//                                       ),
//                                       const SizedBox(width: 10),
//                                       Text(
//                                         _secciones[_seccionActual]['titulo'],
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 18,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       const Spacer(),
//                                       // Indicador de progreso
//                                       Text(
//                                         '${_seccionActual + 1} / ${_secciones.length}',
//                                         style: const TextStyle(
//                                           color: Colors.white70,
//                                           fontSize: 13,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 // Barra de progreso
//                                 LinearProgressIndicator(
//                                   value:
//                                       (_seccionActual + 1) / _secciones.length,
//                                   backgroundColor: Colors.grey[200],
//                                   valueColor:
//                                       const AlwaysStoppedAnimation<Color>(
//                                     WebStyles.cyanAccent,
//                                   ),
//                                   minHeight: 4,
//                                 ),
//                                 // Contenido del formulario
//                                 Expanded(
//                                   child: SingleChildScrollView(
//                                     padding: const EdgeInsets.all(24),
//                                     child: _buildSeccion(),
//                                   ),
//                                 ),
//                                 // Botones de navegación
//                                 Container(
//                                   padding: const EdgeInsets.all(16),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: const BorderRadius.only(
//                                       bottomRight: Radius.circular(20),
//                                     ),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: Colors.grey.withOpacity(0.2),
//                                         blurRadius: 5,
//                                         offset: const Offset(0, -2),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       // Botón Anterior
//                                       if (_seccionActual > 0)
//                                         ElevatedButton.icon(
//                                           onPressed: () =>
//                                               setState(() => _seccionActual--),
//                                           icon: const Icon(Icons.arrow_back),
//                                           label: const Text('Anterior'),
//                                           style: ElevatedButton.styleFrom(
//                                             backgroundColor: Colors.grey[400],
//                                             foregroundColor: Colors.white,
//                                             padding: const EdgeInsets.symmetric(
//                                                 horizontal: 20, vertical: 12),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                           ),
//                                         )
//                                       else
//                                         const SizedBox(),
//                                       Row(
//                                         children: [
//                                           // Botón Guardar/Actualizar
//                                           if (_seccionActual ==
//                                               _secciones.length - 1)
//                                             SizedBox(
//                                               height: 45,
//                                               child: ElevatedButton.icon(
//                                                 onPressed: _guardando
//                                                     ? null
//                                                     : _guardar,
//                                                 icon: _guardando
//                                                     ? const SizedBox(
//                                                         width: 20,
//                                                         height: 20,
//                                                         child:
//                                                             CircularProgressIndicator(
//                                                           color: Colors.white,
//                                                           strokeWidth: 2,
//                                                         ),
//                                                       )
//                                                     : Icon(
//                                                         (_model.idMutable ??
//                                                                     _model
//                                                                         .id) !=
//                                                                 null
//                                                             ? Icons.update
//                                                             : Icons.save,
//                                                       ),
//                                                 label: Text(
//                                                   _guardando
//                                                       ? 'Guardando...'
//                                                       : (_model.idMutable ??
//                                                                   _model.id) !=
//                                                               null
//                                                           ? 'Actualizar'
//                                                           : 'Guardar',
//                                                   style: WebStyles
//                                                       .buttonTextStyle
//                                                       .copyWith(fontSize: 14),
//                                                 ),
//                                                 style: WebStyles
//                                                     .primaryButtonStyle,
//                                               ),
//                                             ),
//                                           const SizedBox(width: 10),
//                                           // Botón Siguiente
//                                           if (_seccionActual <
//                                               _secciones.length - 1)
//                                             ElevatedButton.icon(
//                                               onPressed: () => setState(
//                                                   () => _seccionActual++),
//                                               icon: const Icon(
//                                                   Icons.arrow_forward),
//                                               label: const Text('Siguiente'),
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor:
//                                                     WebStyles.primaryBlue,
//                                                 foregroundColor: Colors.white,
//                                                 padding:
//                                                     const EdgeInsets.symmetric(
//                                                         horizontal: 20,
//                                                         vertical: 12),
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSeccion() {
//     switch (_seccionActual) {
//       case 0:
//         return DatosGenerales(model: _model);
//       case 1:
//         return VerificacionInfo(model: _model);
//       case 2:
//         return Direccion(model: _model);
//       case 3:
//         return PersonaTransaccion(model: _model);
//       case 4:
//         return SituacionFinanciera(model: _model);
//       case 5:
//         return RepresentanteLegal(model: _model);
//       case 6:
//         return TablasHijas(
//           personalDataId: _model.idMutable ?? _model.id,
//           isPpe: _model.isPpe,
//         );
//       default:
//         return const SizedBox();
//     }
//   }
// }

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

class KycFormScreen extends StatefulWidget {
  const KycFormScreen({super.key});

  @override
  State<KycFormScreen> createState() => _KycFormScreenState();
}

class _KycFormScreenState extends State<KycFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final IdempiereService _service = IdempiereService();
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
      await _service.login();
      final registroId = _model.idMutable ?? _model.id;

      if (registroId != null) {
        final ok = await _service.actualizarKYC(registroId, _model.toJson());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ok
                ? '✅ Formulario actualizado exitosamente'
                : '❌ Error al actualizar'),
            backgroundColor: ok ? Colors.green : Colors.red,
          ),
        );
      } else {
        final idCreado = await _service.crearKYCConId(_model.toJson());
        if (idCreado != null) {
          setState(() => _model.idMutable = idCreado);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Formulario guardado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Error al guardar el formulario'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() => _guardando = false);
  }

  // Abre el drawer en móvil
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
                setState(() => _seccionActual = index);
                Navigator.pop(context);
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
        final isTablet =
            constraints.maxWidth >= 600 && constraints.maxWidth < 900;
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
                  // ── HEADER ──
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 24,
                      vertical: isMobile ? 10 : 16,
                    ),
                    child: Row(
                      children: [
                        // Botón menú en móvil/tablet
                        if (!isDesktop)
                          IconButton(
                            onPressed: () => _abrirMenuMovil(context),
                            icon: const Icon(Icons.menu, color: Colors.white),
                            tooltip: 'Ver secciones',
                          ),
                        const Icon(Icons.assignment,
                            color: Colors.white, size: 28),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            isMobile
                                ? 'KYC - P. Jurídica'
                                : 'Conozca a su Cliente - Persona Jurídica',
                            style: WebStyles.titleStyle.copyWith(
                              fontSize: isMobile
                                  ? 16
                                  : isTablet
                                      ? 20
                                      : 26,
                            ),
                          ),
                        ),
                        // Badge estado
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
                      ],
                    ),
                  ),

                  // ── CUERPO ──
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

  // ── LAYOUT DESKTOP ──
  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Menú lateral
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                  ),
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
                      onTap: () => setState(() => _seccionActual = index),
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
                                  color:
                                      esActual ? Colors.white : Colors.black87,
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

  // ── LAYOUT MÓVIL Y TABLET ──
  Widget _buildMobileTabletLayout(bool isTablet) {
    return Column(
      children: [
        // Mini navegación por chips scrolleable
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
              // Título sección actual
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
              // Chips de sección
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  itemCount: _secciones.length,
                  itemBuilder: (context, index) {
                    final esActual = _seccionActual == index;
                    return GestureDetector(
                      onTap: () => setState(() => _seccionActual = index),
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              esActual ? WebStyles.cyanAccent : Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color:
                                esActual ? WebStyles.primaryBlue : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Barra de progreso
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

  // ── CONTENIDO COMPARTIDO ──
  Widget _buildContenido({bool isMobile = false}) {
    return Column(
      children: [
        // Header sección (solo desktop)
        if (!isMobile)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: WebStyles.primaryBlue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
              ),
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
        // Formulario
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
                // Botones de navegación
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
                          onPressed: () => setState(() => _seccionActual--),
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
                              onPressed: () => setState(() => _seccionActual++),
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
        return DatosGenerales(model: _model);
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
        );
      default:
        return const SizedBox();
    }
  }
}
