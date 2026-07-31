#!/bin/sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

qmllint -I "$root" "$root/shell.qml"

rg --files "$root" -g '*.qml' \
  | while IFS= read -r file; do
      case "$file" in
        "$root/services/WorkspacePreviewService.qml"|"$root/services/NotificationService.qml") ;;
        *) qmllint -I "$root" "$file" ;;
      esac
    done

qml_test_runner=/usr/lib/qt6/bin/qmltestrunner
if [ ! -x "$qml_test_runner" ]; then
  qml_test_runner=qmltestrunner
fi

test_import_root=$(mktemp -d)
trap 'rm -rf -- "$test_import_root"' EXIT HUP INT TERM
mkdir -p "$test_import_root/qs/features"
ln -s "$root/components" "$test_import_root/qs/components"
ln -s "$root/theme" "$test_import_root/qs/theme"
ln -s "$root/features/workspaces" "$test_import_root/qs/features/workspaces"
ln -s "$root/features/clock" "$test_import_root/qs/features/clock"

QT_QPA_PLATFORM=offscreen "$qml_test_runner" \
  -import "$test_import_root" \
  -input "$root/tests"

if rg -n '#[0-9a-fA-F]{6}([0-9a-fA-F]{2})?' "$root" \
  -g '*.qml' \
  -g '!theme/DraculaPalette.qml'; then
  echo "Hex color literals must live in theme/DraculaPalette.qml" >&2
  exit 1
fi

if rg -n 'StyledText\.(Normal|Muted|Primary|Secondary|Tertiary|Highlight|Success|Warning|Critical|Attention|OnAccent)' \
  "$root" -g '*.qml'; then
  echo "Color semantics must use theme/SemanticRoles.qml" >&2
  exit 1
fi

if rg -n 'visible:\s*opacity' "$root" -g '*.qml'; then
  echo "Visibility must represent presence; use opacity only for animation" >&2
  exit 1
fi
