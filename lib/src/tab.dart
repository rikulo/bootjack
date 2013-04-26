part of bootjack;

// required jQuery features:
// classes
// traversing: closest()/find()
// event: $.Event()/trigger()/one()
// attr()
// $.support.transition
// data()
// on()

class Tab extends Base {
  
  static const String _NAME = 'tab';
  
  Tab(Element element) : super(element, _NAME);
  
  void show() {
    final ElementQuery $ul = $element.closest(selector: 'ul:not(.dropdown-menu)');
    final String selector = _fallback(
        element.attributes['data-target'], 
        () => element.attributes['href']); // TODO: should cache in construction?
    /*
      if (!selector) {
        selector = $this.attr('href')
        selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
      }
    */
    
    //if ( $this.parent('li').hasClass('active') ) return
    
    Element previous = $ul.find('.active:last a').first;
    //previous = $ul.find('.active:last a')[0]
    
    DQueryEvent e = new DQueryEvent('show'); // TODO: data
    //e = $.Event('show', { relatedTarget: previous })
    
    $element.trigger(e);
    
    if (e.isDefaultPrevented) 
      return;
    
    ElementQuery $target = $(selector);
    
    /*
      this.activate($this.parent('li'), $ul)
      this.activate($target, $target.parent(), function () {
        $this.trigger({
          type: 'shown'
        , relatedTarget: previous
        })
      })
    */
    
  }
  
  void activate(element, container, callback) {
    /*
    var $active = container.find('> .active')
        , transition = callback
            && $.support.transition
            && $active.hasClass('fade')

      function next() {
        $active
          .removeClass('active')
          .find('> .dropdown-menu > .active')
          .removeClass('active')

        element.addClass('active')

        if (transition) {
          element[0].offsetWidth // reflow for transition
          element.addClass('in')
        } else {
          element.removeClass('fade')
        }

        if ( element.parent('.dropdown-menu') ) {
          element.closest('li.dropdown').addClass('active')
        }

        callback && callback()
      }

      transition ?
        $active.one($.support.transition.end, next) :
        next()

      $active.removeClass('in')
    */
  }
  
  static void register() {
    
    $document().on('click.tab.data-api', (DQueryEvent e) {
      e.preventDefault();
      // $(this).tab('show')
    }, selector: '[data-toggle="tab"], [data-toggle="pill"]');
    
  }
  
}

/*
 // TAB PLUGIN DEFINITION
 // ===================== 

  $.fn.tab = function ( option ) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('tab')
      if (!data) $this.data('tab', (data = new Tab(this)))
      if (typeof option == 'string') data[option]()
    })
  }
*/
