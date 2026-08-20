#!/bin/bash
# Explain a failed library load on Linux, cheapest signal first.
#
# Qt picking the wrong platform plugin -- or none -- is nearly always one
# absent .so, and both `ldd` and QT_DEBUG_PLUGINS name it outright, in a
# handful of lines ("could not select xcb because libxcb-cursor.so.0 is
# missing"). LD_DEBUG=libs answers a different question: it shows the search
# itself, which is what you want when the library *is* installed and the loader
# still refuses it -- wrong directory, wrong soname, wrong architecture. It
# also runs to thousands of lines, so it goes last and trimmed.
set -u

script="${1:-tests/test_qt.py}"

echo "::group::Unresolved dependencies of Qt plugins and Mesa drivers (ldd)"
site=$(python -c 'import site; print(site.getsitepackages()[0])' 2>/dev/null || echo /nonexistent)
found=0
while IFS= read -r lib; do
  missing=$(ldd "$lib" 2>/dev/null | grep 'not found' || true)
  if [[ -n "$missing" ]]; then
    found=1
    echo "$lib"
    echo "$missing" | sed 's/^/    /'
  fi
done < <(
  find "$site" -path '*plugins/platforms*' -name '*.so' 2>/dev/null
  ls /usr/lib/*/dri/*.so 2>/dev/null
)
if [[ "$found" -eq 0 ]]; then
  echo "nothing unresolved -- if Qt still failed, the cause is below, not here"
fi
echo "::endgroup::"

echo "::group::Qt plugin selection (QT_DEBUG_PLUGINS=1)"
QT_DEBUG_PLUGINS=1 QT_LOGGING_RULES='qt.qpa.*=true' python "$script" 2>&1 | tail -80
echo "::endgroup::"

echo "::group::Loader trace (LD_DEBUG=libs)"
LD_DEBUG=libs python "$script" >ld_debug.log 2>&1 || true
echo "--- lines naming something that could not be opened ---"
grep -E 'cannot open shared object|not found' ld_debug.log | sort -u | head -40
echo "--- last 120 lines of the trace ---"
tail -120 ld_debug.log
echo "::endgroup::"
