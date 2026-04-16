while [[ $# -gt 0 ]]; do
  case "${1}" in
    --session-name)
      SESSION_NAME="${2}"
      shift
      shift
      ;;
    --working-directory)
      WORKING_DIRECTORY="${2}"
      shift
      shift
      ;;
    --width)
      WIDTH="${2}"
      shift
      shift
      ;;
    --height)
      HEIGHT="${2}"
      shift
      shift
      ;;
    --*)
      echo "Unknown option ${1}"
      exit 1
      ;;
  esac
done

CURRENT_SESSION_NAME="$(tmux display-message -p -F "#{session_name}")"

if [ -z "${SESSION_NAME}" ]; then
  # Ensure scratch is only ever appended once
  SESSION_NAME="${CURRENT_SESSION_NAME/-scratch/}-scratch"
fi

if [ "${CURRENT_SESSION_NAME}" = "${SESSION_NAME}" ]; then
  tmux detach-client
else
  tmux display-popup \
    -d "${WORKING_DIRECTORY:-"#{pane_current_path}"}" \
    -x C \
    -y C \
    -w "${WIDTH:-80%}" \
    -h "${HEIGHT:-80%}" \
    -E "tmux attach -t ${SESSION_NAME} || tmux new -s ${SESSION_NAME}"
fi
