part of bootjack;

// TODO: keydown

/**
 * 
 */
class Dropdown extends Base {
  
  static final String _TOGGLE_SELECTOR ='[data-toggle=dropdown]'; 
  
  Dropdown(Element element) : super(element) {
    $element.on('click.dropdown.data-api', _toggle);
    $('html').on('click.dropdown.data-api', (DQueryEvent e) { // TODO: why not document?
      Element p = element.parent;
      if (p != null)
        p.classes.remove('open');
    });
  }
  
  void toggle() => _toggle(element);
  
  static void _toggleEvent(DQueryEvent e) {
    _toggle(e.target as Element);
    if (e != null)
      e.stopPropagation(); // TODO: check jQuery spec on return value false
  }
  
  static void _toggle(Element elem) {
    if (elem.matches('.disabled, :disabled'))
      return;
    final Element parent = _getParent(elem);
    final bool isActive = parent.classes.contains('open');
    
    _clearMenus();
    
    if (!isActive)
      parent.classes.toggle('open');
    
    $(elem).trigger('focus');
  }
  
  static void _keydown(DQueryEvent e) {
    Event oe = e.originalEvent;
    if (!(oe is KeyEvent))
      return;
    final KeyEvent ke = oe as KeyEvent;
    final int keyCode = ke.keyCode;
    
    if (keyCode != 38 && keyCode != 40 && keyCode != 27)
      return;
    
    e.preventDefault();
    e.stopPropagation();
    
    if (element.classes.contains('disabled') || element.attributes.containsKey('disabled'))
      return;
    // TODO: check
    // src: if ($this.is('.disabled, :disabled')) return
    
    final Element parent = _getParent(element);
    final bool isActive = parent.classes.contains('open');
    
    if (keyCode == 27)
      $(parent).find(_TOGGLE_SELECTOR).trigger('focus');
    
    if (!isActive || keyCode == 27)
      $element.trigger('click');
    
    final ElementQuery $items = $('[role=menu] li:not(.divider):visible a', parent);
    
    if ($items.isEmpty)
      return;
    
    int index = 0;
    // TODO
    // src: index = $items.index($items.filter(':focus'))
    
    if (keyCode == 38 && index > 0)
      index--; // up
    else if (keyCode == 40 && index < $items.length - 1)
      index++; // down
    if (index == -1)
      index = 0;
    
    /*
    $items
    .eq(index)
    .focus()
    */
    
  }
  
  static void _clearMenus() {
    for (Element elem in $(_TOGGLE_SELECTOR))
      _getParent(elem).classes.remove('open');
  }

  static Element _getParent(Element elem) {
    String selector = elem.attributes['data-target']; // TODO: use dataset?
    if (selector == null) {
      selector = elem.attributes['href'];
      // TODO
      // src: selector = selector && /#/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }
    if (selector != null) {
      ElementQuery p = $(selector);
      if (!p.isEmpty)
        return p.first;
    }
    return elem.parent;
  }
  
  static void register() {
    $document()
    ..on('click.dropdown.data-api', (DQueryEvent e) => _clearMenus())
    ..on('click.dropdown.data-api', (DQueryEvent e) => e.stopPropagation(), selector: '.dropdown form')
    ..on('click.dropdown-menu', (DQueryEvent e) => e.stopPropagation())
    ..on('click.dropdown.data-api', _toggleEvent, selector: _TOGGLE_SELECTOR)
    ..on('keydown.dropdown.data-api', _keydown, selector: "${_TOGGLE_SELECTOR}, [role=menu]");
  }
  
}

/*

  // DROPDOWN PLUGIN DEFINITION
  // ========================== 

  $.fn.dropdown = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('dropdown')
      if (!data) $this.data('dropdown', (data = new Dropdown(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

*/
