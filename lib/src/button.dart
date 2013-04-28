part of bootjack;

/**
 * 
 */
class Button extends Base {
  
  static const String _NAME = 'button';
  
  static final Map<String, String> DEFAULT_TEXTS = {
    'loadingText': 'loading...'
  };
  
  /**
   * 
   */
  final Map<String, String> texts;
  
  /**
   * 
   */
  Button(Element element, {Map<String, String> texts}) : 
  this.texts = _copy(DEFAULT_TEXTS, texts), 
  super(element, _NAME);
  
  /**
   * 
   */
  static Button wire(Element element, [Button create()]) => 
      _wire(element, _NAME, _fallback(create, () => () => new Button(element)));
  
  /**
   * 
   */
  Future setState(String state) {
    final String d = 'disabled';
    final Map space = $element.data.space();
    final bool isInput = element is InputElement;
    final String value = isInput ? (element as InputElement).value : element.innerHtml;
    
    state = "${state}Text";
    space.putIfAbsent('resetText', () => value);
    final String newStateText = _fallback(space[state], () => texts[state]);
    if (isInput)
      (element as InputElement).value = newStateText;
    else
      element.innerHtml = newStateText;
    
    // push to event loop to allow forms to submit
    return new Future.delayed(const Duration(), () {
      if (state == 'loadingText') {
        element.classes.add(d);
        element.attributes[d] = d;
      } else {
        element.classes.remove(d);
        element.attributes.remove(d);
      }
    });
    
  }
  
  /**
   * 
   */
  void toggle() {
    Element parent = _closest(element, 
        (Element elem) => elem.attributes['data-toggle'] == 'buttons-radio');
    if (parent != null)
      for (Element c in parent.queryAll('.active'))
        c.classes.remove('active');
    element.classes.toggle('active');
  }
  
  // Data API //
  static bool _registered = false;
  
  static void _register() {
    if (_registered) return;
    _registered = true;
    
    $document().on('click.button.data-api', (DQueryEvent e) {
      if (e.target is Element) {
        final ElementQuery $btn = $(e.target).closest('.btn');
        if (!$btn.isEmpty)
          Button.wire($btn.first).toggle();
      }
      
    }, selector: '[data-toggle^=button]');
  }
  
}
