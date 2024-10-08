enum Routes {
  splash,
  main,
  // Login
  login,
  // Bottom Navigation
  profiles,
  inbox,
  // Others
  chat,
  ;

  const Routes({
    this.pathOverride,
    this.pathParameters,
  });
  final String? pathOverride;
  final Set<String>? pathParameters;

  String get path {
    final initialPath = pathOverride ?? '/$name';
    if (pathParameters != null) {
      return '$initialPath/:${pathParameters!.join('/:')}';
    } else {
      return initialPath;
    }
  }
}
