part of bootjack;

// required jQuery features:
// attr()/removeAttr()
// classes
// traversing: find()/closest()
// data()
// on()

class Button extends Base {
  
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
  Button(Element element, [Map<String, String> texts]) : 
  this.texts = _copy(DEFAULT_TEXTS, texts), 
  super(element);
  
  /**
   * 
   */
  Future setState(String state) {
    final String d = 'disabled';
    final Element el = element;
    final Map space = $(el).data.space();
    final bool isInput = el is InputElement;
    final String value = isInput ? (el as InputElement).value : el.innerHtml;
    
    state = "${state}Text";
    space.putIfAbsent('resetText', () => value);
    final String newStateText = _fallback(space[state], () => texts[state]);
    if (isInput)
      (el as InputElement).value = newStateText;
    else
      el.innerHtml = newStateText;
    
    // push to event loop to allow forms to submit
    return new Future.delayed(const Duration(), () {
      if (state == 'loadingText') {
        el.classes.add(d);
        el.attributes[d] = d;
      } else {
        el.classes.remove(d);
        el.attributes.remove(d);
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
  /**
   * 
   */
  static void register() {
    $(document).on('click.button.data-api', (DQueryEvent e) {
      if (!(e.target is Element))
        return;
      Element target = e.target as Element;
      if (!target.classes.contains('btn'))
        target = _closest(target, (Element elem) => elem.classes.contains('btn'));
      $(target).data.space().putIfAbsent('button', () => new Button(target)).toggle();
    }, selector: '[data-toggle^=button]');
  }
  
}

/*
 // BUTTON PLUGIN DEFINITION
 // ======================== 

  $.fn.button = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('button')
        , options = typeof option == 'object' && option
      if (!data) $this.data('button', (data = new Button(this, options)))
      if (option == 'toggle') data.toggle()
      else if (option) data.setState(option)
    })
  }
*/
