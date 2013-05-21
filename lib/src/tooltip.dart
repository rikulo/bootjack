part of bootjack;

// required jQuery features:
// classes
// traversing: find()
// event: $.Event()/trigger()
// offset()/css()
// detach()
// attr()
// data()
// on()/off()

class Tooltip extends Base {
  
  static const String _NAME = 'tooltip';
  static const String _DEF_PLACEMENT = 'top';
  static const String _DEF_TEMPLATE = 
      '<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>';
  
  final String template;
  final String _type;
  final bool animation;
  
  final placement; // TODO: funciton or string
  
  Tooltip(Element element, {bool animation: true, placement: _DEF_PLACEMENT, 
  selector: false, String template: _DEF_TEMPLATE, String trigger: 'hover focus',
  String title: '', int delay: 0, html: false, container: false}) : 
  this.animation = animation,
  this.placement = placement,
  this.template = template,
  _type = _NAME,
  super(element, _NAME) {
    
  }
  
  bool _enabled = false;
  
  /*

  var Tooltip = function (element, options) {
    this.init('tooltip', element, options)
  }

  , init: function (type, element, options) {
      var eventIn
        , eventOut
        , triggers
        , trigger
        , i

      this.type = type
      this.options = this.getOptions(options)
      this.enabled = true

      triggers = this.options.trigger.split(' ')

      for (i = triggers.length; i--;) {
        trigger = triggers[i]
        if (trigger == 'click') {
          this.$element.on('click.' + this.type, this.options.selector, $.proxy(this.toggle, this))
        } else if (trigger != 'manual') {
          eventIn = trigger == 'hover' ? 'mouseenter' : 'focus'
          eventOut = trigger == 'hover' ? 'mouseleave' : 'blur'
          this.$element.on(eventIn + '.' + this.type, this.options.selector, $.proxy(this.enter, this))
          this.$element.on(eventOut + '.' + this.type, this.options.selector, $.proxy(this.leave, this))
        }
      }

      this.options.selector ?
        (this._options = $.extend({}, this.options, { trigger: 'manual', selector: '' })) :
        this.fixTitle()
    }
  */
  
  /*
  , getOptions: function (options) {
      options = $.extend({}, $.fn[this.type].defaults, this.$element.data(), options)

      if (options.delay && typeof options.delay == 'number') {
        options.delay = {
          show: options.delay
        , hide: options.delay
        }
      }

      return options
    }
  */
  
  static void _enter(DQueryEvent e) {
    /*
    var defaults = $.fn[this.type].defaults
        , options = {}
        , self

      this._options && $.each(this._options, function (key, value) {
        if (defaults[key] != value) options[key] = value
      }, this)

      self = $(e.currentTarget)[this.type](options).data(this.type)

      if (!self.options.delay || !self.options.delay.show) return self.show()

      clearTimeout(this.timeout)
      self.hoverState = 'in'
      this.timeout = setTimeout(function() {
        if (self.hoverState == 'in') self.show()
      }, self.options.delay.show)
    */
    
  }
  
  static void  _leave(DQueryEvent e) {
    /*
    var self = $(e.currentTarget)[this.type](this._options).data(this.type)

    if (this.timeout) clearTimeout(this.timeout)
    if (!self.options.delay || !self.options.delay.hide) return self.hide()

    self.hoverState = 'out'
    this.timeout = setTimeout(function() {
      if (self.hoverState == 'out') self.hide()
    }, self.options.delay.hide)
    */
  }
  
  void show() {
    DQueryEvent e = new DQueryEvent(e);
    /*
    , pos
    , actualWidth
    , actualHeight
    , placement
    , tp
    */
    if (hasContent && _enabled) {
      $element.trigger(e);
      if (e.isDefaultPrevented) 
        return;
      
      setContent();
      if (animation)
        tip.classes.add('fade');
      
      final String placement = _placement(this.placement);
      
      tip.remove();
      tip.style.top = tip.style.left = '0';
      tip.style.display = 'block';
      
      /*
      this.options.container ? $tip.appendTo(this.options.container) : $tip.insertAfter(this.$element)
      pos = this.getPosition()
      */
      
      final int actualWidth = tip.offsetWidth;
      final int actualHeight = tip.offsetHeight;
      
      switch (placement) {
        case 'bottom':
          break;
        case 'top':
          break;
        case 'left':
          break;
        case 'right':
        
      }
      /*
        switch (placement) {
          case 'bottom':
            tp = {top: pos.top + pos.height, left: pos.left + pos.width / 2 - actualWidth / 2}
            break
          case 'top':
            tp = {top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2}
            break
          case 'left':
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth}
            break
          case 'right':
            tp = {top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width}
            break
        }
        
        this.applyPlacement(tp, placement)
      */
    }
    
    $element.trigger('shown');
  }
  
  static String _placement(placement) {
    if (placement is String)
      return placement;
    if (placement is Function) {
      try {
        return placement();
      } catch (e) {}
    }
    return _DEF_PLACEMENT;
  }
  
  void applyPlacement(top, left, String placement) {
    /*
    var $tip = this.tip()
        , width = $tip[0].offsetWidth
        , height = $tip[0].offsetHeight
        , actualWidth
        , actualHeight
        , delta
        , replace
      
      $tip
        .offset(offset)
      */
    
    tip.classes..add('placement')..add('in');
    final int actualWidth = tip.offsetWidth;
    final int actualHeight = tip.offsetHeight;
    
    /*
      if (placement == 'top' && actualHeight != height) {
        offset.top = offset.top + height - actualHeight
        replace = true
      }
      
      if (placement == 'bottom' || placement == 'top') {
        delta = 0
        
        if (offset.left < 0){
          delta = offset.left * -2
          offset.left = 0
          $tip.offset(offset)
          actualWidth = $tip[0].offsetWidth
          actualHeight = $tip[0].offsetHeight
        }
        
        this.replaceArrow(delta - width + actualWidth, actualWidth, 'left')
      } else {
        this.replaceArrow(actualHeight - height, actualHeight, 'top')
      }
      
      if (replace) $tip.offset(offset)
    */
  }
  
  void replaceArrow(delta, dimension, position) {
    /*
    this
    .arrow()
    .css(position, delta ? (50 * (1 - delta / dimension) + "%") : '')
    */
  }
  
  void setContent() {
    /*
    var $tip = this.tip()
        , title = this.getTitle()

      $tip.find('.tooltip-inner')[this.options.html ? 'html' : 'text'](title)
    */
    tip.classes.removeAll(['fade', 'in', 'top', 'bottom', 'left', 'right']);
  }
  
  void hide() {
    final DQueryEvent e = new DQueryEvent('hide');
    $element.triggerEvent(e);
    if (e.isDefaultPrevented)
      return;
    
    tip.classes.remove('in');
    
    if (Transition.isUsed && tip.classes.contains('fade')) {
      
      ElementQuery $tip = $(tip);
      
      new Future.delayed(const Duration(milliseconds: 500), () {
        $tip.one(Transition.end);
        tip.remove();
      });
      $tip.one(Transition.end, (DQueryEvent e) {
        // TODO: clear timeout?
        tip.remove();
      });
      
    } else {
      tip.remove();
      
    }
    
    $element.trigger('hidden'); // TODO: check timing
  }
  
  void fixTitle() {
    /*
    var $e = this.$element
    if ($e.attr('title') || typeof($e.attr('data-original-title')) != 'string') {
      $e.attr('data-original-title', $e.attr('title') || '').attr('title', '')
    }
    */
  }
  
  bool get hasContent => getTitle() != null;
  
  Rect getPosition() {
    return element.offset; // TODO: check jQuery offset
    /*
    var el = this.$element[0]
    return $.extend({}, (typeof el.getBoundingClientRect == 'function') ? el.getBoundingClientRect() : {
      width: el.offsetWidth
    , height: el.offsetHeight
    }, this.$element.offset())
    */
  }
  
  String getTitle() {
    /*
    var title
    , $e = this.$element
    , o = this.options

    title = $e.attr('data-original-title')
    || (typeof o.title == 'function' ? o.title.call($e[0]) :  o.title)

    return title
    */
  }
  
  ElementQuery _$arrow;
  
  Element get tip =>
      p.fallback(_tip, () => _tip = new Element.html(template));
  Element _tip;
  
  ElementQuery _arrow() =>
      p.fallback(_$arrow, () => _$arrow = tip.find('.tooltip-arrow'));
  
  void validate() {
    if (element.parent == null) {
      hide();
      /*
      this.$element = null
      this.options = null
      */
    }
  }
  
  void enable() {
    _enabled = true;
  }
  
  void disable() {
    _enabled = false;
  }
  
  void toggleEnabled() {
    _enabled = !_enabled;
  }
  
  /*
  , toggle: function (e) {
      var self = e ? $(e.currentTarget)[this.type](this._options).data(this.type) : this
      self.tip().hasClass('in') ? self.hide() : self.show()
    }

  */
  static void _toggle(Element target) {
    
  }
  
  void destroy() {
    hide();
    $element.off(".$_type");
    //this.removeData(this.type)
  }
  
}

/*
 // TOOLTIP PLUGIN DEFINITION
 // ========================= 

  $.fn.tooltip = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('tooltip')
        , options = typeof option == 'object' && option
      if (!data) $this.data('tooltip', (data = new Tooltip(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }
*/