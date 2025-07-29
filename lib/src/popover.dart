part of bootjack;

/** A pop up component bound to the given Element.
 */
class Popover extends Tooltip {
  
  static const _name = 'popover';
  static const _defalutTemplate =
      '<div class="popover"><div class="arrow"></div><h3 class="popover-title"></h3><div class="popover-content"></div></div>';
  
  /** Construct a Popover component and wire it to [element].. See [Tooltip] 
   * for definitions of most parameters. The differences compared to tooltip
   * are:
   * 
   * + The default [placement] is 'right'.
   * + The [defaultTrigger] is 'click'.
   * + In addition to [title], which is rendered in popover header, you can also 
   * specify [content], to be rendered in popover body. The [html] flag applies
   * to both of them.
   */
  Popover(Element element, {bool? animation, String? placement(Element elem)?,
    String? selector, String? template, String? trigger, String? title(Element elem)?,
    String? content(Element elem)?, int? delay, int? showDelay,
    int? hideDelay, bool? html, container, bool? trustedHtml,
    String defaultTemplate = _defalutTemplate,
    String defaultTrigger = 'click'}) :
    this._content = content ?? ((Element elem) => elem.getAttribute('data-content')),
  super(element, animation: animation, placement: placement, selector: selector, 
    title: title, delay: delay, showDelay: showDelay, hideDelay: hideDelay,
    html: html, container: container,
    template: template, trigger: trigger,
    defaultTemplate: defaultTemplate, defaultTrigger: defaultTrigger);
  
  /** Retrieve the wired Popover object from an element. If there is no wired
   * Popover object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Popover creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Popover? wire(Element element, [Popover? create()?]) =>
      p.wire(element, _name, create ?? (() => Popover(element)));
  
  @override
  String get _type => _name;
  
  @override
  String get _placementDefault => 'right';
  
  @override
  HTMLElement get _arrow => _arr ??= tip.querySelector('.arrow') as HTMLElement;
  
  /// The content message of the popover.
  String? get content => _content(element)
      ?? element.getAttribute('data-content') ?? _contentDefault;
  
  String get _contentDefault => '';
  final _ToString _content;
  
  @override
  bool get hasContent => title != null || content != null;
  
  @override
  void _setContent() {
    _cnt(tip.querySelector('.popover-title'), title!);
    _cnt(tip.querySelector('.popover-content'), content!);
    _removeClasses(tip, const {'fade', 'top', 'bottom', 'left', 'right', 'in'});
  }
  
}


