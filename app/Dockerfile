FROM python:3-slim-buster

WORKDIR /flask_app

COPY requirements.txt ./
RUN pip install -r requirements.txt

COPY app.py ./

CMD ["sh", "-c", "python app.py"]
