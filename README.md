# Seen It Before

Keep tracks of the videos files you've seen with vlc.

## Usage:
`sib file`

> use `ctl-c` to stop vlc and `mv` the file.

Runs vlc in a tmux in `http` interface and keep running, waiting to be shut down with `ctrl-c`.

Before shuting down, call `http://:${USER}@localhost:9090/requests/status.xml` vlc endpoints and get current position (time).
If > 95%, consider the video as fully watch, stop vlc and the tmux, rename the file and the subtitles (if exists) with a `.` before,
making the files hidden.

> currently, `sib` will look for `[filename].srt`, `[filename].en.srt` and `[filename].fr.srt` subtitle file only.

## Dependencies:
 - `curl`  
 - `tmux`  
 - `vlc`