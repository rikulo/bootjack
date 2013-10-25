import 'dart:html';
import 'package:dquery/dquery.dart';
import 'package:bootjack/bootjack.dart';

final List<String> COLORS = [
  ' alert-danger', ' alert-warning', ' alert-success', ' alert-info'
];

void main() {
  
  Bootjack.useDefault(); // use all
  
  final Element alertPool = document.querySelector('#alert-pool');
  int i = 0;
  
  $('#alert-spawn-btn').on('click', (DQueryEvent e) {
    
    alertPool.appendHtml('''
      <div class="alert${COLORS[i]} alert-dismissable fade in">
        <button type="button" class="close" data-dismiss="alert">&times;</button>
        Oh snap! A new <code>alert</code> spawned.
      </div>
    ''');
    
    i = (i + 1) % 4;
    
  });
  
  $('#btn').on('click', (DQueryEvent e) {
    $('#btn')
    ..toggleClass('btn-info')
    ..toggleClass('btn-danger');
  });
  
}
