import 'dart:html';
import 'package:dquery/dquery.dart';
import 'package:bootjack/bootjack.dart';

void main() {
  
  Modal.register();
  
  $('#btn').on('click', (DQueryEvent e) {
    new Modal($('#myModal').first).toggle();
  });
  
}