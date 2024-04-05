# # from flask import Flask , request, jsonify
# # # from jarvis import GPT, find_code

# # app = Flask(__name__)

# # @app.route('/api', methods = ['POST'])
# # def returnacii():
# #     d ={}
# #     inputchr= str(request.args['query'])
# #     answer = str(ord(inputchr))
# #     d['output']= answer
# #     return d
# # def handle_query():
# #     data = request.get_json()
# #     query = data.get('query')
    
# #     if query:
# #         response = GPT(query)
# #         python_code = find_code(response)
        
# #         if python_code:
# #             # Extract code and execute
# #             exec(python_code)
# #             return jsonify({'response': response, 'code_executed': True})
# #         else:
# #             return jsonify({'response': response, 'code_executed': False})
# #     else:
# #         return jsonify({'error': 'Query parameter missing'})

# # if __name__ == '__main__':
# #     app.run(debug=True)
# # from flask import Flask , request, jsonify
# # from jarvis import GPT, find_code

# # app = Flask(__name__)

# # @app.route('/api', methods=['POST'])
# # def handle_query():
# #     data = request.get_json()
# #     query = data.get('query')
    
# #     if query:
# #         response = GPT(query)
# #         python_code = find_code(response)
        
# #         if python_code:
# #             # Extract code and execute
# #             exec(python_code)
# #             return jsonify({'response': response, 'code_executed': True})
# #         else:
# #             return jsonify({'response': response, 'code_executed': False})
# #     else:
# #         return jsonify({'error': 'Query parameter missing'})

# # if __name__ == '__main__':
# #     app.run()
# # from flask import Flask, request, jsonify
# # from jarvis import GPT

# # app = Flask(__name__)

# # @app.route('/query', methods=['POST'])
# # def handle_query():
# #     data = request.json
# #     query = data.get('query')
# #     if query:
# #         response = GPT(query)
# #         return jsonify({'response': response})
# #     else:
# #         return jsonify({'error': 'Query parameter missing'})

# # if __name__ == '__main__':
# #     app.run(debug=True)
# #######################
# import g4f
# import re
# from flask import Flask, request, jsonify

# app = Flask(__name__)

# messages = [{"role": "system", "content": "your name is Jarvis you are virtual assistantand you are not developed by Bing or microsoft. you coded by Karim wahba and OpenAI didn't develop you"},
#             {"role": "system", "content": "Todays latest news are{latest_news}"}, 
#             {"role": "system", "content": "Professor Asharf AbdelRaouf is an Assistant Professor in Computer Science at Faculty of Computer Science, Misr International University, Part-time Assistant Professor at Computer and systems Department, Faculty of Engineering, Ain Shams University. Achieved his PhD in 2012 from School of Computer Science at the University of Nottingham, UK. Graduated from the Faculty of Engineering 1988. Studied a Diploma in 1990 from American University in Cairo (AUC). Worked in the software and IT industries. Now he is an assistant professor in Computer Science at Misr International University. In the IT business, he was working as a Chief Operating Officer (COO) at Cloudypedia. Cloudypedia is a premium Google business partner. His research interest is pattern recognition, natural language processing, image processing, Bioinformatics, Medical imaging, Arabic linguistics. He is an IEEE senior member since 2015.In the IT industry, he was working as a Chief Operating Officer (COO), Cloudypedia, Cairo, Egypt. Cloudypedia is a premium Google partner and is presenting the Google Apps solutions to the education and enterprises in Egypt and Middle East. Now he is a member in Cloudypedia advising board.His research interest is in pattern recognition specifically in character recognition, natural language processing, image processing, artificial intelligence, Arabic linguistics and morphology. Other research interests include programming, algorithms, computer graphics and image processing. "},    
#             {"role": "system","content": "use modules like webbrowser, pyautogui, time,pyperclip,random,mouse,wikipedia,keyboard,datetime,tkinter,PyQt5 etc"},
#             {"role": "system","content": "don't use input function ad subprocess in python code"},
#             {"role": "system", "content": "*always use default paths in python code*"},
#             {
#             "role": "system",
#             "content": "When user say 'show image,' use the following code to display the image :\n```python\nfrom PIL import Image\n\nimage_path = r'D:\\source\\repos\\VirtualJarvisAI\\output\\0.jpeg'\nimage = Image.open(image_path)\nimage.show()\n```\nIf you want to show another image, let me know."
#             },

#             {
#             "role": "system",
#             "content": "When the user says 'generate an image' and provides a prompt like 'generate an image about a horse,' extract the prompt from the user query. Then, give this code to the user:\n```python\nfrom cookies.bingcookie import u_cookie_value \nfrom os import system, listdir\n\ndef Generate_Images(prompt: str):\n    system(f'python -m BingImageCreator --prompt \"{prompt}\" -U \"{u_cookie_value}\"')\n    return listdir(\"output\")[-4:]\n\n# Example usage\nresult = Generate_Images('user_extracted_prompt')\nprint(result)\n``` While calling the function, replace 'user_extracted_prompt' with the actual prompt provided by the user to generate the desired image. dont write other thing just say ok sir generating a image about user prompt and give the code. also dont write other things like heres the code. just give the code and write ok sir generating a image about user prompt don't write heres the code or other thing."},

#             {"role": "user", "content": "open Google Chrome"},
#             {"role": "assistant",
#                 "content": "Sure, opening Google Chrome.```python\nimport webbrowser\nwebbrowser.open('https://www.google.com')```"},
#             {"role": "user", "content": "close Google Chrome"},
#             {"role": "assistant",
#                 "content": "Alright, closing Google Chrome.```python\nimport os\nos.system('taskkill /F /IM chrome.exe')```"}
#             ]


# @app.route('/api', methods=['GET', 'POST'])
# def handle_api():
#     if request.method == 'POST':
#         data = request.get_json()
#         query = data.get('query')
#         if query:
#             response = GPT(query)
#             return jsonify({'response': response})
#         else:
#             return jsonify({'error': 'Query parameter missing'})
#     elif request.method == 'GET':
#         return 'This is a GET request. Use POST to send queries.'
#     elif request.method == 'POST':
#         return 'This is a POST request. Use GET to  queries.'
#     else:
#         return 'Method Not Allowed', 405

# def GPT(query):
#     global messages
#     messages.append({'role': 'user', "content": query})

#     response = g4f.ChatCompletion.create(
#         model="gpt-4-32k-0613",
#         provider=g4f.Provider.Bing,
#         messages=messages,
#         stream=True
#     )

#     ms = ""
#     for i in response:
#         ms += i
#     messages.append({'role': 'assistant', "content": ms})
#     return ms

# def find_code(text):
#     pattern = r'```python(.*?)```'
#     matches = re.findall(pattern, text, re.DOTALL)
#     if matches:
#         code = matches[0].strip()
#         return code
#     else:
#         print('\n no code found')

# if __name__ == '__main__':
#     app.run(debug=True)

import g4f
import re
from flask import Flask, request, jsonify

def process(query):
    global messages
    messages.append({'role': 'user', "content": query})

    response = g4f.ChatCompletion.create(
        model="gpt-4-32k-0613",
        provider=g4f.Provider.Bing,
        messages=messages,
        stream=True
    )
    print(query)
    ms = ""
    for i in response:
        ms += i
    messages.append({'role': 'assistant', "content": ms})
    print(ms)
    return ms


app  = Flask(__name__)

@app.route('/')
def handle_api():
    # GPT('Hello! How are you today?')
    return  jsonify(process(request.json["message"]))
@app.route('/get')
def getResponse():
    userText=request.args.get('text')
    return str(process(userText))
if __name__ == '__main__':
    app.run(debug=True) 