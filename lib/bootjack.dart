library bootjack;

import 'dart:html';
import 'dart:html_common';
import 'dart:async';
import 'dart:collection';

import 'package:rikulo_commons/html.dart';
import 'package:dquery/dquery.dart';

part 'src/util/util.dart';

part 'src/affix.dart';
part 'src/alert.dart';
part 'src/button.dart';
part 'src/carousel.dart';
part 'src/collapse.dart';
part 'src/dropdown.dart';
part 'src/modal.dart';
part 'src/popover.dart';
part 'src/scrollspy.dart';
part 'src/tab.dart';
part 'src/tooltip.dart';
part 'src/transition.dart';
part 'src/typeahead.dart';

/** The skeleton class for Bootjack components.
 */
abstract class Base {
  
  /// The element which component wires to.
  final Element element;
  
  /// The dquery object of [element]. Equivalent to $(element).
  final ElementQuery $element;
  
  Base(Element element, String name) : 
  this.element = element,
  $element = $(element) {
    $element.data.set(name, this);
  }
  
}

_wire(Element elem, String name, create()) =>
    _fallback($(elem).data.get(name), create); // create shall save it back

_dataTarget(Element elem) =>
    _fallback(elem.attributes['data-target'], () => elem.attributes['href']);
// selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7 // skipped

/** A collection of top level Bootjack static methods.
 */
class Bootjack {
  
  /** Register the uses of all default Bootjack components.
   */
  static void useDefault() {
    for (Function f in [
  Affix.use, Alert.use, Button.use, Carousel.use, Collapse.use, Dropdown.use,
  Modal.use, Scrollspy.use, Tab.use, Transition.use, Typeahead.use]) 
      f();
  }
}
