part of bootjack;

// TODO: need to enable relatedTarget in show/shown event

/** A tab component.
 */
class Tab extends Base {
  
  static const _name = 'tab';
  
  /** Construct a Tab object and wire it to [element].
   */
  Tab(Element element) : 
  super(element, _name);
  
  /** Retrieve the wired Tab object from an element. If there is no wired
   * Tab object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Tab creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Tab? wire(Element element, [Tab? create()?]) =>
      p.wire(element, _name, create ?? (() => Tab(element)));
  
  /** Show the tab.
   */
  void show() {
    final $ul = $element.closest('ul:not(.dropdown-menu)'),
      selector = p.getDataTarget(element), // TODO: should cache in construction?
      $parent = $element.parent('li');
    
    if ($parent.hasClass('active'))
      return;
    
    Element? previous;
    //final Element previous = $ul.find('.active:last a').firstIfAny; // TODO: :last is jq only
    
    final e = QueryEvent('show.bs.tab', data: previous);
    
    $element.triggerEvent(e);
    
    if (e.defaultPrevented)
      return;
    
    final $target = $(selector);
    _activate($parent, $ul);
    _activate($target, $target.parent(), () {
      $element.trigger('shown.bs.tab', data: previous);
    });
    
  }
  
  void _activate(ElementQuery $elem, ElementQuery $container, [void callback()?]) {
    final $active = $container.children('.active'),
      transition = callback != null
        && Transition.isUsed && $active.hasClass('fade');
    
    final next = ([QueryEvent? e]) {
      $active.removeClass('active');
      $active.children('.dropdown-menu').children('.active').removeClass('active');
      
      $elem.addClass('active');
      
      if (transition) {
        $elem.reflow();
        $elem.addClass('in');
      } else {
        $elem.removeClass('fade');
      }
      
      if (!$elem.parent('.dropdown-menu').isEmpty)
        $elem.closest('li.dropdown').addClass('active');
      
      callback?.call();
    };
    
    if (transition)
      $active.one(Transition.end, next);
    else
      next();
    
    $active.removeClass('in');
    
  }
  
  // Data API //
  static bool _registered = false;
  
  /** Register to use Tab component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $document().on('click.tab.data-api', (QueryEvent e) {
      e.preventDefault();
      wire(e.target as Element)!.show();
      
    }, selector: '[data-toggle="tab"], [data-toggle="pill"]');
  }
  
}
