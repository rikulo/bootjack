library bootjack;

import 'dart:html';
import 'dart:html_common';
import 'dart:async';
import 'dart:collection';

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

// TODO: may need to wire up DQuery data-attributes
// TODO: enforce _register runs only once

/**
 * 
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

/**
 * 
 */
class Bootjack {
  
  /**
   * 
   */
  static void use(List<String> names) {
    for (String n in names) {
      _F f = _USE_MAP[n];
      if (f != null)
        f();
    }
  }
  
}

typedef void _F();

final Map<String, _F> _USE_MAP = new HashMap<String, _F>.from({
  'alert': Alert._register,
  'button': Button._register,
  'dropdown': Dropdown._register,
  'modal': Modal._register,
  'transition': Transition._register
});


