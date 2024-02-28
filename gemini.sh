#!/bin/bash

# Run this from the directory in which you saved your input images
# This script was written to run on Debian Linux. It may require updates
# to run on other platforms

# Test that the first image is present
#if [ ! -f "image0.jpeg" ]; then
#  echo "Could not find images in the current directory." >&2
#  exit 1
#fi

#API_KEY="YOUR_API_KEY"

function req {
  curl \
    -s \
    -X POST https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro-vision-latest:generateContent?key=${API_KEY} \
    -H 'Content-Type: application/json' \
    -d @<(echo '{
    "contents": [
      {
        "parts": [
          {
            "text": "定点カメラから撮影した富士山の見え方について教えてください\n\n返答は以下の2つから選択してください。\n- 富士山は見える\n- 富士山は見えない\n\n\n"
          },
          {
            "inlineData": {
              "mimeType": "image/jpeg",
              "data": "'$(base64 -w0 samples/image0.jpeg)'"
            }
          },
          {
            "text": "\n富士山は見える\n"
          },
          {
            "inlineData": {
              "mimeType": "image/jpeg",
              "data": "'$(base64 -w0 samples/image1.jpeg)'"
            }
          },
          {
            "text": "\n富士山は見える\n"
          },
          {
            "inlineData": {
              "mimeType": "image/jpeg",
              "data": "'$(base64 -w0 samples/image2.jpeg)'"
            }
          },
          {
            "text": "\n富士山は見える\n"
          },
          {
            "inlineData": {
              "mimeType": "image/jpeg",
              "data": "'$(base64 -w0 samples/image3.jpeg)'"
            }
          },
          {
            "text": "\n富士山は見えない\n"
          },
          {
            "inlineData": {
              "mimeType": "image/jpeg",
              "data": "'$(base64 -w0 samples/image4.jpeg)'"
            }
          },
          {
            "text": "\n富士山は見える\n"
          },
          {
            "inlineData": {
              "mimeType": "image/jpeg",
              "data": "'$(base64 -w0 images/"${1}".jpeg)'"
            }
          }
        ]
      }
    ],
    "generationConfig": {
      "temperature": 0.2,
      "topK": 1,
      "topP": 0,
      "maxOutputTokens": 4096,
      "stopSequences": []
    },
    "safetySettings": [
      {
        "category": "HARM_CATEGORY_HARASSMENT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
      },
      {
        "category": "HARM_CATEGORY_HATE_SPEECH",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
      },
      {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
      },
      {
        "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
        "threshold": "BLOCK_MEDIUM_AND_ABOVE"
      }
    ]
  }') | jq -r '.candidates[0].content.parts[0].text'
}

function row {
  local DATE_YYYY="${1}"
  local DATE_MM="${2}"
  local DATE_DD="${3}"
  #local IMAGE_URL="https://www.pref.shizuoka.jp/~live/archive/${DATE_YYYY}${DATE_MM}${DATE_DD}gotenba/09/l.jpg"
  local IMAGE_FILE="${DATE_YYYY}${DATE_MM}${DATE_DD}"
  local PAGE_URL="https://www.pref.shizuoka.jp/fujisanview/365.html?date=${DATE_YYYY}${DATE_MM}${DATE_DD}gotenba"

  echo "| ${DATE_YYYY}-${DATE_MM}-${DATE_DD} | ![](../images/${IMAGE_FILE}.jpeg) | $(req "${IMAGE_FILE}" | tr "\n" " ") | ${PAGE_URL} |"
}

#START_DATE="2023/03/01"
START_DATE="${1}"

cat <<EOF
- 写真の出典: 静岡県([ライブカメラ富士山ビューについて｜静岡県公式ホームページ](https://www.pref.shizuoka.jp/fujisanview/1044916.html))
- クリエイティブ・コモンズ 表示-非営利 4.0 国際: https://creativecommons.org/licenses/by-nc/4.0/deed.ja
---
EOF
echo "| Date | Image | Answer | Page |"
echo "| --- | --- | --- | --- |"
for d in $(seq 0 "$((${2} - 1))"); do
  row  \
    "$(date -d "${START_DATE} + $d days" +%Y)" \
    "$(date -d "${START_DATE} + $d days" +%m)" \
    "$(date -d "${START_DATE} + $d days" +%d)"
  sleep 1
done