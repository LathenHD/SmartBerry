from flask import Flask, request
import subprocess

app = Flask(__name__)

@app.route('/launch-vlc', methods=['POST'])
def launch_vlc():
    subprocess.Popen(['/home/pi/launch_vlc_stream.sh'])
    return 'VLC launched', 200

@app.route('/start-magicmirror', methods=['POST'])
def start_magicmirror():
    subprocess.Popen(['bash', '-c', 'cd ~/MagicMirror && npm run start &'])
    return 'MagicMirror started', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
