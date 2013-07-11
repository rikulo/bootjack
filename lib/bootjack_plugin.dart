library bootjack_plugin;

import 'dart:html';
import 'dart:math';
import 'package:meta/meta.dart';
import 'package:crypto/crypto.dart';
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

/** Retrieve the value of data-target attribute of href attribute on given
 * [element].
 */
String getDataTarget(Element element) =>
    fallback(element.attributes['data-target'], () => element.attributes['href']);
// selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7 // skipped

/** Return [f] if it is a String, or [f()] if [f] is a function. 
 */
String resolveString(f, [arg]) {
  if (f is String)
    return f;
  if (f is Function) {
    try {
      return arg == null ? f() : f(arg);
    } catch (e) {}
  }
  return null;
}

/** Return [f] if it is an int, or [f()] if [f] is a function. 
 */
int resolveInt(f) {
  if (f is int)
    return f;
  if (f is Function) {
    try {
      return f();
    } catch (e) {}
  }
  return null;
}

/** Add [className] to [element] CSS classes is [value] is true, Remove it 
 * otherwise.
 */
void setClass(Element element, String className, bool value) {
  if (value)
    element.classes.add(className);
  else
    element.classes.remove(className);
}

/** Generates random bytes array of given [size].
 */
List<int> randomBytes(int size) {
  final List<int> list = new List<int>();
  for (int i = 0; i < size; i++)
    list.add(_random.nextInt(256));
}

get _random => fallback(_r, () => _r = new Random());
Random _r;

/** A token object for identification with recognizable toString() output for
 * easier debugging.
 */
class Token {
  @override
  String toString() => fallback(_str, () => _str = _gen());
  String _str;
  static String _gen() => CryptoUtils.bytesToHex(randomBytes(4));
}
