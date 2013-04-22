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

class Base {
  
  Element get element => _element;
  final Element _element;
  
  Base(this._element);
  
}

class Bootjack {
  
  /**
   * 
   */
  void use() {
    // TODO: batch register
  }
  
}


