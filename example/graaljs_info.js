// Example from https://www.graalvm.org/latest/reference-manual/js/JavaScriptCompatibility/#graal-object

if (typeof Graal != "undefined") {
  print(Graal.versionECMAScript);
  print(Graal.versionGraalVM);
  print(Graal.isGraalRuntime());
}
