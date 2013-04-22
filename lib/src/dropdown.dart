part of bootjack;

// required jQuery features:
// classes
// traversing: parent()/eq()/filter()/find()
// Event: focus()
// attr()
// data()
// on()

class Dropdown extends Base {
  
  static final String _TOGGLE_SELECTOR ='[data-toggle=dropdown]'; 
  
  Dropdown(Element element) : super(element) {
    $(element).on('click.dropdown.data-api', _toggle);
    $('html').on('click.dropdown.data-api', (DQueryEvent e) {
      Element p = element.parent;
      if (p != null)
        p.classes.remove('open');
    });
  }
  
  bool toggle() => _toggle(null);
  
  bool _toggle(DQueryEvent e) { // TODO: e is not even used
    final Element elem = element;
    if (elem.matches('.disabled, :disabled'))
      return;
    Element parent = getParent();
    /*
    isActive = $parent.hasClass('open')

    clearMenus()

    if (!isActive) {
      $parent.toggleClass('open')
    }

    $this.focus()

    return false
    */
  }
  
  void _keydown(DQueryEvent e) {
    /*
    var $this
    , $items
    , $active
    , $parent
    , isActive
    , index

    if (!/(38|40|27)/.test(e.keyCode)) return

    $this = $(this)

    e.preventDefault()
    e.stopPropagation()

    if ($this.is('.disabled, :disabled')) return

    $parent = getParent($this)

    isActive = $parent.hasClass('open')

    if (!isActive || (isActive && e.keyCode == 27)) {
      if (e.which == 27) $parent.find(toggle).focus()
      return $this.click()
    }

    $items = $('[role=menu] li:not(.divider):visible a', $parent)

    if (!$items.length) return

    index = $items.index($items.filter(':focus'))

    if (e.keyCode == 38 && index > 0) index--                                        // up
    if (e.keyCode == 40 && index < $items.length - 1) index++                        // down
    if (!~index) index = 0

    $items
    .eq(index)
    .focus()
    */
  }
  
  void clearMenus() {
    for (Node n in $(_TOGGLE_SELECTOR)) {
      
    }
    /*
    $(toggle).each(function () {
      getParent($(this)).removeClass('open')
    })
    */
  }

  Element getParent() {
    Element elem = element;
    String selector = elem.attributes['data-target']; // TODO: use dataset?
    if (selector == null) {
      selector = elem.attributes['href'];
      // src: selector = selector && /#/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }
    /*
    $parent = selector && $(selector)

    if (!$parent || !$parent.length) $parent = $this.parent()

    return $parent
    */
  }
  
  static void register() {
    /*
    $(document)
    .on('click.dropdown.data-api', clearMenus)
    .on('click.dropdown.data-api', '.dropdown form', function (e) { e.stopPropagation() })
    .on('click.dropdown-menu', function (e) { e.stopPropagation() })
    .on('click.dropdown.data-api'  , toggle, Dropdown.prototype.toggle)
    .on('keydown.dropdown.data-api', toggle + ', [role=menu]' , Dropdown.prototype.keydown)
    */
  }
  
}

/*

  // DROPDOWN PLUGIN DEFINITION
  // ========================== 

  $.fn.dropdown = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('dropdown')
      if (!data) $this.data('dropdown', (data = new Dropdown(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

*/
