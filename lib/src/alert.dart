part of bootjack;

// required jQuery features:
// attr()
// classes: hasClass()
// traversing: parent()
// event: trigger()
// remove()
// transition?
// data()
// on()

class Alert {
  
  // var dismiss = '[data-dismiss="alert"]'
  
  Alert() {
    /*
    $(el).on('click', dismiss, this.close)
    */
  }
  
  void close([Event e]) {
    /*
    var $this = $(this)
      , selector = $this.attr('data-target')
      , $parent

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }

    $parent = $(selector)

    e && e.preventDefault()

    $parent.length || ($parent = $this.hasClass('alert') ? $this : $this.parent())

    $parent.trigger(e = $.Event('close'))

    if (e.isDefaultPrevented()) return

    $parent.removeClass('in')

    function removeElement() {
      $parent
        .trigger('closed')
        .remove()
    }

    $.support.transition && $parent.hasClass('fade') ?
      $parent.on($.support.transition.end, removeElement) :
      removeElement()
    */
  }
  
}

/*
 // ALERT PLUGIN DEFINITION
 // ======================= 

  $.fn.alert = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('alert')
      if (!data) $this.data('alert', (data = new Alert(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

 // ALERT DATA-API
 // ============== 

  $(document).on('click.alert.data-api', dismiss, Alert.prototype.close)

*/