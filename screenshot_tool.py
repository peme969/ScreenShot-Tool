import os
import time
import webbrowser
import pyautogui
from PIL import ImageGrab
import io
import win32clipboard
from pathlib import Path

# 1. Setup screenshot directory
screenshot_dir = Path.home() / "Pictures" / "Screenshots"
screenshot_dir.mkdir(parents=True, exist_ok=True)
timestamp = time.strftime("%Y%m%d_%H%M%S")
filepath = screenshot_dir / f"chatgpt_clip_{timestamp}.png"

# 2. Take screenshot interactively
print("Select your screenshot area...")
image = pyautogui.screenshot(region=pyautogui.selectRegion())
image.save(filepath)

# 3. Copy to clipboard
def send_to_clipboard(image):
    output = io.BytesIO()
    image.convert("RGB").save(output, "BMP")
    data = output.getvalue()[14:]
    output.close()

    win32clipboard.OpenClipboard()
    win32clipboard.EmptyClipboard()
    win32clipboard.SetClipboardData(win32clipboard.CF_DIB, data)
    win32clipboard.CloseClipboard()

send_to_clipboard(image)

# 4. Open ChatGPT in browser
webbrowser.open("https://chat.openai.com/")

# 5. Wait for the page to load
time.sleep(7)

# 6. Paste and press Enter
pyautogui.hotkey("ctrl", "v")
time.sleep(0.5)
pyautogui.press("enter")
