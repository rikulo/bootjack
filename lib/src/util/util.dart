part of bootjack;

Map _copy(Map a, Map b) {
  Map c = new HashMap.from(a);
  if (b != null)
    b.forEach((key, value) => a[key] = value);
  return c;
}
