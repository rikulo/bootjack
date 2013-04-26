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

class Base {
  
  final Element element;
  final ElementQuery $element;
  
  Base(Element element, String name) : 
  this.element = element,
  $element = $(element) {
    $element.data.set(name, this);
  }
  
}

_wire(Element elem, String name, create()) =>
    _fallback($(elem).data.get(name), create); // create shall save it back

class Bootjack {
  
  /**
   * 
   */
  void use(List<String> names) {
    // TODO: batch register
  }
  
}


