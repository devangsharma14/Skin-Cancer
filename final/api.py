# -*- coding: utf-8 -*-
"""
Created on Sat Mar 27 11:23:31 2021

@author: Devang
"""
import os

import torch

from flask import Flask, render_template, request, redirect, send_file, url_for, jsonify

from support import get_filename, download_file, load_input_image, predict_skin_cancer, set_parameter_requires_grad, initialize_model

app = Flask(__name__)
UPLOAD_FOLDER = "uploads"
BUCKET = "flasks3inttest"

@app.route('/')
def entry_point():
    return 'API'

@app.route("/testapi", methods=['GET'])
def testing():
    file_name = get_filename(BUCKET)
    output = download_file(file_name, BUCKET)
    
    model_ft, input_size = initialize_model("inception", 2, False, use_pretrained=True)

    class_names = ['Benign', 'Malignant']
    
    model_ft.load_state_dict(torch.load('models/modelsgd.pt', map_location=torch.device('cpu')))
    
    #print(file_name)
    img_path = "downloads/"+file_name
    #print(img_path)
    
    prediction=predict_skin_cancer(model_ft, class_names, img_path)
    
    return jsonify({'test': {"result": prediction}})

if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)