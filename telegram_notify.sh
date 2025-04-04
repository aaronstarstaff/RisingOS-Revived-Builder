#!/bin/bash

# Required parameters:
# $1: Message to send
# $2: Bot token
# $3: Chat ID
# $4 (optional): Thread ID
# $5 (optional): Username
# $6 (optional): Emoji

MESSAGE="$1"
BOT_TOKEN="$2"
CHAT_ID="$3"
THREAD_ID="$4"
USERNAME="$5"
EMOJI="$6"


if [ -z "$MESSAGE" ] || [ -z "$BOT_TOKEN" ] || [ -z "$CHAT_ID" ]; then
    echo "Error: Missing message, bot token, or chat ID."
    exit 1
fi

if [ -n "$EMOJI" ]; then
    MESSAGE="$EMOJI $MESSAGE"
fi

if [ -n "$USERNAME" ]; then
    MESSAGE="$MESSAGE (Triggered by: $USERNAME)"
fi

curl_command="curl -s -X POST \"https://api.telegram.org/bot$BOT_TOKEN/sendMessage\" -d chat_id=\"$CHAT_ID\" -d text=\"$MESSAGE\""

if [ -n "$THREAD_ID" ]; then
    curl_command="$curl_command -d message_thread_id=\"$THREAD_ID\""
fi

eval "$curl_command"

