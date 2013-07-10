part of bootjack;

/**
 * 
 */
class Popover extends Tooltip {
  
  static const String _NAME = 'popover';
  static const String _DEFAULT_TEMPLATE = 
      '<div class="popover"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>';
  
  /**
   * 
   */
  Popover(Element element, {bool animation, placement, String selector, 
  String template, String trigger, title, content, int delay, int showDelay, 
  int hideDelay, bool html, container}) : 
  this._content  = _data(content,   element, 'content'),
  this.placement = _data(placement, element, 'placement', 'right'),
  this.template  = _data(template,  element, 'template',   _DEFAULT_TEMPLATE),
  this.trigger   = _data(trigger,   element, 'trigger',   'click'),
  super(element, animation: animation, selector: selector, title: title, 
  delay: delay, showDelay: showDelay, hideDelay: hideDelay, html: html, 
  container: container);
  
  /** Retrieve the wired Popover object from an element. If there is no wired
   * Popover object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Popover creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Popover wire(Element element, [Popover create()]) =>
      p.wire(element, _NAME, p.fallback(create, () => () => new Popover(element)));
  
  @override
  String get _type => _NAME;
  
  @override
  String get _placementDefault => 'right';
  
  @override
  Element get arrow =>
      p.fallback(_arrow, () => _arrow = tip.query('.arrow'));
  Element _arrow;
  
  
  
  final _content;
  
  /// The placement strategy of the popover. Default: 'right'. TODO
  final placement;
  
  /// The html template for popover.
  final String template;
  
  /// The trigger condition. Default: 'click'.
  final String trigger;
  
  ///
  String get content =>
      p.fallback(p.resolveString(_content, element), 
          () => element.attributes['data-content']);
  
  @override
  bool get hasContent => title != null || content != null;
  
  @override
  void _setContent() {
    _cnt(tip.query('.popover-title'), title);
    _cnt(tip.query('.popover-content'), content);
    tip.classes.removeAll(['fade', 'top', 'bottom', 'left', 'right', 'in']);
  }
  
}


