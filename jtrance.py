import subprocess
import os

WORK_DIR = "/Users/kazuki/Music/GarageBand/whisper_workspace"
AUDIO_FILE = "audio.wav"
MODEL_PATH = "/Users/kazuki/whisper.cpp/models/ggml-medium.bin"
OUTPUT_FILE = "transcription.txt"

def transcribe_audio():
    try:
        command = [
            "/Users/kazuki/whisper.cpp/build/bin/whisper-cli",  # mainからwhisper-cliに変更
            "-m", MODEL_PATH,
            "-f", os.path.join(WORK_DIR, AUDIO_FILE),
            "-l", "ja",
            "-otxt"
        ]

        result = subprocess.run(
            command,
            capture_output=True,
            text=True,
            cwd=WORK_DIR,
            encoding='utf-8'
        )

        if result.returncode != 0:
            print(f"エラーが発生しました: {result.stderr}")
            return

        print("書き起こし完了")

    except Exception as e:
        print(f"予期しないエラーが発生しました: {e}")


transcribe_audio()