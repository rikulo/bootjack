part of bootjack;

// required jQuery features:
// classes
// traversing: find()
// event: $.Event()/one()/trigger()
// $.camelCase()
// effect!
// attr()
// data()
// on()

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
  
  /**
   * 
   */
  String get dimension => 
      element.classes.contains('width') ? 'width' : 'height';
  
  bool get _horizontal =>
      element.classes.contains('width');
  
  void show() {
    if (_transitioning || element.classes.contains('in'))
      return;
    
    final String scroll = element.classes.contains('width') ? 'scrollWidth' : 'scrollHeight';
    
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
    
    _transition('addClass', new DQueryEvent('show'), 'shown');
    if (Transition.isUsed) {
      if (_horizontal)
        element.style.width = '${element.scrollWidth}px';
      else
        element.style.height = '${element.scrollHeight}px';
    }
    
  }
  
  void hide() {
    if (_transitioning || !element.classes.contains('in'))
      return;
    /*
    this.reset(this.$element[dimension]())
    */
    _transition('removeClass', new DQueryEvent('hide'), 'hidden');
    _clearSize();
    
  }
  
  void reset(size) {
    element.classes.remove('collapse');
    /*
    this.$element
    [dimension](size || 'auto')
    */
    element.offsetWidth;
    /*
    this.$element[size !== null ? 'addClass' : 'removeClass']('collapse')
    */
  }
  
  void _clearSize() {
    if (_horizontal)
      element.style.width = '0';
    else
      element.style.height = '0';
  }
  
  void _transition(String method, DQueryEvent startEvent, String completeEvent) {
    /*
    var that = this
        , complete = function () {
            if (startEvent.type == 'show') that.reset()
            that.transitioning = 0
            that.$element.trigger(completeEvent)
          }

    this.$element.trigger(startEvent)

    if (startEvent.isDefaultPrevented()) return

    this.transitioning = 1

    this.$element[method]('in')

    $.support.transition && this.$element.hasClass('collapse') ?
      this.$element.one($.support.transition.end, complete) :
      complete()
    */
  }
  
  void toggle() {
    /*
    this[this.$element.hasClass('in') ? 'hide' : 'show']()
    */
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