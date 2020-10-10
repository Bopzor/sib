#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "This script need a video file to read"
	  echo -e "\nUsage:\nsib FILE \n"

    exit 1
fi

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

SIB_SESSION="sib-session"

file="$1"
dirname=$(dirname "$file")
filename=$(basename "$file")
name="${filename%.*}"
pathname="$PWD/$dirname"

echo "Curently watching $name..."

function ctrl_c() {
  output=$(curl -s "http://:${USER}@localhost:9090/requests/status.xml" | grep position)

  regex="[0-1].[0-9]*"

  [[ "$output" =~ $regex ]]
  position="${BASH_REMATCH[0]}"

  tmux kill-session -t "$SIB_SESSION"

  if [[ "$position" > 0.95 ]]
    then
      mv "$pathname/$filename" "$pathname/.$filename"

      for lang in '' '.fr' '.en'
        do
          if [[ -f "$pathname/$name${lang}.srt" ]]
            then
              mv "$pathname/$name${lang}.srt" "$pathname/.$name${lang}.srt"
            fi
        done
  else
    echo -e "\n$name hasn't been fully watched"
  fi


  exit "$?"
}

tmux new-session -d -s "$SIB_SESSION" vlc --extraintf http --http-password "$USER" --http-host localhost --http-port 9090 "$file"

# keep script running until ctrl-c
read -r -d '' _ </dev/tty
