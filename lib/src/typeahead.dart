part of bootjack;

// required jQuery features:
// classes
// traversing: find()
// focus()
// attr()
// insertAfter()/html()
// val()/show()/css()
// $.grep()
// data()
// on()
// TODO: html manipulation

class Typeahead extends Base {
  
  static const String _NAME = 'typeahead';
  
  bool _shown = false;
  List _source;
  int _items, _minLength;
  String _itemTemplate;
  
  /**
   * 
   */
  Typeahead(Element element, {List source: [], int items: 8, int minLength: 1,
  String itemTemplate: '<li><a href="#"></a></li>', 
  String menuTemplate: '<ul class="typeahead dropdown-menu"></ul>'}) :
  _source = source,
  _items = items,
  _minLength = minLength,
  _itemTemplate = itemTemplate,
  super(element, _NAME) {
    // TODO: closures
    /*
    this.matcher = this.options.matcher || this.matcher
    this.sorter = this.options.sorter || this.sorter
    this.highlighter = this.options.highlighter || this.highlighter
    this.updater = this.options.updater || this.updater
    */
    
    // TODO: menu can also be a selector? so $(html) becomes necessary
    _menu = new Element.html(menuTemplate); // TODO: try catch?
    _$menu = $(_menu);
    
    listen();
  }
  
  Element _menu;
  ElementQuery _$menu;
  
  /** Retrieve the wired Typeahead object from an element. If there is no wired
   * Typeahead object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Typeahead creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Typeahead wire(Element element, [Typeahead create()]) =>
      _wire(element, _NAME, _fallback(create, () => () => new Typeahead(element)));
  
  void select() {
    /*
    var val = this.$menu.find('.active').attr('data-value')
    this.$element
    .val(this.updater(val))
    .change()
    */
    hide();
  }
  
  /*
  , updater: function (item) {
      return item
    }
  */
  
  void show() {
    /*
    var pos = $.extend({}, this.$element.position(), {
      height: this.$element[0].offsetHeight
    })

    this.$menu
    .insertAfter(this.$element)
    .css({
      top: pos.top + pos.height
      , left: pos.left
    })
    */
    _$menu.show();
    _shown = true;
  }
  
  void hide() {
    _$menu.hide();
    _shown = false;
  }
  
  /*
  , lookup: function (event) {
      var items

      this.query = this.$element.val()

      if (!this.query || this.query.length < this.options.minLength) {
        return this.shown ? this.hide() : this
      }

      items = $.isFunction(this.source) ? this.source(this.query, $.proxy(this.process, this)) : this.source

      return items ? this.process(items) : this
    }

  , process: function (items) {
      var that = this

      items = $.grep(items, function (item) {
        return that.matcher(item)
      })

      items = this.sorter(items)

      if (!items.length) {
        return this.shown ? this.hide() : this
      }

      return this.render(items.slice(0, this.options.items)).show()
    }

  , matcher: function (item) {
      return ~item.toLowerCase().indexOf(this.query.toLowerCase())
    }

  , sorter: function (items) {
      var beginswith = []
        , caseSensitive = []
        , caseInsensitive = []
        , item

      while (item = items.shift()) {
        if (!item.toLowerCase().indexOf(this.query.toLowerCase())) beginswith.push(item)
        else if (~item.indexOf(this.query)) caseSensitive.push(item)
        else caseInsensitive.push(item)
      }

      return beginswith.concat(caseSensitive, caseInsensitive)
    }

  , highlighter: function (item) {
      var query = this.query.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, '\\$&')
      return item.replace(new RegExp('(' + query + ')', 'ig'), function ($1, match) {
        return '<strong>' + match + '</strong>'
      })
    }

  , render: function (items) {
      var that = this

      items = $(items).map(function (i, item) {
        i = $(that.options.item).attr('data-value', item)
        i.find('a').html(that.highlighter(item))
        return i[0]
      })

      items.first().addClass('active')
      this.$menu.html(items)
      return this
    }

  , next: function (event) {
      var active = this.$menu.find('.active').removeClass('active')
        , next = active.next()

      if (!next.length) {
        next = $(this.$menu.find('li')[0])
      }

      next.addClass('active')
    }

  , prev: function (event) {
      var active = this.$menu.find('.active').removeClass('active')
        , prev = active.prev()

      if (!prev.length) {
        prev = this.$menu.find('li').last()
      }

      prev.addClass('active')
    }
  */
  void listen() {
    
    /*
      this.$element
        .on('focus',    $.proxy(this.focus, this))
        .on('blur',     $.proxy(this.blur, this))
        .on('keypress', $.proxy(this.keypress, this))
        .on('keyup',    $.proxy(this.keyup, this))

      if (this.eventSupported('keydown')) {
        this.$element.on('keydown', $.proxy(this.keydown, this))
      }

      this.$menu
        .on('mouseenter', 'li', $.proxy(this.mouseenter, this))
        .on('mouseleave', 'li', $.proxy(this.mouseleave, this))
        */
    _$menu
    ..on('click', (DQueryEvent e) => click(this, e));
  }
  /*
  , eventSupported: function(eventName) {
      var isSupported = eventName in this.$element
      if (!isSupported) {
        this.$element.setAttribute(eventName, 'return;')
        isSupported = typeof this.$element[eventName] === 'function'
      }
      return isSupported
    }

  , move: function (e) {
      if (!this.shown) return

      switch(e.keyCode) {
        case 9: // tab
        case 13: // enter
        case 27: // escape
          e.preventDefault()
          break

        case 38: // up arrow
          e.preventDefault()
          this.prev()
          break

        case 40: // down arrow
          e.preventDefault()
          this.next()
          break
      }

      e.stopPropagation()
    }

  , keydown: function (e) {
      this.suppressKeyPressRepeat = ~$.inArray(e.keyCode, [40,38,9,13,27])
      this.move(e)
    }

  , keypress: function (e) {
      if (this.suppressKeyPressRepeat) return
      this.move(e)
    }

  , keyup: function (e) {
      switch(e.keyCode) {
        case 40: // down arrow
        case 38: // up arrow
        case 16: // shift
        case 17: // ctrl
        case 18: // alt
          break

        case 9: // tab
        case 13: // enter
          if (!this.shown) return
          this.select()
          break

        case 27: // escape
          if (!this.shown) return
          this.hide()
          break

        default:
          this.lookup()
      }

      e.stopPropagation()
      e.preventDefault()
  }

  , focus: function (e) {
      this.focused = true
    }

  , blur: function (e) {
      this.focused = false
      if (!this.mousedover && this.shown) this.hide()
    }
  */
  static void click(Typeahead t, DQueryEvent e) {
    e.stopPropagation();
    e.preventDefault();
    t.select();
    //t.$element.focus(); // TODO
  }
  /*
  , mouseenter: function (e) {
      this.mousedover = true
      this.$menu.find('.active').removeClass('active')
      $(e.currentTarget).addClass('active')
    }

  , mouseleave: function (e) {
      this.mousedover = false
      if (!this.focused && this.shown) this.hide()
    }

  }
  */
  
  // Data API //
  static bool _registered = false;
  
  /** Register to use Typeahead component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $document().on('focus.typeahead.data-api', (DQueryEvent e) {
      /*
      var $this = $(this)
          if ($this.data('typeahead')) return
              $this.typeahead($this.data())
      */
    }, selector: '[data-provide="typeahead"]');
  }
  
}

/*
  // TYPEAHEAD PLUGIN DEFINITION
  // =========================== 

  $.fn.typeahead = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('typeahead')
        , options = typeof option == 'object' && option
      if (!data) $this.data('typeahead', (data = new Typeahead(this, options)))
      if (typeof option == 'string') data[option]()
    })
  }
*/