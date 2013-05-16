part of bootjack;

Map<String, String> _TRANS_END_EVENT_NAMES = new HashMap<String, String>.from({
  'webkit-' : 'webkitTransitionEnd',
  'moz-'    : 'transitionend',
  'o-'      : 'oTransitionEnd otransitionend'
});

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
    if (isSupported)
      _used = true;
  }
  
  /** The event name for transition end across browser.
   */
  static String get end {
    if (_end == null) {
      _end = _fallback(_TRANS_END_EVENT_NAMES[Device.cssPrefix], () => 'transitionend');
    }
    return _end;
  }
  static String _end;
  
  /** Return true if CSS transition is supported in this device.
   */
  static bool get isSupported =>
      _fallback(_supported, () => _supported = !browser.msie || browser.version >= 9);
  static bool _supported;
  
}
