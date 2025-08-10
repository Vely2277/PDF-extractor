from flask import Flask, request, jsonify
from pdfminer.high_level import extract_text
from pdf2image import convert_from_path
import pytesseract
import tempfile
import os

app = Flask(__name__)

@app.route('/extract', methods=['POST'])
def extract_pdf():
    if 'file' not in request.files:
        return jsonify({'error': 'No file uploaded'}), 400
    file = request.files['file']
    if not file.filename.lower().endswith('.pdf'):
        return jsonify({'error': 'Only PDF files are supported'}), 400
    with tempfile.NamedTemporaryFile(delete=False, suffix='.pdf') as tmp:
        file.save(tmp.name)
        # Try text extraction first
        text = extract_text(tmp.name)
        if not text.strip():
            # If no text found, try OCR
            images = convert_from_path(tmp.name)
            ocr_text = ""
            for image in images:
                ocr_text += pytesseract.image_to_string(image)
            text = ocr_text
        os.unlink(tmp.name)
    return jsonify({'text': text})

@app.route('/')
def home():
    return 'PDF Extraction API is running.'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
