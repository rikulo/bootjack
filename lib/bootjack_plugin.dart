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
fallback(a, b()) => a != null ? a : b();

/** Retrieve the value of data-target attribute of href attribute on given
 * [element].
 */
String getDataTarget(Element element) =>
    fallback(element.attributes['data-target'], () => element.attributes['href']);
// selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7 // skipped
