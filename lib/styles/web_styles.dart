import 'package:flutter/material.dart';

class WebStyles {
  // 1. Paleta de Colores Centralizada
  static const Color primaryBlue = Color(0xFF1E3C72);
  static const Color secondaryBlue = Color(0xFF2A5298);
  static const Color cyanAccent = Color(0xFF00C9FF);
  static const Color cyanHover = Color(0xFF33D4FF); // NUEVO: Color más claro para el hover
  static const Color textWhite = Colors.white;
  static const Color textHint = Colors.white70;

  // 2. Estilos de Texto
  static const TextStyle titleStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textWhite,
    letterSpacing: 1.5,
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 16,
    color: textHint,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textWhite,
    letterSpacing: 1.2,
  );

  // 3. Estilos de Botones Interactivos para Web
  // Usamos un 'getter' para devolver un ButtonStyle dinámico
  static ButtonStyle get primaryButtonStyle => ButtonStyle(
    // Animación de color según el estado del ratón
    backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.hovered)) return cyanHover; // Pasa el ratón
      if (states.contains(WidgetState.pressed)) return secondaryBlue; // Hace clic
      if (states.contains(WidgetState.disabled)) return Colors.grey; // Botón inactivo
      return cyanAccent; // Estado normal
    }),
    // Animación de sombra (se levanta al pasar el ratón)
    elevation: WidgetStateProperty.resolveWith<double>((states) {
      if (states.contains(WidgetState.hovered)) return 8.0;
      return 5.0;
    }),
    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    ),
    // Cambia el cursor a la "manito" en la web
    mouseCursor: WidgetStateProperty.all(SystemMouseCursors.click),
    // Duración de la transición suave
    animationDuration: const Duration(milliseconds: 200),
  );

  // 4. Entradas de Texto (TextFields) adaptadas para Web
  static InputDecoration inputDecoration(String hint, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hoverColor: Colors.grey[100], // NUEVO: Gris muy sutil al pasar el ratón por el input
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      suffixIcon: suffixIcon,
      // Borde normal
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide.none,
      ),
      // NUEVO: Borde resaltado cuando el usuario hace clic para escribir (Focus)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: cyanAccent, width: 2.0),
      ),
    );
  }
}