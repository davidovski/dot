#!/bin/sh
#title           :rofi-mpd-search.sh
#description     :Search and play or add music in MPD
#author          :Christian Dannie Storgaard (Cybolic)
#date            :20250527
#version         :0.3
#usage           :play-music-mpd.sh [track]
#requires        :rofi, awk, mpc
#bash_version    :5.2.37(1)-release
#license         :GPL3
#==============================================================================

COLOR_ARTIST="#9089FF"
COLOR_ALBUM="#6E8FFF"

# placeholder for rofi-themed
rofi-themed () {
    rofi "$@"
      #-theme ${inputs.rofi-themes-newmanls}/themes/rounded-purple-dark.rasi \
      #-theme-str '* { bg3: #43069af2; }' \
      #"$@"

}

# Reformat a list of items into a 4-tab-separated list of artist and item.
# Since mpc shows its grouping by indentation, we use that to first detect artist lines (no indentation)
# and then the indented item lines below as the items for that artist.
item-list-to-artist-item-list() {
  awk '
  /^[^ ]/ { artist = $0 }
  /^[ \t]/ { 
      gsub(/^[ \t]+/, "")
      print artist "\t\t\t\t" $0
  }
  '
}
# Reformat a list of items into a 4-tab-separated list of artist, album, and item.
# Similar to item-list-to-artist-item-list, but here we also detect album lines (3-4 spaces indentation)
item-list-to-artist-album-item-list() {
  awk  '
  /^[^ ]/ { 
    artist = $0
    album = ""
  }
  /^[ ]{4}[^ \t]/ {
    match($0, /^([ \t]*)/)
    album = substr($0, RLENGTH + 1)
  }
  /^[ ]{8}/ { 
    gsub(/^[ \t]+/, "")
    print artist "\t\t\t\t" album "\t\t\t\t" $0
  }
  '
}
# Reformat a 4-tab-separated list of artist, album (if any), and item into a rofi-friendly markup list.
artist-item-list-to-rofi-list() {
  awk -F'\t\t\t\t' '
  function html_escape(str) {
    gsub(/&/, "\\&amp;", str)
    gsub(/</, "\\&lt;", str)
    gsub(/>/, "\\&gt;", str)
    gsub(/"/, "\\&quot;", str)
    gsub(/'"'"'/, "\\&#39;", str)
    return str
  }
  {
    artist = $1
    if (NF == 3) {
      album = $2
      item = $3
      print "<span color=\"'"$COLOR_ARTIST"'\">" html_escape(artist) "</span>  ⟩  <span color=\"'"$COLOR_ALBUM"'\">" html_escape(album) "</span>  " html_escape(item)
    } else {
      item = $2
      print "<span color=\"'"$COLOR_ARTIST"'\">" html_escape(artist) "</span>\t" html_escape(item)
    }
  }
  '
}

# Open rofi with a given prompt and width, returning the selected line number.
select-w-rofi() {
  item=$1
  width=${2:-50em}
  artist-item-list-to-rofi-list | \
    rofi-themed -kb-custom-1 'Alt+a' -dmenu -l 25 -markup-rows -format d -no-custom -i -p "Select ${item} to play" -theme-str "window {width: ${width};}"
}

main() {
  local items
  local artist item
  local queue_count
  local mode
  local selection_index selection
  local search_text
  mode="play"

  if [[ "$1" == "track" ]]; then
    # Get list of tracks with albumartist grouping and remove empty lines
    items=$(mpc list title group album group albumartist | awk '!/^[[:space:]]*$/' | item-list-to-artist-album-item-list)
    selection_index=$(echo "$items" | select-w-rofi "a track" '60em')
  else
    # Get list of albums with albumartist grouping and remove empty lines
    items=$(mpc list album group albumartist | awk '!/^[[:space:]]*$/' | item-list-to-artist-item-list)
    selection_index=$(echo "$items" | select-w-rofi "an album" '50em')
  fi
  return_code=$?
  if [[ $return_code -eq 10 ]]; then
    mode="add"
  elif [[ $return_code -ne 0 ]]; then
    exit 0
  fi

  # Get the selected line
  selection=$(echo "$items" | sed -n "${selection_index}p") || exit 0
  # Get artist, album (if any), and item from the selected line
  artist=$(echo "$selection" | awk -F'\t\t\t\t' '{print $1}') || exit 0
  # Get the current number of items in the MPD queue
  queue_count=$(mpc playlist | wc -l)
  # Pre-define the search text for the artist (just to make the next search text construction more readable)
  # ("AlbumArtist" falls back to "Artist" if empty, so it works well for both albums and tracks)
  search_text='((AlbumArtist == '\'"${artist//\'/\'\\\'\'}"\'')'
  # Construct the full search text
  if [[ "$1" == "track" ]]; then
    album=$(echo "$selection" | awk -F'\t\t\t\t' '{print $2}') || exit 0
    item=$(echo "$selection" | awk -F'\t\t\t\t' '{print $3}') || exit 0
    if [[ "$album" == "" ]]; then
      search_text="${search_text}"' AND (Title == '\'"${item//\'/\'\\\'\'}"\''))'
    else
      search_text="${search_text}"' AND (Album == '\'"${album//\'/\'\\\'\'}"\'') AND (Title == '\'"${item//\'/\'\\\'\'}"\''))'
    fi
  else
    album=$(echo "$selection" | awk -F'\t\t\t\t' '{print $2}') || exit 0
    search_text="${search_text}"' AND (Album == '\'"${album//\'/\'\\\'\'}"\''))'
  fi
  # Find and add the item(s) and insert
  mpc insert "$(mpc find "$search_text")"

  # If instructed to play, start playing the queue from the newly added item index
  #if [[ "$mode" == "play" ]]; then
  #  mpc play "$(( queue_count + 1 ))"
  #fi
}

main "$@"
