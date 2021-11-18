part of bootjack;

/** An alert message box component.
 */
class Alert extends Base {
  
  static const _name = 'alert';
  static const _dissmissSelector = '[data-dismiss="alert"]';
  
  /** Construct an Alert object and wire it to [element].
   */
  Alert(Element element) :  
  super(element, _name) {
    $(element).on('click', _closeHandler, selector: _dissmissSelector);
  }
  
  /** Retrieve the wired Alert object from an element. If there is no wired
   * Alert object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Alert creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Alert wire(Element element, [Alert create()?]) =>
      p.wire(element, _name, create ?? (() => Alert(element)));
  
  /** Detach the Alert component from DOM.
   */
  void close() {
    _close(element);
  }
  
  static void _close(Element elem) {
    final selector = p.getDataTarget(elem);
    
    ElementQuery? $parent;
    
    try {
      $parent = $(selector);
    } catch(e) {}
    
    if ($parent?.isEmpty ?? true)
      $parent = elem.classes.contains('alert') ? $(elem) : $(elem.parent);
    
    if ($parent!.isEmpty)
      return;
    
    final e = QueryEvent('close.bs.alert');
    $parent.triggerEvent(e);
    
    if (e.defaultPrevented)
      return;
    
    final parent = $parent.first;
    parent.classes.remove('in');
    
    if (Transition.isUsed && parent.classes.contains('fade'))
      $parent.on(Transition.end, (e) => _removeElement($parent!));
    
    else
      _removeElement($parent);
  }
  
  static void _closeHandler(QueryEvent e) {
    e.preventDefault();
    final target = e.target;
    if (target is Element)
      _close(target);
  }
  
  static void _removeElement(ElementQuery $elem) {
    $elem.trigger('closed.bs.alert');
    $elem.forEach((Element e) => e.remove());
  }
  
  // Data API //
  static bool _registered = false;
  
  /** Register to use Alert component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $document()
      .on('click.alert.data-api', _closeHandler, selector: _dissmissSelector);
  }

  /** Register to use Alert into a ShadowDom
   *  In your component (likes Polymer or Angular) overide the method void onShadowRoot(ShadowRoot shadowRoot)
   *  and initialize the Alert compoment ( Alert.useInShadowDom( shadowRoot) 
   */
  static void useInShadowDom( ShadowRoot shadowRoot) {
    $shadowRoot(shadowRoot)
      .on('click.alert.data-api', _closeHandler, selector: Alert._dissmissSelector);
  }  
}
