part of bootjack;

/**
 * 
 */
class Modal extends Base {
  
  /**
   * 
   */
  backdrop0;
  
  /**
   * 
   */
  bool keyboard;
  
  /**
   * 
   */
  bool show0; // TODO: rename, conflict with method name
  
  final ElementQuery _$element;
  
  /**
   * 
   */
  Modal(Element element, {bool backdrop: true, bool keyboard: true, bool show: true}) :
  this.backdrop0 = backdrop,
  this.keyboard = keyboard,
  this.show0 = show,
  _$element = $(element),
  super(element) {
    // TODO
    /*
    this.$element = $(element)
      .delegate('[data-dismiss="modal"]', 'click.dismiss.modal', $.proxy(this.hide, this))
    this.options.remote && this.$element.find('.modal-body').load(this.options.remote)
    */
  }
  
  /**
   * 
   */
  toggle() => _shown ? show() : hide();
  
  /**
   * 
   */
  bool get isShown => _shown;
  bool _shown;
  
  /**
   * 
   */
  show() {
    
    DQueryEvent e = new DQueryEvent('show');
    _$element.trigger(e); // TODO: trigger(event)
    
    if (_shown || e.isDefaultPrevented)
      return;
    _shown = true;
    
    escape();
    
    backdrop(() {
      
      final Element elem = element;
      final bool transition = Transition.isUsed && element.classes.contains('fade');
      
      if (elem.parent == null)
        document.body.append(elem);
      
      //that.$element.show()
      
      /*
      if (transition) {
        that.$element[0].offsetWidth // force reflow
      }
      */
      
      elem.classes.add('in');
      elem.attributes['aria-hidden'] = 'false';
      
      enforceFocus();
      
      if (transition) {
        _$element.one(Transition.end, (DQueryEvent e) {
          elem.focus(); // src: that.$element.focus()
          _$element.trigger('shown');
        });
        
      } else {
        elem.focus(); // src: that.$element.focus()
        _$element.trigger('shown');
        
      }
      
    });
    
  }
  
  /**
   * 
   */
  hide() {
    final Element elem = element;
    
    DQueryEvent e = new DQueryEvent('hide');
    _$element.trigger(e); // TODO: trigger(event)
    
    if (!_shown || e.isDefaultPrevented)
      return;
    _shown = false;
    
    escape();
    
    $document().off('focusin.modal');
    
    elem.classes.remove('in');
    elem.attributes['aria-hidden'] = 'true';
    
    if (Transition.isUsed && elem.classes.contains('fade')) {
      hideWithTransition();
      
    } else {
      hideModal();
      
    }
    
  }
  
  _hide(DQueryEvent e) {
    if (e != null)
      e.preventDefault();
    hide();
  }
  
  void enforceFocus() {
    $document().on('focusin.modal', (DQueryEvent e) { // TODO: may need to work on DQuery focus/blur
      /*
      if (that.$element[0] !== e.target && !that.$element.has(e.target).length) {
        that.$element.focus()
      }
      */
    });
  }
  
  void escape() {
    if (_shown && keyboard) {
      _$element.on('keyup.dismiss.modal', (DQueryEvent e) {
        if ((e.originalEvent as KeyEvent).which == 27)
          hide();
      });
      
    } else if (!_shown) {
      _$element.off('keyup.dismiss.modal');
      
    }
  }
  
  void hideWithTransition() {
    /*
    var that = this
        , timeout = setTimeout(function () {
          that.$element.off($.support.transition.end)
          that.hideModal()
        }, 500)

    this.$element.one($.support.transition.end, function () {
      clearTimeout(timeout)
      that.hideModal()
    })
    */
  }
  
  void hideModal() {
    // TODO
    //this.$element.hide()
    backdrop(() {
      removeBackdrop();
      _$element.trigger('hidden');
    });
  }
  
  Element _backdrop;
  
  void removeBackdrop() {
    if (_backdrop != null)
      _backdrop.remove();
    _backdrop = null;
  }
  
  void backdrop([void callback()]) {
    
    final bool fade = element.classes.contains('fade');
    final bool animate = Transition.isUsed && fade;
    bool transit = false;
    
    final DQueryEventListener listener = (DQueryEvent e) => callback();
    
    if (_shown && backdrop0 != null) {
      
      _backdrop = new DivElement();
      _backdrop.classes.add('modal-backdrop');
      if (fade)
        _backdrop.classes.add('fade');
      document.body.append(_backdrop);
      
      /*
      this.$backdrop.click(
          this.options.backdrop == 'static' ?
              $.proxy(this.$element[0].focus, this.$element[0])
            : $.proxy(this.hide, this)
          )
      */
      
      //if (animate) this.$backdrop[0].offsetWidth // force reflow
      
      _backdrop.classes.add('in');
      transit = true;
      
    } else if (!_shown && _backdrop != null) {
      _backdrop.classes.remove('in');
      transit = true;
      
    }
    
    if (callback != null) {
      if (animate) {
        $(_backdrop).one(Transition.end, listener);
        
      } else {
        callback();
        
      }
    }
    
  }
  
  static void register() {
    $document('click.modal.data-api', (DQueryEvent e) {
      /*
      var $this = $(this)
          , href = $this.attr('href')
          , $target = $($this.attr('data-target') || (href && href.replace(/.*(?=#[^\s]+$)/, ''))) //strip for ie7
          , option = $target.data('modal') ? 'toggle' : $.extend({ remote:!/#/.test(href) && href }, $target.data(), $this.data())

              e.preventDefault()

              $target
              .modal(option)
              .one('hide', function () {
                $this.focus()
              })
      */
    }, selector: '[data-toggle="modal"]');
  }
  
}

/*
 // MODAL PLUGIN DEFINITION
 // ======================= 

  $.fn.modal = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('modal')
        , options = $.extend({}, $.fn.modal.defaults, $this.data(), typeof option == 'object' && option)
      if (!data) $this.data('modal', (data = new Modal(this, options)))
      if (typeof option == 'string') data[option]()
      else if (options.show) data.show()
    })
  }

*/
