# rg
if ! command -v rg &> /dev/null
then
    echo "ripgrep (rg) not found, installing..."
    sudo apt-get install -y ripgrep
fi

severity_to_number() {
  case "$1" in
    LOW) echo 1 ;;
    MEDIUM) echo 2 ;;
    HIGH) echo 3 ;;
    CRITICAL) echo 4 ;;
    *) echo 0 ;;
  esac
}

get_html_link() {
  local link="$1"
  local modified_link="${link/en\//docs/en/}"
  echo "${modified_link}.plain.html"
}

LINKS=$(echo "$LINKS" | tr ',' '\n' | sed 's/,$//')
FAIL_ON_LEVEL_NUMBER=$(severity_to_number "$FAIL_ON_LEVEL")

EXIT_CODE=0

for LINK in $LINKS; do
  if [[ -n "$LINK" ]]; then
    NEW_LINK=$(get_html_link "$LINK")

    SEVERITY=$(curl -s "$NEW_LINK" |\
        rg "<div>Severity</div>" -A 1 |\
        rg -o '<div>[^<]+</div>' |\
        tail -n 1 |\
        sed 's/<[^>]*>//g')

    if [ -z "$SEVERITY" ]; then
      echo "Failed to get severity level for link: $NEW_LINK"
      echo "Continuing to next link..."
      continue
    fi

    SEVERITY_NUMBER=$(severity_to_number "$SEVERITY")

    if [[ $SEVERITY_NUMBER -ge $FAIL_ON_LEVEL_NUMBER ]]
      then
        echo "Failed on link: $LINK , severity level: $SEVERITY"
        EXIT_CODE=1
    fi
  fi
done

if [[ $EXIT_CODE -eq 1 ]]; then
  echo "One or more links failed the severity check. Check output above for details."

  # If soft fail is enabled, exit 0
  if [ "$3" ]; then
    echo "Soft fail is enabled, exiting with 0"
    exit 0
  fi
  else
    exit 1
fi

echo "Successfully got severity levels, all levels passed lower than $FAIL_ON_LEVEL"
exit 0