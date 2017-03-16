part of bootjack;

final Map<String, String> _TRANS_END_EVENT_NAMES = {
  'webkit-' : 'webkitTransitionEnd',
  'moz-'    : 'transitionend',
  'o-'      : 'oTransitionEnd otransitionend'
};

/** Transition related utilities.
 */
class Transition {
  
  /** Return true if transition is used.
   */
  static bool get isUsed => _used;
  static bool _used = false;
  
  /** Register to use Transition effect.
   */
  static void use() {
    _used = true;
  }
  
  /** The event name for transition end across browser.
   */
  static String get end {
    if (_end == null) {
      _end = _TRANS_END_EVENT_NAMES[Device.cssPrefix] ?? 'transitionend';
    }
    return _end;
  }
  static String _end;
}
