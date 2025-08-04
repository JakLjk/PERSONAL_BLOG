FROM python:3.13-slim
RUN apt-get update && apt-get install -y \
    curl build-essential git && \
    pip install --upgrade pip

RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s /root/.local/bin/poetry /usr/local/bin/poetry

WORKDIR /app

COPY pyproject.toml poetry.lock README.md /app/

RUN poetry config virtualenvs.create false && \
    poetry install --no-root --no-interaction --no-ansi

COPY . /app

EXPOSE 8000

CMD ["poetry", "run", "gunicorn", "personal_blog.personal_blog.wsgi:application", "--bind", "0.0.0.0:8000"]