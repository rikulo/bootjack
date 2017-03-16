part of bootjack;

// TODO: write test case where data-spy not on body

/** A scrollspy component, which captures the scroll position on an element and
 * reflects the state on another element.
 */
class Scrollspy extends Base {
  
  static const String _NAME = 'popover';
  
  final String _selector;
  
  /** The offset used when calculating scroll position. For example, if 10,
   * the scroll position is effectively 10 + the real scroll position.
   */
  final int offset;
  
  /** Construct a Scrollspy object and wire it to [element].
   */
  Scrollspy(Element element, {String target, int offset: 10}) : 
  this.offset = offset,
  _body = document.body,
  _$body = $(document.body),
  _selector = "${target ?? element.attributes['href'] ?? ''} .nav li > a",
  super(element, _NAME) {
    _$scrollElement = element is BodyElement ? $window() : $element;
    _$scrollElement.on('scroll.scroll-spy.data-api', (QueryEvent e) => _process());
    refresh();
    _process();
  }
  
  /** Retrieve the wired Scrollspy object from an element. If there is no wired
   * Scrollspy object, a new one will be created.
   * 
   */
  static Scrollspy wire(Element element, [Scrollspy create()]) =>
      p.wire(element, _NAME, create ?? (() => new Scrollspy(element)));
  
  final ElementQuery _$body;
  final Element _body;
  DQuery _$scrollElement;
  String _activeTarget;
  
  final List<_Anchor> _anchors = new List<_Anchor>();
  static final RegExp _ANC_EXP = new RegExp(r'^#\w'); // TODO: may simplify?
  
  /** Refresh the cached y-position values of spied items.
   */
  void refresh() {
    
    _anchors.clear();
    
    for (Element e in _$body.find(_selector)) {
      final String href = p.getDataTarget(e);
      if (!_ANC_EXP.hasMatch(href))
        continue;
      
      final ElementQuery $href = $(href);
      if (!$href.isEmpty) {
        final int offset = $href.first.offsetTop + (element is BodyElement ? 0 : element.scrollTop);
        _anchors.add(new _Anchor(offset, href));
      }
    }
    
    _anchors.sort((_Anchor a, _Anchor b) => a.offset - b.offset);
    
  }
  
  void _process() {
    if (_anchors.isEmpty)
      return;
    
    final int scrollTop = _$scrollElement.scrollTop + this.offset;
    int scrollHeight = _$scrollElement is ElementQuery ? 
        element.scrollHeight : _body.scrollHeight;
    final int maxScroll = scrollHeight - _$scrollElement.height;
    final String lastTarget = _anchors.last.target;
    
    if (scrollTop >= maxScroll) {
      _activate(lastTarget);
      return;
    }
    
    _Anchor panc = null;
    for (_Anchor anc in _anchors) {
      // start with 1st and 2nd
      if (panc != null && _activeTarget != panc.target && 
          scrollTop >= panc.offset && scrollTop <= anc.offset)
        _activate(panc.target);
      panc = anc;
    }
    if (scrollTop >= _anchors.last.offset)
      _activate(lastTarget);
    
  }
  
  void _activate(String target) {
    if (_activeTarget == target)
      return;
    _activeTarget = target;
    
    $(_selector).parent('.active').removeClass('active');
    
    final String selector = '$_selector[data-target="$target"], $_selector[href="$target"]';
    
    ElementQuery $active = $(selector).parent('li');
    $active.addClass('active');
    
    if (!$active.parent('.dropdown-menu').isEmpty) {
      $active = $active.closest('li.dropdown');
      $active.addClass('active');
    }
    
    $active.trigger('activate.bs.scrollspy');
    
  }
  
  // Data API //
  static bool _registered = false;
  
  /** Register to use Scrollspy component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $window().on('load', (QueryEvent e) {
      for (Element elem in $('[data-spy="scroll"]')) {
        Scrollspy.wire(elem); // TODO: data option
        //$spy.scrollspy($spy.data())
      }
    });
  }
  
}

class _Anchor {
  
  final int offset;
  final String target;
  
  _Anchor(this.offset, this.target);
  
}

/*
 // SCROLLSPY PLUGIN DEFINITION
 // =========================== //

  $.fn.scrollspy = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('scrollspy')
        , options = typeof option == 'object' && option
      if (!data) $this.data('scrollspy', (data = new ScrollSpy(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }
*/
