# Используем базовый образ Python 3.11
FROM python:3.11-slim-buster

# Устанавливаем рабочую директорию в контейнере
WORKDIR /app

# Отключаем буферизацию вывода Python для лучшего логирования
ENV PYTHONUNBUFFERED 1


# Устанавливаем Poetry
RUN pip install poetry --no-cache-dir

# Копируем файлы проекта, необходимые для установки зависимостей Poetry
COPY pyproject.toml poetry.lock /app/

# Устанавливаем зависимости Poetry
# --no-root означает, что Poetry не будет устанавливать сам проект как пакет
RUN poetry install --no-root

# Копируем весь остальной код проекта в контейнер
COPY . /app/

## Открываем порт, который будет использовать Gunicorn
#EXPOSE 8000

# Команда для запуска Gunicorn
# Предполагается, что твой Django проект называется 'myproject',
# а wsgi.py находится в 'myproject/wsgi.py'.
# Замени 'myproject.wsgi:application' на путь к твоему wsgi.py,
# например, 'ваше_имя_проекта.wsgi:application'
CMD ["poetry", "run", "gunicorn", "--bind", "0.0.0.0:8000", "core.wsgi:application"]