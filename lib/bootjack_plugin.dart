library bootjack_plugin;

import 'dart:html';
import 'package:dquery/dquery.dart';

/** Load a component from Element data space if available, otherwise create
 * one.
 */
wire(Element element, String name, create()) =>
     fallback($(element).data.get(name), create); // create shall save it back

/** Equivalent to || operator in JavaScript.
 */
fallback(a, b(), [c(), d()]) => 
    c == null ? _fallback(a, b) :
    d == null ? _fallback(_fallback(a, b), c) :
    _fallback(_fallback(_fallback(a, b), c), d);

_fallback(a, b()) => a != null ? a : b();

/** Equivalent to && operator in JavaScript.
 */
movein(a, b()) => a == null ? null : b();

/** Retrieve the value of data-target attribute of href attribute on given
 * [element].
 */
String getDataTarget(Element element) =>
    fallback(element.attributes['data-target'], () => element.attributes['href']);
// selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7 // skipped

/** Add [className] to [element] CSS classes if [value] is true, Remove it 
 * otherwise.
 */
void setClass(Element element, String className, bool value) {
  if (value)
    element.classes.add(className);
  else
    element.classes.remove(className);
}

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
