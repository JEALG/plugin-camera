#!/bin/sh

#[ $# -eq 0 ] &amp;&amp; { echo "Usage: $0 rtsp://... &lt;name&gt;"; exit 1; }

SOURCE="$1"
DEST="$2"
NAME=${2:-cctv}
#ARCHIVE=${ARCHIVE:-archive}

HLS_TIME=${HLS_TIME:-5}
HLS_LIST_SIZE=${HLS_LIST_SIZE:-5}

ffmpeg -i "$SOURCE" \
        -f hls \
        -vsync 0 -copyts -vcodec copy -acodec copy \
        -tune zerolatency \
        -movflags frag_keyframe+empty_moov \
        -hls_flags delete_segments+append_list \
        -hls_init_time 1 \
        -hls_time $HLS_TIME \
        -hls_list_size $HLS_LIST_SIZE \
        -hls_base_url "../data/segments/" \
        -hls_segment_filename "../data/segments/$NAME-%d.ts" \
        "$NAME.m3u8"