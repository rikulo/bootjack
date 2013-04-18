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
  
  Carousel(Element element) : super(element) {
    /*
    this.$indicators = this.$element.find('.carousel-indicators')
    this.options = options
    this.options.pause == 'hover' && this.$element
      .on('mouseenter', $.proxy(this.pause, this))
      .on('mouseleave', $.proxy(this.cycle, this))
    */
  }
  
  bool get sliding => _sliding;
  bool _sliding = false;
  
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
  
  int getActiveIndex() {
    /*
    this.$active = this.$element.find('.item.active')
    this.$items = this.$active.parent().children()
    return this.$items.index(this.$active)
    */
  }
  
  void to(int pos) {
    /*
    var activeIndex = this.getActiveIndex()
        , that = this

    if (pos > (this.$items.length - 1) || pos < 0) return

    if (this.sliding) {
      return this.$element.one('slid', function () {
        that.to(pos)
      })
    }

    if (activeIndex == pos) {
      this.pause().cycle()
    }

    this.slide(pos > activeIndex ? 'next' : 'prev', $(this.$items[pos]))
    */
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

  $.fn.carousel.defaults = {
    interval: 5000
  , pause: 'hover'
  }

 // CAROUSEL DATA-API
 // ================= 

  $(document).on('click.carousel.data-api', '[data-slide], [data-slide-to]', function (e) {
    var $this = $(this), href
      , $target = $($this.attr('data-target') || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '')) //strip for ie7
      , options = $.extend({}, $target.data(), $this.data())
      , slideIndex

    $target.carousel(options)

    if (slideIndex = $this.attr('data-slide-to')) {
      $target.data('carousel').pause().to(slideIndex).cycle()
    }

    e.preventDefault()
  })

*/