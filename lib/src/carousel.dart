part of bootjack;

// required jQuery features:
// classes
// traversing: find()/parent()/children()
// event: $.Event()/one()/trigger()
// $.support.transition
// index()
// data()
// on()

class Carousel extends Base {
  
  static const String _NAME = 'carousel';
  
  /// 
  final int interval;
  
  /** The condition to pause the sliding
   */
  final String pauseCondition;
  
  Carousel(Element element, {int interval: 5000, String pause: 'hover'}) :
  this.interval = interval,
  this.pauseCondition = pause,
  super(element, _NAME) {
    /*
    this.$indicators = this.$element.find('.carousel-indicators')
    this.options = options
    this.options.pause == 'hover' && this.$element
      .on('mouseenter', $.proxy(this.pause, this))
      .on('mouseleave', $.proxy(this.cycle, this))
    */
  }
  
  
  /** Return true if the Carousel is currently sliding.
   */
  bool get sliding => _sliding;
  bool _sliding = false;
  
  /** Return true if the Carousel sliding is currently paused.
   */
  bool get paused => _paused;
  bool _paused = false;
  
  void cycle([e]) {
    /*
    if (!e) this.paused = false
    if (this.interval) clearInterval(this.interval);
    this.options.interval
    && !this.paused
    && (this.interval = setInterval($.proxy(this.next, this), this.options.interval))
    */
  }
  
  ElementQuery _$active, _$items;
  
  int getActiveIndex() {
    _$active = $element.find('.item.active');
    _$items = _$active.parent().children();
    /*
    return this.$items.index(this.$active)
    */
  }
  
  void to(int pos) {
    int activeIndex = this.getActiveIndex();
    
    if (pos > (_$items.length - 1) || pos < 0)
      return;
    
    if (_sliding) {
      $element.one('slid', (DQueryEvent e) {
        to(pos);
      });
    }
    
    if (activeIndex == pos) {
      pause();
      cycle();
    }
    
    slide(pos > activeIndex ? 'next' : 'prev', $(_$items[pos]));
    
  }
  
  void pause([e]) {
    /*
    if (!e) this.paused = true
    if (this.$element.find('.next, .prev').length && $.support.transition.end) {
      this.$element.trigger($.support.transition.end)
      this.cycle(true)
    }
    clearInterval(this.interval)
    this.interval = null
    */
  }
  
  void next() {
    if (!sliding)
      slide('next');
  }
  
  void prev() {
    if (!sliding)
      slide('prev');
  }
  
  void slide(String type, [next]) {
    /*
    var $active = this.$element.find('.item.active')
        , $next = next || $active[type]()
        , isCycling = this.interval
        , direction = type == 'next' ? 'left' : 'right'
        , fallback  = type == 'next' ? 'first' : 'last'
        , that = this
        , e

    this.sliding = true

    isCycling && this.pause()

    $next = $next.length ? $next : this.$element.find('.item')[fallback]()

    e = $.Event('slide', {
      relatedTarget: $next[0]
    , direction: direction
    })

    if ($next.hasClass('active')) return

    if (this.$indicators.length) {
      this.$indicators.find('.active').removeClass('active')
      this.$element.one('slid', function () {
        var $nextIndicator = $(that.$indicators.children()[that.getActiveIndex()])
        $nextIndicator && $nextIndicator.addClass('active')
      })
    }

    if ($.support.transition && this.$element.hasClass('slide')) {
      this.$element.trigger(e)
      if (e.isDefaultPrevented()) return
      $next.addClass(type)
      $next[0].offsetWidth // force reflow
      $active.addClass(direction)
      $next.addClass(direction)
      this.$element.one($.support.transition.end, function () {
        $next.removeClass([type, direction].join(' ')).addClass('active')
        $active.removeClass(['active', direction].join(' '))
        that.sliding = false
        setTimeout(function () { that.$element.trigger('slid') }, 0)
      })
    } else {
      this.$element.trigger(e)
      if (e.isDefaultPrevented()) return
      $active.removeClass('active')
      $next.addClass('active')
      this.sliding = false
      this.$element.trigger('slid')
    }

    isCycling && this.cycle()
    */
  }
  
  // Data API //
  static bool _registered = false;
  
  /** Register to use Carousel component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    /*
    $document().on('click.carousel.data-api', '[data-slide], [data-slide-to]', (DQueryEvent e) {
      Element elem = e.target as Element;
      ElementQuery $target = $(_dataTarget(elem));
      
      if (!$target.isEmpty) {
        Element target = $target.first;
        
        // , options = $.extend({}, $target.data(), $this.data())
        Carousel c = Carousel.wire(target); // TODO options
        
        var slideIndex = elem.attributes['data-slide-to'];
        if (slideIndex != 0) {
          c.pause();
          c.to(slideIndex);
          c.cycle();
        }
      }
      
      e.preventDefault();
      
    });
    */
  }
  
}

/*
 // CAROUSEL PLUGIN DEFINITION
 // ========================== 

  $.fn.carousel = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('carousel')
        , options = $.extend({}, $.fn.carousel.defaults, typeof option == 'object' && option)
        , action = typeof option == 'string' ? option : options.slide
      if (!data) $this.data('carousel', (data = new Carousel(this, options)))
      if (typeof option == 'number') data.to(option)
      else if (action) data[action]()
      else if (options.interval) data.pause().cycle()
    })
  }

*/