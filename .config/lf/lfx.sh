lfx() {
  tmp="/tmp/LF_LAST_DIR_PATH"
  echo "$PWD" > $tmp
  lf "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp"
    if [ -d "$dir" ]; then
      if [ "$dir" != "$(pwd)" ]; then
        cd "$dir"
      fi
    fi
  fi
}
