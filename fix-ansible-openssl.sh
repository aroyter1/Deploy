#!/bin/bash

set -e

echo "==> Удаляем старые версии Docker (если были)..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

echo "==> Обновляем индекс пакетов..."
sudo apt-get update

echo "==> Устанавливаем необходимые зависимости..."
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

echo "==> Добавляем официальный GPG-ключ Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

echo "==> Добавляем репозиторий Docker..."
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"

echo "==> Обновляем индекс пакетов (ещё раз)..."
sudo apt-get update

echo "==> Устанавливаем Docker Engine и компоненты..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

echo "==> Устанавливаем Docker Compose v2 (compose-plugin)..."
sudo apt-get install -y docker-compose-plugin

echo "==> Добавляем пользователя $USER в группу docker..."
sudo groupadd docker || true
sudo usermod -aG docker $USER

echo "==> Включаем и запускаем сервис Docker..."
sudo systemctl enable --now docker

echo "==> Проверяем версии..."
docker --version
docker compose version

echo "==> Всё готово! Перезайдите в систему или выполните 'newgrp docker' для применения прав."