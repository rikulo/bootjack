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
  static bool get isSupported {
    if (_supported == null) {
      if (Device.isIE) {
        int version = _ieVersion;
        _supported =  version != null && version > 9;
      } else {
        _supported = true;
      }
    }
    return _supported;
  }
  static bool _supported;
  
  static int get _ieVersion {
    try {
      return int.parse(_IE_VERSION.firstMatch(Device.userAgent).group(1));
    } catch (_) {}
    return null;
  }
  static final RegExp _IE_VERSION = new RegExp(r'MSIE\s+(\d+)');
  
}
