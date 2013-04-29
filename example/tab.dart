import 'dart:html';
import 'package:bootjack/bootjack.dart';

void main() {
  
  Bootjack.use(['tab']);
  
  Tab.wire(document.query('#myTab a')).show();
  
}