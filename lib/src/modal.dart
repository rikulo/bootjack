part of bootjack;

// TODO
// 4. DQuery load()

/**
 * 
 */
class Modal extends Base {
  
  /**
   * 
   */
  final String backdrop0; // false, true, static: should use enum when ready
  
  /**
   * 
   */
  final bool keyboard;
  
  /**
   * 
   */
  Modal(Element element, {String backdrop: 'true', bool keyboard: true, 
    String remote}) :
  this.backdrop0 = backdrop,
  this.keyboard = keyboard,
  super(element) {
    $element.on('click.dismiss.modal', 
        (DQueryEvent e) => hide(), 
        selector: '[data-dismiss="modal"]');
    if (remote != null) {
      //this.$element.find('.modal-body').load(this.options.remote)
    }
  }
  
  /**
   * 
   */
  toggle() => _shown ? show() : hide();
  
  /**
   * 
   */
  bool get isShown => _shown;
  bool _shown = false;
  
  /**
   * 
   */
  show() {
    
    DQueryEvent e = new DQueryEvent('show');
    $element.triggerEvent(e);
    
    if (_shown || e.isDefaultPrevented)
      return;
    _shown = true;
    
    if (keyboard) {
      $element.on('keyup.dismiss.modal', (DQueryEvent e) {
        if ((e.originalEvent as KeyEvent).keyCode == 27)
          hide();
      });
    }
    
    backdrop(() {
      
      final bool transition = Transition.isUsed && element.classes.contains('fade');
      
      if (element.parent == null)
        document.body.append(element);
      
      $element.show();
      
      /*
      if (transition) {
        that.$element[0].offsetWidth // force reflow
      }
      */
      
      element.classes.add('in');
      element.attributes['aria-hidden'] = 'false';
      
      _enforceFocus();
      
      if (transition) {
        $element.one(Transition.end, (DQueryEvent e) {
          $element.trigger('focus');
          $element.trigger('shown');
        });
        
      } else {
        $element.trigger('focus');
        $element.trigger('shown');
        
      }
      
    });
    
  }
  
  /**
   * 
   */
  hide() {
    final Element elem = element;
    
    DQueryEvent e = new DQueryEvent('hide');
    $element.triggerEvent(e);
    
    if (!_shown || e.isDefaultPrevented)
      return;
    _shown = false;
    
    $element.off('keyup.dismiss.modal');
    
    $document().off('focusin.modal');
    
    elem.classes.remove('in');
    elem.attributes['aria-hidden'] = 'true';
    
    if (Transition.isUsed && elem.classes.contains('fade')) {
      _hideWithTransition();
      
    } else {
      _hideModal();
      
    }
    
  }
  
  _hide(DQueryEvent e) {
    if (e != null)
      e.preventDefault();
    hide();
  }
  
  // TODO: below are not in API?
  
  void _enforceFocus() {
    $document().on('focusin.modal', (DQueryEvent e) {
      EventTarget tar = e.target;
      if (element != tar && (!(tar is Node) || (tar as Node).parent != element))
        $element.trigger('focus');
    });
  }
  
  void _hideWithTransition() {
    bool canceled = false;
    new Future.delayed(const Duration(milliseconds: 500)).then(() {
      if (!canceled) {
        $element.off(Transition.end);
        _hideModal();
      }
    });
    $element.one(Transition.end, (DQueryEvent e) {
      canceled = true;
      _hideModal();
    });
  }
  
  void _hideModal() {
    $element.hide();
    backdrop(() {
      _removeBackdrop();
      $element.trigger('hidden');
    });
  }
  
  Element _backdropElem;
  
  void _removeBackdrop() {
    if (_backdropElem != null)
      _backdropElem.remove();
    _backdropElem = null;
  }
  
  void backdrop([void callback()]) {
    
    final bool fade = element.classes.contains('fade');
    final bool animate = Transition.isUsed && fade;
    bool transit = false;
    
    final DQueryEventListener listener = (DQueryEvent e) => callback();
    
    if (_shown && backdrop0 != 'false') { // backdrop0: false, true, or static
      
      _backdropElem = new DivElement();
      _backdropElem.classes.add('modal-backdrop');
      if (fade)
        _backdropElem.classes.add('fade');
      document.body.append(_backdropElem);
      
      $(_backdropElem).on('click', backdrop0 == 'static' ? 
          (DQueryEvent e) => element.focus() : (DQueryEvent e) => hide());
      
      //if (animate) this.$backdrop[0].offsetWidth // force reflow
      
      _backdropElem.classes.add('in');
      transit = true;
      
    } else if (!_shown && _backdropElem != null) {
      _backdropElem.classes.remove('in');
      transit = true;
      
    }
    
    if (callback != null) {
      if (animate && transit) {
        $(_backdropElem).one(Transition.end, listener);
        
      } else {
        callback();
        
      }
    }
    
  }
  
  static void register() {
    $document().on('click.modal.data-api', (DQueryEvent e) {
      if (!(e.target is Element))
        return;
      final Element elem = e.target as Element;
      final String href = elem.attributes['href'];
      final ElementQuery $target = $(_fallback(elem.attributes['data-target'], () => href));
      
      e.preventDefault();
      
      if ($target.isEmpty)
        return;
      
      Modal modal = $target.data.get('modal');
      if (modal != null)
        modal.toggle();
      else {
        // , option = $target.data('modal') ? 'toggle' : $.extend({ remote:!/#/.test(href) && href }, $target.data(), $this.data())
        $target.data.set('modal', modal = new Modal($target.first)); // TODO: other options
        modal.show();
      }
      
      $target.one('hide', (DQueryEvent e) => $(elem).trigger('focus'));
      
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
