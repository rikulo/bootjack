part of bootjack;

// required jQuery features:
// classes
// traversing: find()
// event: $.Event()/one()/trigger()
// $.camelCase()
// effect!
// attr()
// data()
// on()

class Collapse extends Base {
  
  Collapse(Element element) : super(element) {
    /*
    this.options = $.extend({}, $.fn.collapse.defaults, options)

    if (this.options.parent) {
      this.$parent = $(this.options.parent)
    }

    this.options.toggle && this.toggle()
    */
  }
  
  bool get transitioning => _transitioning;
  bool _transitioning = false;
  
  String get dimension {
    /*
    var hasWidth = this.$element.hasClass('width')
    return hasWidth ? 'width' : 'height'
    */
  }
  
  void show() {
    /*
    var dimension
    , scroll
    , actives
    , hasData

    if (this.transitioning || this.$element.hasClass('in')) return

    dimension = this.dimension()
    scroll = $.camelCase(['scroll', dimension].join('-'))
    actives = this.$parent && this.$parent.find('> .accordion-group > .in')

    if (actives && actives.length) {
      hasData = actives.data('collapse')
          if (hasData && hasData.transitioning) return
              actives.collapse('hide')
              hasData || actives.data('collapse', null)
    }

    this.$element[dimension](0)
    this.transition('addClass', $.Event('show'), 'shown')
    $.support.transition && this.$element[dimension](this.$element[0][scroll])
    */
  }
  
  void hide() {
    /*
    var dimension
    if (this.transitioning || !this.$element.hasClass('in')) return
    dimension = this.dimension()
    this.reset(this.$element[dimension]())
    this.transition('removeClass', $.Event('hide'), 'hidden')
    this.$element[dimension](0)
    */
  }
  
  void reset(size) {
    /*
    var dimension = this.dimension()

    this.$element
    .removeClass('collapse')
    [dimension](size || 'auto')
    [0].offsetWidth

    this.$element[size !== null ? 'addClass' : 'removeClass']('collapse')
    */
  }
  
  void transition(method, startEvent, completeEvent) {
    /*
    var that = this
        , complete = function () {
            if (startEvent.type == 'show') that.reset()
            that.transitioning = 0
            that.$element.trigger(completeEvent)
          }

    this.$element.trigger(startEvent)

    if (startEvent.isDefaultPrevented()) return

    this.transitioning = 1

    this.$element[method]('in')

    $.support.transition && this.$element.hasClass('collapse') ?
      this.$element.one($.support.transition.end, complete) :
      complete()
    */
  }
  
  void toggle() {
    /*
    this[this.$element.hasClass('in') ? 'hide' : 'show']()
    */
  }
  
}

/*
 // COLLAPSE PLUGIN DEFINITION
 // ========================== 

  $.fn.collapse = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('collapse')
        , options = $.extend({}, $.fn.collapse.defaults, $this.data(), typeof option == 'object' && option)
      if (!data) $this.data('collapse', (data = new Collapse(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }

  $.fn.collapse.defaults = {
    toggle: true
  }

 // COLLAPSE DATA-API
 // ================= 

  $(document).on('click.collapse.data-api', '[data-toggle=collapse]', function (e) {
    var $this = $(this), href
      , target = $this.attr('data-target')
        || e.preventDefault()
        || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '') //strip for ie7
      , option = $(target).data('collapse') ? 'toggle' : $this.data()
    $this[$(target).hasClass('in') ? 'addClass' : 'removeClass']('collapsed')
    $(target).collapse(option)
  })

*/