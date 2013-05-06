part of bootjack;

// required jQuery features:
// classes
// traversing: find()/closest()/parent()
// dimension: scrollTop()
// map()/sort()/each()
// attr()
// data()
// on()

class Scrollspy extends Base {
  
  static const String _NAME = 'popover';
  
  final String _selector;
  
  /**
   * 
   */
  final int offset;
  
  /**
   * 
   */
  Scrollspy(Element element, {String target, int offset : 10}) : 
  this.offset = offset,
  _$body = $('body'),
  _selector = "${_fallback(target, () => _fallback(element.attributes['href'], () => ''))} .nav li > a",
  super(element, _NAME) {
    _$scrollElement = element is BodyElement ? $window() : $element;
    _$scrollElement.on('scroll.scroll-spy.data-api', (DQueryEvent e) => _process());
    refresh();
    _process();
  }
  
  /**
   * 
   */
  static Scrollspy wire(Element element, [Scrollspy create()]) =>
      _wire(element, _NAME, _fallback(create, () => () => new Scrollspy(element)));
  
  final ElementQuery _$body;
  DQuery _$scrollElement;
  Element _activeTarget;
  
  // TODO: may want to group them?
  final List<int> _offsets = new List<int>();
  final List<Element> _targets = new List<Element>();
  
  /**
   * 
   */
  void refresh() {
    
    _offsets.clear();
    _targets.clear();
    
    _$body.find(_selector).map((Element e) {
      /*
      var $el = $(this)
          , href = $el.data('target') || $el.attr('href')
          , $href = /^#\w/.test(href) && $(href)
          return ( $href
              && $href.length
              && [[ $href.position().top + (!$.isWindow(self.$scrollElement.get(0)) && self.$scrollElement.scrollTop()), href ]] ) || null
          })
      */
    }).toList().sort((a, b) => a[0] - b[0]).forEach((t) {
      _offsets.add(t[0]);
      _targets.add(t[1]);
    });
    
  }
  
  void _process() {
    /*
    var scrollTop = this.$scrollElement.scrollTop() + this.options.offset
        , scrollHeight = this.$scrollElement[0].scrollHeight || this.$body[0].scrollHeight
        , maxScroll = scrollHeight - this.$scrollElement.height()
        , offsets = this.offsets
        , targets = this.targets
        , activeTarget = this.activeTarget
        , i

    if (scrollTop >= maxScroll) {
      return activeTarget != (i = targets.last()[0])
          && this.activate ( i )
    }

    for (i = offsets.length; i--;) {
      activeTarget != targets[i]
      && scrollTop >= offsets[i]
      && (!offsets[i + 1] || scrollTop <= offsets[i + 1])
      && this.activate( targets[i] )
    }
    */
  }
  
  void _activate(Element target) {
    
    _activeTarget = target;
    
    $(_selector).parent('.active').removeClass('active');
    
    // TODO: wouldn't toString() be too aggressive?
    final String selector = '$_selector[data-target="$target"], $_selector[href="$target"]';
    
    ElementQuery $active = $(selector).parent('li');
    $active.addClass('active');
    
    if (!$active.parent('.dropdown-menu').isEmpty) {
      $active = $active.closest('li.dropdown');
      $active.addClass('active');
    }
    
    $active.trigger('activate');
    
  }
  
  // Data API //
  static bool _registered = false;
  
  /** Register to use Scrollspy component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $window().on('load', (DQueryEvent e) {
      for (Element elem in $('[data-spy="scroll"]')) {
        Scrollspy.wire(elem); // TODO: data option
        //$spy.scrollspy($spy.data())
      }
    });
  }
  
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
