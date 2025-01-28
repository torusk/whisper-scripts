import subprocess
import os
from dotenv import load_dotenv

load_dotenv()

WORK_DIR = os.getenv("WHISPER_DIR")
MODEL_PATH = os.getenv("MODEL_PATH")
WHISPER_CLI_PATH = os.getenv("WHISPER_CLI_PATH")

def transcribe_audio():
    command = [
        WHISPER_CLI_PATH,
        "-m", MODEL_PATH,
        "-f", os.path.join(WORK_DIR, "audio.wav"),
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
