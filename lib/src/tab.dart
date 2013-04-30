part of bootjack;

// TODO: need to enable relatedTarget in show/shown event

/**
 * 
 */
class Tab extends Base {
  
  static const String _NAME = 'tab';
  
  /**
   * 
   */
  Tab(Element element) : 
  super(element, _NAME);
  
  /**
   * 
   */
  static Tab wire(Element element) =>
      _wire(element, _NAME, () => new Tab(element));
  
  /**
   * 
   */
  void show() {
    final ElementQuery $ul = $element.closest('ul:not(.dropdown-menu)');
    final String selector = _dataTarget(element); // TODO: should cache in construction?
    final ElementQuery $parent = $element.parent('li');
    
    if ($parent.hasClass('active'))
      return;
    
    //final Element previous = $ul.find('.active:last a').firstIfAny; // TODO: :last is jq only
    
    final DQueryEvent e = 
        new DQueryEvent('show'/*, data: { 'relatedTarget': previous }*/);
    
    $element.triggerEvent(e);
    
    if (e.isDefaultPrevented) 
      return;
    
    final ElementQuery $target = $(selector);
    _activate($parent, $ul);
    _activate($target, $target.parent(), () {
      $element.trigger('shown'/*, data: { 'relatedTarget': previous }*/);
    });
    
  }
  
  void _activate(ElementQuery $elem, ElementQuery $container, [void callback()]) {
    final $active = $container.children('.active');
    final bool transition = callback != null && 
        Transition.isUsed && 
        $active.hasClass('fade');
    
    final Function next = ([DQueryEvent e]) {
      $active.removeClass('active');
      $active.children('.dropdown-menu').children('.active').removeClass('active');
      
      $elem.addClass('active');
      
      if (transition) {
        if (!$elem.isEmpty)
          $elem.first.offsetWidth; // reflow for transition
        $elem.addClass('in');
      } else {
        $elem.removeClass('fade');
      }
      
      if (!$elem.parent('.dropdown-menu').isEmpty)
        $elem.closest('li.dropdown').addClass('active');
      
      if (callback != null)
        callback();
      
    };
    
    if (transition)
      $active.one(Transition.end, next);
    else
      next();
    
    $active.removeClass('in');
    
  }
  
  // Data API //
  static bool _registered = false;
  
  static void _register() {
    if (_registered) return;
    _registered = true;
    
    $document().on('click.tab.data-api', (DQueryEvent e) {
      e.preventDefault();
      wire(e.target).show();
      
    }, selector: '[data-toggle="tab"], [data-toggle="pill"]');
  }
  
}
