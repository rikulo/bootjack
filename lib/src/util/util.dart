part of bootjack;

Map _copy(Map a, Map b) {
  final Map c = new Map.from(a);
  if (b != null)
    b.forEach((key, value) => c[key] = value);
  return c;
}
