part of bootjack;

/** 
 */
class Carousel extends Base {
  
  static const _name = 'carousel';
  
  /// The time interval between sliding.
  final int interval;
  
  /** The condition to pause the sliding.
   */
  final String pauseCondition;
  
  Carousel(Element element, {int interval: 5000, String pause: 'hover'}) :
  this.interval = interval,
  this.pauseCondition = pause,
  super(element, _name) {
    _indicators = element.querySelector('.carousel-indicators');
    if (pause == 'hover') {
      $element
      ..on('mouseenter', (QueryEvent e) => _pause())
      ..on('mouseleave', (QueryEvent e) => _cycle());
    }
  }
  
  Element? _indicators;
  
  /** Return true if the Carousel is currently sliding.
   */
  bool get sliding => _sliding;
  bool _sliding = false;
  
  /** Return true if the Carousel sliding is currently paused.
   */
  bool get paused => _paused;
  bool _paused = false;
  
  Element? get active => element.querySelector('.item.active');
  ElementQuery? _$items;
  
  int get activeIndex {
    final a = active;
    _$items = $(a?.parent).children();
    return a != null ? _$items!.indexOf(a): -1;
  }
  
  void to(int pos) {
    final index = activeIndex,
      $items = _$items;;
    if (pos > (_$items!.length - 1) || pos < 0 || $items == null)
      return;
    
    if (_sliding) {
      $element.one('slid', (QueryEvent e) {
        to(pos);
      });
    }
    
    if (index == pos) {
      pause();
      cycle();
    }
    
    slide(pos > index ? 'next' : 'prev', $items[pos]);
  }
  
  void cycle() {
    _paused = false;
    _cycle();
  }
  
  void _cycle() {
    /*
    if (this.interval) clearInterval(this.interval);
    this.options.interval
    && !this.paused
    && (this.interval = setInterval($.proxy(this.next, this), this.options.interval))
    */
  }
  
  void pause() {
    _paused = true;
    _pause();
  }
  
  void _pause() {
    if ($element.find('.next, .prev').isNotEmpty && Transition.isUsed) {
      $element.trigger(Transition.end);
      _cycle();
    }
    /*
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
  
  void slide(String type, [Element? next]) {
    final activeItem = active,
      items = $element.find('.item'),
      nextItem = next ??
        (type == 'next' ? activeItem?.nextElementSibling ?? items.first :
         type == 'prev' ? activeItem?.previousElementSibling ?? items.last :
         null);
    final direction = type == 'next' ? 'left' : 'right';
    /*
        , isCycling = this.interval
    */
    _sliding = true;
    
    /*
    isCycling && this.pause()
    */
    
    final e = QueryEvent('slide.bs.carousel', data: {
      'relatedTarget': nextItem,
      'direction': direction
    });
    
    if (nextItem == null || nextItem.classes.contains('active'))
      return;

    final indicators = _indicators;
    if (indicators != null) {
      $(indicators).find('.active').removeClass('active');
      $element.one('slid.bs.carousel', (QueryEvent e) {
        final elems = indicators.children,
          index = activeIndex;
        if (index > -1 && index < elems.length)
          elems[index].classes.add('active');
      });
    }
    
    $element.triggerEvent(e);
    if (e.defaultPrevented || activeItem == null)
      return;
    
    if (Transition.isUsed && element.classes.contains('slide')) {
      nextItem.classes.add(type);
      $(nextItem).reflow(); // force reflow
      activeItem.classes.add(direction);
      nextItem.classes.add(direction);
      
      $element.one(Transition.end, (QueryEvent e) {
        nextItem.classes
          ..removeAll(['type', direction])
          ..add('active');
        activeItem.classes.removeAll(['type', direction]);
        _sliding = false;
        Timer.run(() {
          $element.trigger('slid.bs.carousel');
        });
      });
      
    } else {
      activeItem.classes.remove('active');
      nextItem.classes.add('active');
      _sliding = false;
      $element.trigger('slid.bs.carousel');
      
    }
    /*
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
    $document().on('click.carousel.data-api', '[data-slide], [data-slide-to]', (QueryEvent e) {
      Element elem = e.target as Element;
      ElementQuery $target = $(p.getDataTarget(elem));
      
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
