import os
import requests
import schedule
import time
from datetime import datetime

# Directory to save images
SAVE_DIR = 'images'

headers = {
    'User-Agent':
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:126.0) Gecko/20100101 Firefox/126.0',
    'Accept': 'image/avif,image/webp,*/*',
    'Accept-Language': 'en,th;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'DNT': '1',
    'Referer': 'http://www.bmatraffic.com/PlayVideo.aspx?ID=413',
    'Connection': 'keep-alive',
    'Priority': 'u=4'
}


def main():
    if not os.path.exists(SAVE_DIR):
        os.makedirs(SAVE_DIR)

    request_no = 0

    while True:
        url = "http://www.bmatraffic.com/show.aspx?image=413&&time=" + str(
            int(time.time()))

        try:
            if request_no % 3500 == 0:
                s = requests.Session()
                s.headers.update(headers)
                response = s.get(
                    "http://www.bmatraffic.com/PlayVideo.aspx?ID=413")

            request_no = request_no + 1
            print(s.headers)
            response = s.get(url)
            response.raise_for_status()
            timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
            filename = f"image_{timestamp}.jpg"
            filepath = os.path.join(SAVE_DIR, filename)
            with open(filepath, "wb") as file:
                file.write(response.content)
            print(f"Saved {filename}")
        except requests.exceptions.RequestException as e:
            print(f"Error fetching image: {e}")

        time.sleep(1)


main()
