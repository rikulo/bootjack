part of bootjack;

Map<K, V> _copy<K, V>(Map<K, V> a, Map<K, V>? b) {
  final c = <K, V>{...a};
  if (b != null)
    b.forEach((key, value) => c[key] = value);
  return c;
}
