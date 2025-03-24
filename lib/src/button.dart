part of bootjack;

/** A button component.
 */
class Button extends Base {
  
  static const _name = 'button';
  
  /** The default text setting of button.
   */
  static final DEFAULT_TEXTS = <String, String>{
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
  Button(Element element, {Map<String, String>? texts}) :
  this.texts = _copy(DEFAULT_TEXTS, texts), 
  super(element, _name);
  
  /** Retrieve the wired Button object from an element. If there is no wired
   * Button object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Button creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Button? wire(Element element, [Button? create()?]) =>
      p.wire(element, _name, create ?? (() => Button(element)));
  
  /** Set the button state, which will change the button text according to [texts]
   * setting.
   */
  Future setState(String state) {
    final d = 'disabled',
      space = $element.data.space!,
      isInput = element.isA<HTMLInputElement>(),
      value = isInput ? (element as HTMLInputElement).value : element.innerHTML;
    
    state = "${state}Text";
    space.putIfAbsent('resetText', () => value);
    final newStateText = (space[state] as String?) ?? texts[state] ?? '';
    if (isInput)
      (element as HTMLInputElement).value = newStateText;
    else
      element.innerHTML = newStateText.toJS;
    
    // push to event loop to allow forms to submit
    return Future.delayed(Duration.zero, () {
      if (state == 'loadingText') {
        element.classList.add(d);
        element.setAttribute(d, d);
      } else {
        element.classList.remove(d);
        element.removeAttribute(d);
      }
    });
    
  }
  
  /** Toogle the `active` class on the button. If the button is of radio type,
   * other associated buttons will react accordingly.
   */
  void toggle() {
    final $parent = $element.closest('[data-toggle="buttons-radio"]');
    if ($parent.isNotEmpty)
      $parent.find('.active').removeClass('active');
    element.classList.toggle('active');
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
        final $btn = $(e.target).closest('.btn');
        if ($btn.isNotEmpty)
          Button.wire($btn.first)!.toggle();
      }
      
    }, selector: '[data-toggle^=button]');
  }
  
}
