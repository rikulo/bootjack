part of bootjack;

/**
 * 
 */
class Tooltip extends Base {
  
  static const String _NAME = 'tooltip';
  static const String _DEFAULT_TEMPLATE = 
      '<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>';
  
  /**
   * 
   */
  Tooltip(Element element, {bool animation, placement, String selector, 
  String template, String trigger, title, int delay, int showDelay, 
  int hideDelay, bool html, container}) : 
  this.animation = _bool(animation, element, 'animation',  true),
  this.placement = _data(placement, element, 'placement',  'top'),
  this.selector  = _data(selector,  element, 'selector'),
  this.template  = _data(template,  element, 'template',    _DEFAULT_TEMPLATE),
  this.trigger   = _data(trigger,   element, 'trigger',    'hover focus'),
  this._title    = _data(title,     element, 'title',      ''),
  this.showDelay = _data(showDelay, element, 'show-delay', _data(delay, element, 'delay', 0)),
  this.hideDelay = _data(hideDelay, element, 'hide-delay', _data(delay, element, 'delay', 0)),
  this.html      = _bool(html,      element, 'html',       false),
  this.container = _data(container, element, 'container'),
  super(element, _NAME) {
    
    for (String t in this.trigger.split(' ')) {
      if (t == 'click') {
        $element.on("click.$_type", (DQueryEvent event) => toggle(), selector: selector);
        
      } else if (t != 'manual') {
        final String eventIn = t == 'hover' ? 'mouseover' : 'focus';
        final String eventOut = t == 'hover' ? 'mouseout' : 'blur';
        $element.on("$eventIn.$_type", (DQueryEvent event) => _enter(), selector: selector);
        $element.on("$eventOut.$_type", (DQueryEvent event) => _leave(), selector: selector);
        
      }
    }
    
    /*
    this.options.selector ?
        (this._options = $.extend({}, this.options, { trigger: 'manual', selector: '' })) :
        this._fixTitle()
    */
    if (selector == null)
      _fixTitle();
  }
  
  /** Retrieve the wired Tooltip object from an element. If there is no wired
   * Tooltip object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Tooltip creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Tooltip wire(Element element, [Tooltip create()]) =>
      p.wire(element, _NAME, p.fallback(create, () => () => new Tooltip(element)));
  
  String get _type => _NAME;
  String get _placementDefault => 'top';
  final _title;
  
  /// Whether to have animation. Default: true.
  final bool animation;
  
  /// TODO
  final bool html;
  
  /// The placement strategy of the tooltip. Default: 'top'. TODO
  final placement;
  
  /// TODO
  final String selector;
  
  /// The html template for tooltip.
  final String template;
  
  /// The trigger condition. Default: 'hover focus'.
  final String trigger;
  
  /// The delay time in milliseconds to show the tooptip. Default: 0.
  final int showDelay;
  
  /// The delay time in milliseconds to show the tooptip. Default: 0.
  final int hideDelay;
  
  /// TODO
  final container;
  
  /// Whether the tooptip mechanism is in effect.
  bool get enabled => _enabled;
  bool _enabled = true;
  
  void _enter() {
    if (showDelay == 0) {
      show();
      return;
    }
    
    _hoverIn = true;
    final p.Token token = _timeout = new p.Token();
    
    new Future.delayed(new Duration(milliseconds: showDelay)).then((_) {
      if (token != _timeout)
        return;
      if (_hoverIn == true)
        show();
    });
  }
  
  void _leave() {
    final p.Token token = _timeout = new p.Token(); // clear timeout
    
    if (hideDelay == 0) {
      hide();
      return;
    }
    
    _hoverIn = false;
    
    new Future.delayed(new Duration(milliseconds: hideDelay)).then((_) {
      if (token != _timeout)
        return;
      if (_hoverIn == false)
        hide();
    });
  }
  
  bool _hoverIn;
  p.Token _timeout;
  
  void show() {
    if (!hasContent || !_enabled) 
      return;
    
    final DQueryEvent e = new DQueryEvent('show');
    $element.triggerEvent(e);
    if (e.isDefaultPrevented) 
      return;
    
    _setContent();
    if (animation)
      tip.classes.add('fade');
    
    final String placement = 
        p.fallback(p.resolveString(this.placement), () => _placementDefault);
    
    tip.remove();
    tip.style.top = tip.style.left = '0';
    tip.style.display = 'block';
    
    if (container != null)
      $(tip).appendTo(container);
    else
      $element.after(tip);
    
    final Rect pos = position;
    final int actualWidth = tip.offsetWidth;
    final int actualHeight = tip.offsetHeight;
    int top, left;
    
    //window.console.log("${pos.left} ${pos.width} ${tip.offsetWidth} ${pos.left.round() + ((pos.width.round() - actualWidth) / 2).floor()}");
    
    switch (placement) {
      case 'bottom':
        top = pos.top.round() + pos.height.round();
        left = pos.left.round() + ((pos.width.round() - actualWidth) / 2).floor();
        break;
      case 'top':
        top = pos.top.round() - actualHeight;
        left = pos.left.round() + ((pos.width.round() - actualWidth) / 2).floor();
        break;
      case 'left':
        top = pos.top.round() + ((pos.height.round() - actualHeight) / 2).floor();
        left = pos.left.round() - actualWidth;
        break;
      case 'right':
        top = pos.top.round() + ((pos.height - actualHeight) / 2).floor();
        left = pos.left.round() + pos.width.round();
        break;
    }
    _applyPlacement(top, left, placement);
    $element.trigger('shown');
    
  }
  
  void _applyPlacement(int top, int left, String placement) {
    final int width = tip.offsetWidth;
    final int height = tip.offsetHeight;
    bool replace = false;
    
    _offset(top, left);
    
    tip.classes..add(placement)..add('in');
    int actualWidth = tip.offsetWidth;
    int actualHeight = tip.offsetHeight;
    
    if (placement == 'top' && actualHeight != height) {
      top += height - actualHeight;
      replace = true;
    }
    
    if (placement == 'bottom' || placement == 'top') {
      int delta = 0;
      if (left < 0) {
        delta = left * -2;
        left = 0;
        _offset(top, left);
        actualWidth = tip.offsetWidth;
        actualHeight = tip.offsetHeight;
      }
      arrow.style.left = _ratioValue(delta - width + actualWidth, actualWidth);
      
    } else {
      arrow.style.top = _ratioValue(actualHeight - height, actualHeight);
      
    }
    
    if (replace)
      _offset(top, left);
  }
  
  void _offset(int top, int left) {
    $(tip).offset = new Point(left, top);
  }
  
  String _ratioValue(num delta, num dimension) =>
      delta == 0 ? "${50 * (1 - delta / dimension)}%" : '';
  
  void _setContent() {
    _cnt(tip.query('.tooltip-inner'), title);
    tip.classes.removeAll(['fade', 'in', 'top', 'bottom', 'left', 'right']);
  }
  
  void _cnt(Element elem, String value) {
    if (elem != null) {
      if (html)
        elem.innerHtml = value;
      else
        $(elem).text = value;
    }
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
        $tip.off(Transition.end);
        if (tip.parent != null)
          tip.remove();
      });
      $tip.one(Transition.end, (DQueryEvent e) {
        if (tip.parent != null)
          tip.remove();
      });
      
    } else {
      tip.remove();
      
    }
    
    $element.trigger('hidden'); // TODO: check timing
  }
  
  void _fixTitle() {
    final String title = element.attributes['title'];
    if (title != null && !title.isEmpty) {
      element.attributes['data-original-title'] = title;
      element.attributes['title'] = '';
    }
  }
  
  bool get hasContent => title != null;
  
  Rect get position {
    return element.getBoundingClientRect(); // TODO: check fallback scenario
    /*
    var el = this.$element[0]
    return $.extend({}, (typeof el.getBoundingClientRect == 'function') ? el.getBoundingClientRect() : {
      width: el.offsetWidth
    , height: el.offsetHeight
    }, this.$element.offset())
    */
  }
  
  String get title =>
      p.fallback(element.attributes['data-original-title'], 
          () => p.resolveString(_title, element));
  
  Element get tip =>
      p.fallback(_tip, () => _tip = new Element.html(template));
  Element _tip;
  
  Element get arrow =>
      p.fallback(_arrow, () => _arrow = tip.query('.tooltip-arrow'));
  Element _arrow;
  
  /// Enable tooptip.
  void enable() {
    _enabled = true;
  }
  
  /// Disable tooptip.
  void disable() {
    _enabled = false;
  }
  
  /// Toggle enable/disable state.
  void toggleEnabled() {
    _enabled = !_enabled;
  }
  
  /// Toggle visibility of tooltip.
  void toggle() => tip.classes.contains('in') ? hide() : show();
  
  /// Destroy the component.
  void destroy() {
    hide();
    $element.off(".${_type}");
    $element.data.remove(_type);
  }
  
}

_data(value, Element elem, String name, [defaultValue]) =>
    p.fallback(value, () => 
    p.fallback(elem.attributes["data-$name"], () => defaultValue));

_bool(bool value, Element elem, String name, [bool defaultValue]) {
  if (value != null)
    return value;
  final String v = elem.attributes["data-$name"];
  return v == 'true' ? true : v == 'false' ? false : defaultValue;
}


