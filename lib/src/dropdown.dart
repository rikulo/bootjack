part of bootjack;

// TODO: check source code, in 3.0 it fires events

/** A dropdown component.
 */
class Dropdown extends Base {
  
  static const String _NAME = 'dropdown';
  static const String _TOGGLE_SELECTOR ='[data-toggle=dropdown]'; 
  
  /** Construct a Dropdown object and wire it to [element].
   */
  Dropdown(Element element) : 
  super(element, _NAME) {
    Dropdown.use();
    $element.on('click.bs.dropdown', _toggleEvent);
  }
  
  /** Retrieve the wired Dropdown object from an element. If there is no wired
   * Dropdown object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Dropdown creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Dropdown wire(Element element, [Dropdown create()]) =>
      p.wire(element, _NAME, p.fallback(create, () => () => new Dropdown(element)));
  
  /** Toggle the open/close state of the Dropdown.
   */
  void toggle() => _toggle(element);
  
  static void _toggleEvent(QueryEvent e) {
    _toggle(e.currentTarget as Element);
    if (e != null)
      e.stopPropagation(); // TODO: check jQuery spec on return value false
  }
  
  static void _toggle(Element elem) {
    if (elem.matches('.disabled, :disabled'))
      return;
    final Element parent = _getParent(elem);
    final ElementQuery $parent = $(parent);
    final bool isActive = parent.classes.contains('open');
    
    _clearMenus();
    
    if (!isActive) {
      
      // TODO: mobile, see bootstrap
      
      final QueryEvent e = new QueryEvent('show.bs.dropdown');
      $parent.triggerEvent(e);
      
      if (e.defaultPrevented)
        return;
      
      parent.classes.toggle('open');
      $(parent).trigger('shown.bs.dropdown');
      
      elem.focus();
    }
    
  }
  
  static void _keydown(QueryEvent e) {
    final Element elem = e.currentTarget as Element;
    
    Event oe = e.originalEvent;
    if (!(oe is KeyboardEvent))
      return;
    final KeyboardEvent ke = oe;
    final int keyCode = ke.keyCode;
    
    if (keyCode != 38 && keyCode != 40 && keyCode != 27)
      return;
    
    e.preventDefault();
    e.stopPropagation();
    
    if (elem.matches('.disabled, :disabled'))
      return;
    
    final Element parent = _getParent(elem);
    final bool isActive = parent.classes.contains('open');
    
    if (!isActive || (isActive && keyCode == 27)) {
      if (keyCode == 27) 
        $(parent).find(_TOGGLE_SELECTOR)[0].focus();
      
      elem.click();
      return;
    }
    
//    final ElementQuery $items = $('[role=menu] li:not(.divider):visible a', parent); css selector doesn't support :visible.
    List<Element> $items = new List<Element>();
    for (Element e in  $('[role=menu] li:not(.divider)', parent)) {
      if (!p.isHidden(e)) {
        Element a = e.querySelector('a');
        if (a != null)
          $items.add(a);
      }
    }
    
    if ($items.isEmpty)
      return;
    
    int index = _indexWhere($items, (Element e) => e.matches(':focus'));
    if (keyCode == 38 && index > 0)
      index--; // up
    else if (keyCode == 40 && index < $items.length - 1)
      index++; // down
    if (index == -1)
      index = 0;
    
    $($items[index])[0].focus();
    
  }
  
  static int _indexWhere(List<Element> elems, bool f(Element elem)) {
    int i = 0;
    for (Element e in elems) {
      if (f(e))
        return i;
      i++;
    }
    return -1;
  }
  
  static void _clearMenus() {
    // TODO: mobile, see bootstrap
    for (Element elem in $(_TOGGLE_SELECTOR)) {
      final Element parent = _getParent(elem);
      final ElementQuery $parent = $(parent);
      if (!parent.classes.contains('open'))
        continue;
      
      final QueryEvent e = new QueryEvent('hide.bs.dropdown');
      $parent.triggerEvent(e);
      if (e.defaultPrevented)
        continue;
      
      $parent.removeClass('open');
      $parent.trigger('hidden.bs.dropdown');
    }
  }
  
  static Element _getParent(Element elem) {
    String selector = p.getDataTarget(elem);
    
    if (selector == null) {
      selector = elem.attributes['href'];
      if (selector != null && new RegExp(r'#').hasMatch(selector)) {
        selector = selector.replaceAll(new RegExp(r'.*(?=#[^\s]*$'), ''); //strip for ie7
      }
    }
    
    if (selector != null) {
      try {
        final ElementQuery p = $(selector);
        if (!p.isEmpty)
          return p.first;
      } catch (e) {}
    }
    return elem.parent;
  }
  
  // Data API //
  static bool _registered = false;
  
  /** Register to use Dropdown component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $document()
    ..on('click.bs.dropdown.data-api', (QueryEvent e) => _clearMenus())
    ..on('click.bs.dropdown.data-api', (QueryEvent e) => e.stopPropagation(), selector: '.dropdown form')
    ..on('click.bs.dropdown.data-api', _toggleEvent, selector: _TOGGLE_SELECTOR)
    ..on('keydown.bs.dropdown.data-api', _keydown, selector: "${_TOGGLE_SELECTOR}, [role=menu]");
  }
  
}
