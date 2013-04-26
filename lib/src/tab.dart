part of bootjack;

// required jQuery features:
// event data

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
    final ElementQuery $ul = $element.closest(selector: 'ul:not(.dropdown-menu)');
    final String selector = _dataTarget(element); // TODO: should cache in construction?
    final ElementQuery $parent = $element.parent('li');
    
    if (!$parent.isEmpty && $parent.first.classes.contains('active'))
      return;
    
    final Element previous = $ul.find('.active:last a').firstIfAny;
    
    DQueryEvent e = new DQueryEvent('show'); // TODO: data
    //e = $.Event('show', { relatedTarget: previous })
    
    $element.trigger(e);
    
    if (e.isDefaultPrevented) 
      return;
    
    final ElementQuery $target = $(selector);
    _activate($parent, $ul);
    _activate($target, $target.parent(), () {
      $element.trigger('shown', {
        'relatedTarget': previous
      });
    });
    
  }
  
  void _activate(ElementQuery $elem, ElementQuery $container, [void callback()]) {
    
    final $active = $container.find('> .active');
    final bool transition = callback != null && 
        Transition.isUsed && 
        $active.any((Element e) => e.classes.contains('fade'));
    final Element elem = $elem.firstIfAny;
    
    final Function next = () {
      $active.forEach((Element e) => e.classes.remove('active'));
      $active.find('> .dropdown-menu > .active')
      .forEach((Element e) => e.classes.remove('active'));
      
      elem.classes.add('active');
      
      if (transition) {
        elem.offsetWidth; // reflow for transition
        elem.classes.add('in');
      } else {
        elem.classes.remove('fade');
      }
      
      if (!$elem.parent('.dropdown-menu').isEmpty) {
        ElementQuery $c = $elem.closest('li.dropdown');
        if (!$c.isEmpty)
          $c.first.classes.add('active');
      }
      
      if (callback != null)
        callback();
      
    };
    
    if (transition)
      $active.one(Transition.end, (DQueryEvent e) => next());
    else
      next();
    
    $active.forEach((Element e) => e.classes.remove('in'));
    
  }
  
  static void _register() {
    $document().on('click.tab.data-api', (DQueryEvent e) {
      e.preventDefault();
      wire(e.target).show();
      
    }, selector: '[data-toggle="tab"], [data-toggle="pill"]');
  }
  
}
