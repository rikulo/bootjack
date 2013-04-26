part of bootjack;

_fallback(a, b(), [c()]) => a != null ? a : _fallback(b(), () => c == null ? null : c());

Map _copy(Map a, Map b) {
  Map c = new HashMap.from(a);
  if (b != null)
    b.forEach((key, value) => a[key] = value);
  return c;
}

Element _closest(Element elem, bool f(Element elem)) {
  while (!f(elem))
    elem = elem.parent;
  return elem;
}
