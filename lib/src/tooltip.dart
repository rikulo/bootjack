part of bootjack;

/** A tooltip component, which shows a tip message around target component when
 * triggered.
 */
class Tooltip extends Base {
  
  static const _name = 'tooltip';
  static const _defaultTemplate =
      '<div class="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>';
  final NodeValidatorBuilder? _htmlValidator;
  
  /** Construct a tooltip component and wire it to [element].
   * 
   * + If [animation] is true, the show/hide action will be animated. Default: true.
   * + [placement] function determines where to put the tooltip. Accepted output
   * are 'top', 'bottom', 'left', 'right'. Default: a function which returns the
   * attribute 'data-placement' on the [element], or 'top' if absent.
   * + [selector] determines on which descendants the tooltip can be triggered.
   * If absent, the tooltip is triggered by the events on the [element] itself.
   * + [template] determines the DOM structure of tooltip.
   * + [trigger] determines the conditions which triggers the tooltip, separated 
   * by whitespace. Accepted values are 'click', 'hover', 'focus', 'manual'.
   * Default value is 'hover focus'.
   * + If the 'title' attribute is absent on the [element], [title] function 
   * determines the message shown in tooltip.
   * + [delay] value determines the delay time when showing/hiding tooltip, in 
   * milliseconds. You can specify [showDelay] and [hideDelay] to configurate
   * the delay time separately. Default: 0. Delay time only apply to 'hover' and
   * 'focus' trigger type.
   * + If [html] is false, the component will html-escape the [title] when 
   * rendering.
   * + If [container] is given, the tooltip Element will be inserted as a child
   * of it. The value must be either a selector String, an Element, or an 
   * [ElementQuery] object. If absent, the tooltip Element will be inserted
   * after the [element].
   */
  Tooltip(Element element, {bool? animation, String? placement(Element elem)?,
    String? selector, String? template, String? trigger, String? title(Element elem)?,
    int? delay, int? showDelay, int? hideDelay, bool? html, container,
    NodeValidatorBuilder? htmlValidator,
    String defaultTemplate: _defaultTemplate,
    String defaultTrigger: 'hover focus'}) :
  this.animation  = _bool(animation, element, 'animation', true)!,
  this.html       = _bool(html,      element, 'html',      false)!,
  this.showDelay  = _int(showDelay, element, 'show-delay', _int(delay, element, 'delay', 0)!)!,
  this.hideDelay  = _int(hideDelay, element, 'hide-delay', _int(delay, element, 'delay', 0)!)!,
  this.selector   = _data(selector,  element, 'selector'),
  this.template   = _data(template,  element, 'template', defaultTemplate),
  this.trigger    = _data(trigger,   element, 'trigger',  defaultTrigger),
  this.container  = _data(container, element, 'container'),
  this._title     = title ?? ((Element elem) => elem.dataset['title']),
  this._placement = placement ?? ((Element elem) => elem.dataset['placement']),
  this._htmlValidator = htmlValidator,
  super(element, _name) {
    
    for (final t in this.trigger.split(' ')) {
      if (t == 'click') {
        $element.on("click.$_type", (QueryEvent event) => toggle(), selector: selector);
        
      } else if (t != 'manual') {
        final eventIn = t == 'hover' ? 'mouseenter' : 'focus',
          eventOut = t == 'hover' ? 'mouseleave' : 'blur';
        $element.on("$eventIn.$_type", (QueryEvent event) => _enter(), selector: selector);
        $element.on("$eventOut.$_type", (QueryEvent event) => _leave(), selector: selector);
        
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
  static Tooltip wire(Element element, [Tooltip create()?]) =>
      p.wire(element, _name, create ?? (() => Tooltip(element)));
  
  String get _type => _name;
  String get _placementDefault => 'top';
  String get _titleDefault => '';
  final _ToString _placement, _title;
  
  /// Whether to have animation. Default: true.
  final bool animation;
  
  /** Whether the tooplip content is HTML. If [false], the content will be
   * html-escaped. Default: false.
   */
  final bool html;
  
  /** The selector to locate descendant Elements which would trigger the tooltip.
   * If absent, the tooltip will be triggered by the base Element of this component.
   */
  final String? selector;
  
  /// The html template for tooltip.
  final String template;
  
  /** The trigger conditions, as event names separated by whitespace. 
   * Default: 'hover focus'.
   */
  final String trigger;
  
  /// The delay time in milliseconds to show the tooptip. Default: 0.
  final int showDelay;
  
  /// The delay time in milliseconds to show the tooptip. Default: 0.
  final int hideDelay;
  
  /** The container of tooltip Element. Accepted variable forms are selector
   * String, Element, or [ElementQuery] object.
   */
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
    final token = _timeout = p.Token();
    
    Timer(Duration(milliseconds: showDelay), () {
      if (token != _timeout)
        return;
      if (_hoverIn == true)
        show();
    });
  }
  
  void _leave() {
    final token = _timeout = p.Token(); // clear timeout
    
    if (hideDelay == 0) {
      hide();
      return;
    }
    
    _hoverIn = false;
    
    Timer(Duration(milliseconds: hideDelay), () {
      if (token != _timeout)
        return;
      if (_hoverIn == false)
        hide();
    });
  }
  
  bool? _hoverIn;
  p.Token? _timeout;
  
  /** Show the tooltip.
   */
  void show() {
    if (!hasContent || !_enabled) 
      return;
    
    final e = QueryEvent('show.bs.$_type');
    $element.triggerEvent(e);
    if (e.defaultPrevented)
      return;
    
    _setContent();
    if (animation)
      tip.classes.add('fade');
    
    final placement = _placement(element) ?? _placementDefault;
    
    tip.remove();
    tip.style.top = tip.style.left = '0';
    tip.style.display = 'block';
    
    if (container != null)
      $(tip).appendTo(container);
    else
      $element.after(tip);

    //set placement before check tip width/height
    tip.classes.addAll([placement, 'in']);

    final pos = _position,
      actualWidth = tip.offsetWidth,
      actualHeight = tip.offsetHeight;
    int? top, left;
    
    switch (placement) {
      case 'bottom':
        top = pos.bottom.round();
        left = (pos.left + (pos.width - actualWidth) / 2).round();
        break;
      case 'top':
        top = pos.top.round() - actualHeight;
        left = (pos.left + (pos.width - actualWidth) / 2).round();
        break;
      case 'left':
        top = (pos.top + (pos.height - actualHeight) / 2).round();
        left = pos.left.round() - actualWidth;
        break;
      case 'right':
        top = (pos.top + (pos.height - actualHeight) / 2).round();
        left = pos.right.round();
        break;
    }
    _applyPlacement(top!, left!, placement);
    $element.trigger('shown.bs.$_type');
  }
  
  void _applyPlacement(int top, int left, String placement) {
    final width = tip.offsetWidth,
      height = tip.offsetHeight;

    var replace = false;
    
    _offset(top, left);
    

    var actualWidth = tip.offsetWidth,
      actualHeight = tip.offsetHeight;
    
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
      _arrow.style.left = _ratioValue(delta - width + actualWidth, actualWidth);
      
    } else {
      _arrow.style.top = _ratioValue(actualHeight - height, actualHeight);
      
    }
    
    if (replace)
      _offset(top, left);
  }
  
  void _offset(int top, int left) {
    $(tip).offset = Point(left, top);
  }
  
  String _ratioValue(num delta, num dimension) =>
      delta != 0 ? "${50 * (1 - delta / dimension)}%" : '';
  
  void _setContent() {
    _cnt(tip.querySelector('.tooltip-inner'), title!);
    tip.classes.removeAll(const <String>['fade', 'in', 'top', 'bottom', 'left', 'right']);
  }
  
  void _cnt(Element? elem, String value) {
    if (elem != null) {
      if (html)
        elem.setInnerHtml(value, validator: _htmlValidator);
      else
        $(elem).text = value;
    }
  }
  
  /** Hide the tooltip.
   */
  void hide() {
    final e = QueryEvent('hide.bs.$_type');
    $element.triggerEvent(e);
    if (e.defaultPrevented)
      return;
    
    tip.classes.remove('in');
    
    if (Transition.isUsed && tip.classes.contains('fade')) {
      final $tip = $(tip);
      
      Timer(const Duration(milliseconds: 500), () {
        $tip.off(Transition.end);
        if (tip.parent != null)
          tip.remove();
      });
      $tip.one(Transition.end, (QueryEvent e) {
        if (tip.parent != null)
          tip.remove();
      });
      
    } else {
      tip.remove();
      
    }
    
    $element.trigger('hidden.bs.$_type'); // TODO: check timing
  }
  
  void _fixTitle() {
    final title = element.attributes['title'];
    if (title != null && !title.isEmpty) {
      element.attributes['data-original-title'] = title;
      element.attributes['title'] = '';
    }
  }
  
  /// Whether the tooltip message is non-empty.
  bool get hasContent => title != null;
  
  Rectangle get _position {
    final pt = this.$element.offset,
      r = element.getBoundingClientRect();

    return Rectangle(pt?.x ?? r.left, pt?.y ?? r.top, r.width, r.height);
    /*
    var el = this.$element[0]
    return $.extend({}, (typeof el.getBoundingClientRect == 'function') ? el.getBoundingClientRect() : {
      width: el.offsetWidth
    , height: el.offsetHeight
    }, this.$element.offset())
    */
  }
  
  /// The message to show in tooltip.
  String? get title =>
      element.attributes['data-original-title'] ?? _title(element) ?? _titleDefault;
  
  /// The tooltip Element.
  Element get tip =>
      _tip ??= Element.html(template, treeSanitizer: NodeTreeSanitizer.trusted);
  Element? _tip;
  
  Element get _arrow => _arr ??= tip.querySelector('.tooltip-arrow')!;
  Element? _arr;
  
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
  void toggle() {
    if (tip.classes.contains('in')) hide();
    else show();
  }
  
  /// Destroy the component.
  void destroy() {
    hide();
    $element.off(".${_type}");
    $element.data.remove(_type);
  }
  
}

typedef String? _ToString(Element elem);

_data(value, Element elem, String name, [defaultValue]) =>
    value ?? elem.dataset[name] ?? defaultValue;

int? _int(int? value, Element elem, String name, [int? defaultValue]) {
  return value ?? int.tryParse(elem.dataset[name] ?? '') ?? defaultValue;
}

bool? _bool(bool? value, Element elem, String name, [bool? defaultValue]) {
  if (value != null)
    return value;
  final v = elem.dataset[name];
  return v == 'true' ? true : v == 'false' ? false : defaultValue;
}


