part of bootjack;

_fallback(a, b()) => a != null ? a : b();

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
