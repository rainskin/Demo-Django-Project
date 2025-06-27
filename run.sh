#!/bin/bash

# Имя твоего проекта. Это будет префиксом для имен контейнеров и образа Django.
PROJECT_NAME=my_django_project # Замени на желаемое имя своего проекта!

# Экспортируем переменную, чтобы она была доступна для docker-compose
export PROJECT_NAME

echo "Остановка и удаление предыдущих контейнеров, сетей и образов..."
# --rmi all удаляет все образы, созданные docker-compose
docker-compose down --rmi all

echo "Сборка Docker образов..."
docker-compose build

echo "Запуск контейнеров..."
# -d запускает контейнеры в фоновом режиме (detached mode)
docker-compose up -d

# *** Важно: Команда для применения миграций Django полностью удалена,
# так как мы используем Django с дефолтной SQLite базой данных для стартового шаблона,
# и она не требует явных миграций на этом этапе. ***

echo "Сбор статических файлов Django..."
# Собираем статические файлы внутри контейнера web
# Используем 'poetry run' для выполнения команд внутри Poetry-окружения
docker exec ${PROJECT_NAME} poetry run python manage.py collectstatic --noinput

echo "Запуск завершен! Ваш проект должен быть доступен."
echo "Имя контейнера Django: ${PROJECT_NAME}"
echo "Имя контейнера Nginx: ${PROJECT_NAME}_nginx"