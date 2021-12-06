part of bootjack;

Map<K, V> _copy<K, V>(Map<K, V> a, Map<K, V>? b) {
  final c = <K, V>{...a};
  if (b != null)
    b.forEach((key, value) => c[key] = value);
  return c;
}

String? _trimSuffix(String? src, String suffix) =>
  src == null ? null :
  src.endsWith(suffix) ? src.substring(0, src.length - suffix.length): src;