library bootjack;

import 'dart:html';
import 'dart:html_common';
import 'dart:async';
import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:rikulo_commons/html.dart';
import 'package:dquery/dquery.dart';
import 'bootjack_plugin.dart' as p;

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

/** A collection of top level Bootjack static methods.
 */
class Bootjack {
  
  /** Register the uses of all default Bootjack components.
   */
  static void useDefault() {
    for (Function f in [
  Affix.use, Alert.use, Button.use, Carousel.use, Collapse.use, Dropdown.use,
  Modal.use, Scrollspy.use, Tab.use, Transition.use]) 
      f();
  }
}
