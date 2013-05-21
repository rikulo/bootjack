part of bootjack;

/**
 * 
 */
class Affix extends Base {
  
  static const String _NAME = 'affix';
  
  const int _DEFAULT_OFFSET = 10;
  final offsetTop, offsetBottom;
  
  /** 
   * 
   */
  Affix(Element element, {offsetTop: _DEFAULT_OFFSET, offsetBottom: _DEFAULT_OFFSET}) : 
  this.offsetTop = offsetTop,
  this.offsetBottom = offsetBottom,
  super(element, _NAME) {
    $(window)
    ..on('scroll.affix.data-api', (DQueryEvent e) => checkPosition())
    ..on('click.affix.data-api', (DQueryEvent e) {
      new Future.delayed(const Duration(millisecond: 1), checkPosition);
    });
    checkPosition();
  }
  
  /**
   * 
   */
  static Affix wire(Element element, [Affix create()]) =>
      p.wire(element, _NAME, p.fallback(create, () => () => new Affix(element)));
  
  /**
   * 
   */
  void checkPosition() {
    if (!element.matches(':visible'))
      return;
    
    final int offsetTop = _offsetValue(this.offsetTop);
    final int offsetBottom = _offsetValue(this.offsetBottom);
    
    final int scrollHeight = $document().height();
    final int scrollTop = window.pageYOffset;
    final int positionTop = element.offsetTop;
    
    String affix = _unpin != null && scrollTop + _unpin <= positionTop ? 'false' : 
      offsetBottom != null && (positionTop + element.offsetHeight >= scrollHeight - offsetBottom) ? 'bottom' :
      offsetTop != null && scrollTop <= offsetTop ? 'top' : 'false';
    
    if (_affixed == affix)
      return;
    _affixed = affix;
    _unpin = affix == 'bottom' ? positionTop - scrollTop : null;
    
    element.classes
    ..remove('affix')
    ..remove('affix-top')
    ..remove('affix-bottom')
    ..add(affix == 'bottom' ? 'affix-bottom' : affix == 'top' ? 'affix-top' : 'affix');
    
  }
  
  int _offsetValue(f) {
    if (f is int)
      return f;
    if (f is Function) {
      try {
        return f();
      } catch(e) {}
    }
    return _DEFAULT_OFFSET;
  }
  
  String _affixed;
  int _unpin;
  
  static bool _registered = false;
  
  /** Register to use Affix component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $window().on('load', (DQueryEvent e) {
      for (Element elem in $('[data-spy="affix"]')) {
        // TODO: pass data
        /*
        data.offset = data.offset || {}
        data.offsetBottom && (data.offset.bottom = data.offsetBottom)
        data.offsetTop && (data.offset.top = data.offsetTop)
        */
        Affix.wire(elem);
      }
    });
  }
  
}
/*
 // AFFIX PLUGIN DEFINITION
 // ======================= 

  var old = $.fn.affix

  $.fn.affix = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('affix')
        , options = typeof option == 'object' && option
      if (!data) $this.data('affix', (data = new Affix(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

*/