import 'package:flutter/services.dart';

/// Formateador que capitaliza la primera letra de cada palabra
/// mientras el usuario escribe.
///
/// Ejemplos:
///   "ambato"     → "Ambato"
///   "LUIS MARIO" → "Luis Mario"
///   "san gabriel"→ "San Gabriel"
///
/// Uso:
///   inputFormatters: [CapitalizeWordsFormatter()],
class CapitalizeWordsFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final capitalizado = _capitalizarPalabras(text);

    // Mantener la posición del cursor correctamente
    int cursorPos = newValue.selection.baseOffset;
    if (cursorPos > capitalizado.length) {
      cursorPos = capitalizado.length;
    }

    return TextEditingValue(
      text: capitalizado,
      selection: TextSelection.collapsed(offset: cursorPos),
    );
  }

  String _capitalizarPalabras(String texto) {
    if (texto.isEmpty) return texto;

    // Palabras que NO deben capitalizarse (artículos/preposiciones en nombres)
    const excepciones = {
      'de',
      'del',
      'la',
      'las',
      'los',
      'el',
      'y',
      'e',
      'o',
      'u',
      'en',
      'con',
      'por',
      'para',
      'a',
      'al',
    };

    final palabras = texto.split(' ');
    final resultado = <String>[];

    for (int i = 0; i < palabras.length; i++) {
      final palabra = palabras[i];
      if (palabra.isEmpty) {
        resultado.add(palabra);
        continue;
      }
      // La primera palabra siempre se capitaliza; las excepciones no
      if (i > 0 && excepciones.contains(palabra.toLowerCase())) {
        resultado.add(palabra.toLowerCase());
      } else {
        resultado.add(
          palabra[0].toUpperCase() + palabra.substring(1).toLowerCase(),
        );
      }
    }

    return resultado.join(' ');
  }
}
