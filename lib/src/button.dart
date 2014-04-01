part of bootjack;

/** A button component.
 */
class Button extends Base {
  
  static const String _NAME = 'button';
  
  /** The default text setting of button.
   */
  static final Map<String, String> DEFAULT_TEXTS = {
    'loadingText': 'loading...'
  };
  
  /** The text setting this button.
   * See [setState].
   */
  final Map<String, String> texts;
  
  /** Construct a button object, wired to [element].
   * 
   * + [texts] - determines Button text corresponding to the state.
   */
  Button(Element element, {Map<String, String> texts}) : 
  this.texts = _copy(DEFAULT_TEXTS, texts), 
  super(element, _NAME);
  
  /** Retrieve the wired Button object from an element. If there is no wired
   * Button object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Button creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Button wire(Element element, [Button create()]) => 
      p.wire(element, _NAME, p.fallback(create, () => () => new Button(element)));
  
  /** Set the button state, which will change the button text according to [texts]
   * setting.
   */
  Future setState(String state) {
    final String d = 'disabled';
    final Map space = $element.data.space;
    final bool isInput = element is InputElement;
    final String value = isInput ? (element as InputElement).value : element.innerHtml;
    
    state = "${state}Text";
    space.putIfAbsent('resetText', () => value);
    final String newStateText = p.fallback(space[state], () => texts[state]);
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
  
  /** Toogle the `active` class on the button. If the button is of radio type,
   * other associated buttons will react accordingly.
   */
  void toggle() {
    ElementQuery $parent = $element.closest('[data-toggle="buttons-radio"]');
    if (!$parent.isEmpty)
      $parent.find('.active').removeClass('active');
    element.classes.toggle('active');
  }
  
  // Data API //
  static bool _registered = false;
  
  /** Register to use Button component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $document().on('click.button.data-api', (QueryEvent e) {
      if (e.target is Element) {
        final ElementQuery $btn = $(e.target).closest('.btn');
        if (!$btn.isEmpty)
          Button.wire($btn.first).toggle();
      }
      
    }, selector: '[data-toggle^=button]');
  }
  
}
