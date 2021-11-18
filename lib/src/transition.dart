part of bootjack;

const _transEndEventNames = <String, String>{
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
  static String get end
    => _end ??= _transEndEventNames[Device.cssPrefix] ?? 'transitionend';

  static String? _end;
}
