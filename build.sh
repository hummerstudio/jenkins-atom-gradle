#!/usr/bin/env bash
# Compile the atom and pack dist/gradle/ — the directory tools/publish-atom.sh expects.
set -euo pipefail
cd "$(dirname "$0")"

if [ -n "${JAVA_HOME:-}" ] && [ -x "$JAVA_HOME/bin/javac" ]; then
  JAVAC="$JAVA_HOME/bin/javac"
  JAR="$JAVA_HOME/bin/jar"
else
  JAVAC=javac
  JAR=jar
fi

classes="$(mktemp -d)"
trap 'rm -rf "$classes"' EXIT
"$JAVAC" -encoding UTF-8 -d "$classes" src/GradleAtom.java

rm -rf dist/gradle
mkdir -p dist/gradle
"$JAR" --create --file dist/gradle/gradle.jar -C "$classes" .
cp task.json dist/gradle/
[ -f meta.json ] && cp meta.json dist/gradle/

echo "built dist/gradle: $(ls dist/gradle | tr '\n' ' ')"
