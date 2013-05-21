part of bootjack;

class Collapse extends Base {
  
  static const String _NAME = 'collapse';
  
  /**
   * 
   */
  Collapse(Element element, {bool toggle: true, Element parent}) :
  super(element, _NAME) {
    if (parent != null)
      _$parent = $(parent);
    if (toggle)
      this.toggle();
  }
  
  ElementQuery _$parent;
  
  bool get transitioning => _transitioning;
  bool _transitioning = false;
  
  bool get horizontal => p.fallback(_horizontal, 
      () => _horizontal = element.classes.contains('width'));
  bool _horizontal;
  
  void show() {
    if (_transitioning || element.classes.contains('in'))
      return;
    
    final String scroll = horizontal ? 'scrollWidth' : 'scrollHeight';
    
    if (_$parent != null) {
      ElementQuery $actives = _$parent.children('.accordion-group').children('.in');
      if (!$actives.isEmpty) {
        /*
        hasData = actives.data('collapse')
        if (hasData && hasData.transitioning) return
        actives.collapse('hide')
        hasData || actives.data('collapse', null)
        */
      }
    }
    
    _clearSize();
    
    _transition(true, new DQueryEvent('show'), 'shown');
    if (Transition.isUsed) {
      if (horizontal)
        element.style.width = '${element.scrollWidth}px';
      else
        element.style.height = '${element.scrollHeight}px';
    }
    
  }
  
  void hide() {
    if (_transitioning || !element.classes.contains('in'))
      return;
    reset(horizontal ? $element.width : $element.height);
    _transition(false, new DQueryEvent('hide'), 'hidden');
    _clearSize();
    
  }
  
  void reset(int size) {
    element.classes.remove('collapse');
    // TODO: check jQuery spec
    /*
    this.$element
    [dimension](size || 'auto')
    */
    
    element.offsetWidth; // force reflow
    
    if (size != null)
      element.classes.add('collapse');
    else
      element.classes.remove('collapse');
  }
  
  void _clearSize() {
    if (_horizontal)
      element.style.width = '0';
    else
      element.style.height = '0';
  }
  
  void _transition(bool add, DQueryEvent startEvent, String completeEvent) {
    
    $element.triggerEvent(startEvent);
    if (startEvent.isDefaultPrevented)
      return;
    
    _transitioning = true;
    
    if (add)
      element.classes.add('in');
    else
      element.classes.remove('in');
    
    final DQueryEventListener complete = (DQueryEvent e) {
      if (startEvent.type == 'show')
        reset();
      _transitioning = false;
      $element.trigger(completeEvent);
    };
    
    if (Transition.isUsed && element.classes.contains('collapse'))
      $element.one(Transition.end, complete);
    else
      complete(null);
    
  }
  
  void toggle() {
    if (element.classes.contains('in'))
      hide();
    else
      show();
  }
  
  static bool _registered = false;
  
  /** Register to use Collapse component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    /*
    $(document).on('click.collapse.data-api', '[data-toggle=collapse]', function (e) {
      var $this = $(this), href
          , target = $this.attr('data-target')
          || e.preventDefault()
          || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '') //strip for ie7
          , option = $(target).data('collapse') ? 'toggle' : $this.data()
              $this[$(target).hasClass('in') ? 'addClass' : 'removeClass']('collapsed')
              $(target).collapse(option)
    })
    */
  }
  
}

/*
 // COLLAPSE PLUGIN DEFINITION
 // ========================== 

  $.fn.collapse = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('collapse')
        , options = $.extend({}, $.fn.collapse.defaults, $this.data(), typeof option == 'object' && option)
      if (!data) $this.data('collapse', (data = new Collapse(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

*/