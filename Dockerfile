FROM python:3.8.3-slim-buster

WORKDIR /app

RUN pip install psycopg2-binary
# Copia o arquivo requirements.txt e instala as dependências
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Instala o OpenTelemetry e suas dependências
RUN pip install opentelemetry-distro[otlp]
RUN opentelemetry-bootstrap -a install

# Copia o código da aplicação
COPY . .

# Define o comando para iniciar a aplicação com a instrumentação
CMD ["opentelemetry-instrument", "--traces_exporter", "console", "--service_name", "flask_app", "python", "app.py"]

