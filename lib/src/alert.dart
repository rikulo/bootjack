part of bootjack;

/** An alert message box component.
 */
class Alert extends Base {
  
  static const String _NAME = 'alert';
  static const String _DISMISS_SELECTOR = '[data-dismiss="alert"]';
  
  /** Construct an Alert object and wire it to [element].
   */
  Alert(Element element) :  
  super(element, _NAME) {
    $(element).on('click', _closeHandler, selector: _DISMISS_SELECTOR);
  }
  
  /** Retrieve the wired Alert object from an element. If there is no wired
   * Alert object, a new one will be created.
   * + If [create] is provided, it will be used for Alert creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Alert wire(Element element, [Alert create()]) =>
      _wire(element, _NAME, _fallback(create, () => () => new Alert(element)));
  
  /** Detach the Alert component from DOM.
   */
  void close() {
    _close(element);
  }
  
  static void _close(Element elem) {
    final String selector = _dataTarget(elem);
    
    ElementQuery $parent;
    
    try {
      $parent = $(selector);
    } catch(e) {}
    
    if ($parent == null || $parent.isEmpty)
      $parent = elem.classes.contains('alert') ? $(elem) : $(elem.parent);
    
    if ($parent.isEmpty)
      return;
    
    final DQueryEvent e = new DQueryEvent('close');
    $parent.triggerEvent(e);
    
    if (e.isDefaultPrevented)
      return;
    
    final Element parent = $parent.first;
    parent.classes.remove('in');
    
    if (Transition.isUsed && parent.classes.contains('fade'))
      $parent.on(Transition.end, (e) => _removeElement($parent));
    
    else
      _removeElement($parent);
  }
  
  static void _closeHandler(DQueryEvent e) {
    e.preventDefault();
    if (e.target is Element)
      _close(e.target);
  }
  
  static void _removeElement(ElementQuery $elem) {
    $elem.trigger('closed');
    $elem.forEach((Element e) => e.remove());
  }
  
  // Data API //
  static bool _registered = false;
  
  static void _register() {
    if (_registered) return;
    _registered = true;
    
    $document().on('click.alert.data-api', _closeHandler, selector: _DISMISS_SELECTOR);
  }
  
}
