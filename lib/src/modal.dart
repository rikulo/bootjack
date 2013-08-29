part of bootjack;

// TODO
// 4. DQuery load()

/** A Modal box component.
 */
class Modal extends Base {
  
  static const String _NAME = 'modal';
  
  /**
   * 
   */
  final String backdrop; // false, true, static: should use enum when ready
  
  /** Return true if the Modal component listens to escape key for closing.
   */
  final bool keyboard;
  
  /** Construct a Modal object and wire it to [element].
   */
  Modal(Element element, {String backdrop: 'true', bool keyboard: true, String remote}) :
  this.backdrop = backdrop,
  this.keyboard = keyboard,
  super(element, _NAME) {
    $element.on('click.dismiss.modal', (DQueryEvent e) => hide(), selector: '[data-dismiss="modal"]');
    if (remote != null) {
      //this.$element.find('.modal-body').load(this.options.remote)
    }
  }
  
  /** Retrieve the wired Modal object from an element. If there is no wired
   * Modal object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Modal creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Modal wire(Element element, [Modal create()]) =>
      p.wire(element, _NAME, p.fallback(create, () => () => new Modal(element)));
  
  /** Toggle the visibility state of the Modal.
   */
  toggle() => _shown ? hide() : show();
  
  /** True if the Modal is shown.
   */
  bool get isShown => _shown;
  bool _shown = false;
  
  /** Show the Modal.
   */
  show() {
    
    final DQueryEvent e = new DQueryEvent('show.bs.modal');
    $element.triggerEvent(e);
    
    if (_shown || e.isDefaultPrevented)
      return;
    _shown = true;
    
    if (keyboard) {
      $element.on('keyup.dismiss.modal', (DQueryEvent e) {
        if ((e.originalEvent as KeyboardEvent).keyCode == 27)
          hide();
      });
    }
    
    _backdrop(() {
      
      final bool transition = Transition.isUsed && element.classes.contains('fade');
      
      if (element.parent == null)
        document.body.append(element);
      
      $element.show();
      
      if (transition) element.offsetWidth; // force reflow
      
      element.classes.add('in');
      element.attributes['aria-hidden'] = 'false';
      
      _enforceFocus();
      
      if (transition) {
        $element.one(Transition.end, (DQueryEvent e) {
          $element.trigger('focus');
          $element.trigger('shown.bs.modal');
        });
        
      } else {
        $element.trigger('focus');
        $element.trigger('shown.bs.modal');
        
      }
      
    });
    
  }
  
  /** Hide the Modal.
   */
  hide() {
    
    final DQueryEvent e = new DQueryEvent('hide.bs.modal');
    $element.triggerEvent(e);
    
    if (!_shown || e.isDefaultPrevented)
      return;
    _shown = false;
    
    $element.off('keyup.dismiss.modal');
    
    $document().off('focusin.modal');
    
    element.classes.remove('in');
    element.attributes['aria-hidden'] = 'true';
    
    if (Transition.isUsed && element.classes.contains('fade')) {
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
  
  void _enforceFocus() {
    $document().on('focusin.modal', (DQueryEvent e) {
      EventTarget tar = e.target;
      if (element != tar && (!(tar is Node) || (tar as Node).parent != element))
        $element.trigger('focus');
    });
  }
  
  void _hideWithTransition() {
    bool canceled = false;
    new Future.delayed(const Duration(milliseconds: 500)).then((_) {
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
    _backdrop(() {
      _removeBackdrop();
      $element.trigger('hidden.bs.modal');
    });
  }
  
  Element _backdropElem;
  
  void _removeBackdrop() {
    if (_backdropElem != null)
      _backdropElem.remove();
    _backdropElem = null;
  }
  
  void _backdrop([void callback()]) {
    
    final bool fade = element.classes.contains('fade');
    final bool animate = Transition.isUsed && fade;
    bool transit = false;
    
    final DQueryEventListener listener = (DQueryEvent e) => callback();
    
    if (_shown && backdrop != 'false') {
      
      _backdropElem = new DivElement();
      _backdropElem.classes.add('modal-backdrop');
      if (fade)
        _backdropElem.classes.add('fade');
      document.body.append(_backdropElem);
      
      $(_backdropElem).on('click', backdrop == 'static' ? 
          (DQueryEvent e) => element.focus() : (DQueryEvent e) => hide());
      
      if (animate) _backdropElem.offsetWidth; // force reflow
      
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
  
  // Data API //
  static bool _registered = false;
  
  /** Register to use Modal component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $document().on('click.modal.data-api', (DQueryEvent e) {
      if (!(e.target is Element))
        return;
      
      final Element elem = e.target as Element;
      //final String href = elem.attributes['href'];
      final ElementQuery $target = $(p.getDataTarget(elem));
      
      e.preventDefault();
      
      if ($target.isEmpty)
        return;
      
      // , option = $target.data('modal') ? 'toggle' : $.extend({ remote:!/#/.test(href) && href }, $target.data(), $this.data())
      Modal.wire($target.first, () => new Modal($target.first)).toggle(); // TODO: other options
      
      $target.one('hide', (DQueryEvent e) => $(elem).trigger('focus'));
      
    }, selector: '[data-toggle="modal"]');
  }
  
}
