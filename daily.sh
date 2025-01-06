#!/bin/bash

# 設定
GARAGEBAND_DIR="/Users/kazuki/Music/GarageBand"
WHISPER_DIR="/Users/kazuki/Music/GarageBand/whisper_workspace"
TEXT_DIR="/Users/kazuki/Music/GarageBand/text"
TODAY=$(date "+%Y:%m:%d")

# textディレクトリが存在しない場合は作成
mkdir -p "$TEXT_DIR"

# 作業ディレクトリに移動
cd "$GARAGEBAND_DIR"

echo "=== 音声変換処理開始 ==="

# GarageBandファイルを探して処理
for band_dir in "$GARAGEBAND_DIR"/*"$TODAY"*.band; do
    if [ -e "$band_dir" ]; then
        echo "処理中: $band_dir"
        
        # プロジェクト名を取得（.bandを除去）
        project_name=$(basename "$band_dir" .band)
        echo "プロジェクト名: $project_name"
        
        # Audio Filesディレクトリ内の最初のWAVファイルを取得
        input_wav=$(find "$band_dir/Media/Audio Files" -name "*.wav" | head -n 1)
        
        if [ -n "$input_wav" ]; then
            # whisper_workspace直下のaudio.wavとして一時保存
            /opt/homebrew/bin/ffmpeg -i "$input_wav" \
                                     -ar 16000 \
                                     -ac 1 \
                                     -c:a pcm_s16le \
                                     "$WHISPER_DIR/audio.wav"
            
            if [ $? -eq 0 ]; then
                echo "音声変換完了: audio.wav"
                
                # Whisper処理の実行
                echo "=== Whisper処理開始 ==="
                cd "$WHISPER_DIR"
                python3 jtrance.py
                
                # 処理済みファイルの整理
                if [ -f "$WHISPER_DIR/audio.wav.txt" ]; then
                    # テキストファイルを適切な名前でtextディレクトリに移動
                    mv "$WHISPER_DIR/audio.wav.txt" "$TEXT_DIR/${project_name}.txt"
                    echo "=== 全処理完了 ==="
                    echo "生成ファイル:"
                    echo "- $TEXT_DIR/${project_name}.txt"
                    
                    # 一時ファイルの削除
                    rm "$WHISPER_DIR/audio.wav"
                else
                    echo "エラー: Whisper処理の出力ファイルが見つかりません"
                fi
            else
                echo "エラー: 音声変換に失敗しました"
            fi
        else
            echo "WAVファイルが見つかりません: $band_dir/Media/Audio Files"
        fi
    else
        echo "本日の日付($TODAY)のGarageBandプロジェクトが見つかりません"
    fi
done