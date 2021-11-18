library bootjack_plugin;

import 'dart:html';
import 'package:dquery/dquery.dart';

/** Load a component from Element data space if available, otherwise create
 * one.
 */
T wire<T>(Element element, String name, T create()) =>
     ($(element).data.get(name) as T?) ?? create(); // create shall save it back

/** Retrieve the value of data-target attribute of href attribute on given
 * [element].
 */
String? getDataTarget(Element element) =>
    element.attributes['data-target'] ?? element.attributes['href'];
// selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7 // skipped

/**
 * Refer to Jquery
 */
bool isHidden(Element e) {
  //if (e.style.display != 'none' && e.style.visibility != 'hidden')
  //refer to jquery
  return e.offsetWidth <= 0 && e.offsetHeight <= 0;
}

/** A token object for identification with recognizable toString() output for
 * easier debugging.
 */
class Token {
  
  Token() : _str = "token_${_i++}";
  
  @override
  String toString() => _str;
  
  final String _str;
  static int _i = 0;
  
}
