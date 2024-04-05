# import subprocess
# import pygame
# import io

# def speak(text):
#     voice="en-us-GuyNeural"
#     command=f'edge-tts --voice "{voice}" --text "{text}" --rate=+30%'
    
#     try:
#         audio_data=subprocess.check_output(command, shell=True)

#         pygame.init()
#         pygame.mixer.init()

#         audio_buffer =io.BytesIO(audio_data)

#         pygame.mixer.music.load(audio_buffer)

#         pygame.mixer.music.play()
#         while pygame.mixer.music.get_busy():
#             pygame.time.Clock().tick(10)

#     except subprocess.CalledProcessError as e:
#         print(f"Error running command: {e}")
#     finally:
#         pygame.mixer.music.stop()
#         pygame.mixer.quit()

################################
import pyttsx3
import subprocess
import pygame
import io
engine = pyttsx3.init()
    # Set the default rate (adjust as needed)
engine.setProperty('rate', 230)

    # Set the default volume (0.0 to 1.0)
engine.setProperty('volume', 1.0)
def speak(text):
    engine.say(text)
    engine.runAndWait()

# text_to_speak = "Hello, this is a test. Adjusting the rate for a more human-like voice."
# speak(text_to_speak)

# import pyttsx3

# engine = pyttsx3.init()

# def speak(text, voice='en-us', rate_multiplier=1.3):
#     # Set the voice
#     engine.setProperty('voice', f'{voice}')

#     # Set the rate
#     rate = engine.getProperty('rate')
#     engine.setProperty('rate', int(rate * rate_multiplier))

#     # Speak the text
#     engine.say(text)
#     engine.runAndWait()


######################################
# import pygame
# import io
# def speak (text):
#     voice = "en-US-GuyNeural"

#     command = f'edge-tts --voice "{voice}" --text "{text}" --rate=+30'

#     try:
#         # Run the command and capture the output
#         audio_data = subprocess.check_output (command, shell=True)

#         pygame.init()
#         pygame.mixer.init()

#         # Use io.Bytes IO to create an in-memory buffer
#         audio_buffer= io.BytesI0(audio_data)

#         pygame.mixer.music.load(audio_buffer)

#         pygame.mixer.music.play()

#         while pygame.mixer.music.get_busy():
#             pygame.time.clock().tick(10)


#     except subprocess.CalledProcessError as e:
#         print (f"Error running command: {e}")

#     except Exception as e:
#         print (f"Error: {e}")

#     finally:
#         pygame.mixer.music.stop()
#         pygame.mixer.quit()
# import pyttsx3
# import pygame
# import io
# import wave
# import os

# def speak(text):
#     # Create a TTS engine
#     engine = pyttsx3.init()

#     # Set the default rate (adjust as needed)
#     engine.setProperty('rate', 230)

#     # Set the default volume (0.0 to 1.0)
#     engine.setProperty('volume', 1.0)

#     # Use StringIO to capture the audio
#     audio_stream = io.BytesIO()

#     # Set up a callback function to capture the audio
#     def callback(data):
#         audio_stream.write(data)

#     engine.connect('finished-utterance', callback)

#     # Speak the text
#     engine.say(text)
#     engine.runAndWait()

#     # Save the audio stream to a temporary WAV file
#     temp_wav_file = "temp_audio.wav"
#     with wave.open(temp_wav_file, "wb") as wave_file:
#         wave_file.setnchannels(1)  # Mono audio
#         wave_file.setsampwidth(2)  # 16-bit
#         wave_file.setframerate(44100)  # Standard sample rate
#         wave_file.writeframes(audio_stream.getvalue())

#     # Play the WAV file using pygame
#     pygame.mixer.init()
#     pygame.mixer.music.load(temp_wav_file)
#     pygame.mixer.music.play()

#     # Wait for the audio to finish playing
#     while pygame.mixer.music.get_busy():
#         pygame.time.Clock().tick(10)

#     # Clean up temporary WAV file
#     os.remove(temp_wav_file)

# # Example usage:
# text_to_speak = "Hello, this is a test. Adjusting the rate for a more human-like voice."
# speak(text_to_speak)

