part of bootjack;

class Collapse extends Base {
  
  static const String _NAME = 'collapse';
  
  /** Construct a collapse component and wire it to [element].
   * 
   * + If [toggle] is true, Toggles the collapsible element on invocation. Default: true.
   * + 
   * [parent] determines if selector then all collapsible elements under the specified parent 
   * will be closed when this collapsible item is shown. 
   * (similar to traditional accordion behavior - 
   * this dependent on the accordion-group class)
   * 
   */
  Collapse(Element element, {bool toggle, String parent}) :
  this._toggle  = _data(toggle, element, 'toggle', true),
  super(element, _NAME) {
    if (parent == null)
      parent = element.attributes["data-parent"];
    if (parent != null)
      _$parent = $(parent);
    
    
    if (_toggle != null)
      this.toggle();
  }
  
  /** Retrieve the wired Collapse object from an element. If there is no wired
   * Collapse object, a new one will be created.
   * 
   * + [create] - If provided, it will be used for Collapse creation. Otherwise 
   * the default constructor with no optional parameter value is used.
   */
  static Collapse wire(Element element, [Collapse create()]) =>
      p.wire(element, _NAME, p.fallback(create, () => () => new Collapse(element)));
  
  
  final bool _toggle;
  ElementQuery _$parent;
  
  bool get transitioning => _transitioning;
  bool _transitioning = false;
  
  bool get horizontal => p.fallback(_horizontal, 
      () => _horizontal = element.classes.contains('width'));
  bool _horizontal;
  
  void show() {
    if (transitioning || element.classes.contains('in'))
      return;
    
    
    final DQueryEvent e = new DQueryEvent('show.bs.collapse');
    $element.triggerEvent(e);
    
    if (e.isDefaultPrevented)
      return;
    
    
    if (_$parent != null) {
      ElementQuery panels = _$parent.children('.panel');
      if (panels.isNotEmpty) {
        for (Element panel in panels) {
          for (Element elem in $(panel).children('.in')) {
            Collapse active = $(elem).data.get(_NAME);
            
            if (active != null && active.transitioning) return;
            
            Collapse.wire(elem).hide();
            $(elem).data.set(_NAME, null);
          }
          
        }
      }
    }
    
    
    element.classes
    ..remove('collapse')
    ..add('collapsing');
    _size = '0';
    
    _transitioning = true;
    
    final DQueryEventListener complete = (DQueryEvent e) {
      element.classes
      ..remove('collapsing')
      ..add('in');
      _size = 'auto';
      _transitioning = false;
      $element.trigger('shown.bs.collapse');
    };
    
    
    if (!Transition.isUsed) {
      complete(null);
    } else {
      $element.one(Transition.end, complete);
      _size = '${horizontal ? element.scrollWidth : element.scrollHeight}px';
    }
  }
  
  void hide() {
    if (transitioning || !element.classes.contains('in'))
      return;
    
    
    final DQueryEvent e = new DQueryEvent('hide.bs.collapse');
    $element.triggerEvent(e);
    
    if (e.isDefaultPrevented)
      return;
    
    int size = horizontal ? $element.width : $element.height;
    _size = "${size}px";
    element.offsetHeight;
    
    element.classes
    ..add('collapsing')
    ..remove('collapse')
    ..remove('in');
    
    _transitioning = true;
    
    final DQueryEventListener complete = (DQueryEvent e) {
      _transitioning = false;
      $element.trigger('hidden.bs.collapse');
      element.classes
      ..remove('collapsing')
      ..add('collapse');
    };
    
    if (!Transition.isUsed) {
      complete(null);
    } else {
      _size = '0';
      $element.one(Transition.end, complete);
    }
    
  }
  
  void set _size(String size) {
    if (horizontal)
      element.style.width = size;
    else
      element.style.height = size;
  }
  
  void toggle() {
    if (element.classes.contains('in'))
      hide();
    else
      show();
  }
  
  static bool _registered = false;
  
  /** Register to use Collapse component.
   */
  static void use() {
    if (_registered) return;
    _registered = true;
    
    $document().on('click.bs.collapse.data-api', (DQueryEvent e) {
      Element elem = e.currentTarget as Element;
      String href;
      
      String targetStr = elem.attributes['data-target'];
      
      if (targetStr == null) {
        e.preventDefault();
        String href = elem.attributes['href'];
        if (href != null)
          targetStr = href.replaceAll(new RegExp(r'.*(?=#[^\s]+$)'), ''); //strip for ie7
      }
      
      ElementQuery $target = $(targetStr);
      Element target = $target[0];
      Collapse collapse = $target.data.get(_NAME);
      String parent = elem.attributes['data-parent'];
      ElementQuery $parent = $(parent);
      
      if (collapse == null || !collapse.transitioning) {
        if (parent != null) {
          ElementQuery collapses = $parent.find(
              '[data-toggle=collapse][data-parent="$parent"]');
          for (Element e in collapses) {
            if (e == elem) continue;
            e.classes.add('collapsed');
            
          }
        }
        p.setClass(elem, 'collapsed', target.classes.contains('in'));
      }
      
      if (collapse != null) {
        collapse.toggle();
      } else {
        String parentAtr = elem.attributes['data-parent'];
        String toggleAtr = elem.attributes['data-toggle'];
        
        new Collapse(target, toggle: toggleAtr != null ? true: null, parent: parentAtr);
      }
      
    }, selector: '[data-toggle=collapse]');
    
  }
  
}