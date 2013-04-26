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
  
  String get selector => _selector;
  String _selector;
  
  final int offset;
  
  Scrollspy(Element element, {String target, int offset : 10}) : 
  this.offset = offset, 
  super(element, _NAME) {
    DQuery $observed = element is BodyElement ? $window() : $element;
    
    /*
    var process = $.proxy(this.process, this)
    this.$scrollElement = $element.on('scroll.scroll-spy.data-api', process)
    */
    
    _selector = "${_fallback(target, () => element.attributes['href'], () => '')} .nav li > a";
    refresh();
    process();
  }
  
  void refresh() {
    /*
    var self = this
        , $targets

    this.offsets = $([])
    this.targets = $([])

    $targets = this.$body
    .find(this.selector)
    .map(function () {
      var $el = $(this)
          , href = $el.data('target') || $el.attr('href')
          , $href = /^#\w/.test(href) && $(href)
          return ( $href
              && $href.length
              && [[ $href.position().top + (!$.isWindow(self.$scrollElement.get(0)) && self.$scrollElement.scrollTop()), href ]] ) || null
          })
          .sort(function (a, b) { return a[0] - b[0] })
          .each(function () {
            self.offsets.push(this[0])
            self.targets.push(this[1])
          })
    */
  }
  
  void process() {
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
  
  void activate(target) {
    /*
    var active
    , selector

    this.activeTarget = target

    $(this.selector)
    .parent('.active')
    .removeClass('active')

    selector = this.selector
    + '[data-target="' + target + '"],'
    + this.selector + '[href="' + target + '"]'
    
    active = $(selector)
    .parent('li')
    .addClass('active')

    if (active.parent('.dropdown-menu').length)  {
      active = active.closest('li.dropdown').addClass('active')
    }

    active.trigger('activate')
    */
  }
  
  static void register() {
    $window().on('load', (DQueryEvent e) {
      for (Element elem in $('[data-spy="scroll"]')) {
        /*
        var $spy = $(this)
            $spy.scrollspy($spy.data())
        */
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
