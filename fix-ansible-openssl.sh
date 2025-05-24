#!/bin/bash

set -e

echo "==> Удаляем старые версии Docker (если были)..."
sudo apt-get remove -y docker docker-engine docker.io containerd runc || true

echo "==> Обновляем индекс пакетов..."
sudo apt-get update

echo "==> Устанавливаем необходимые зависимости..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "==> Добавляем официальный GPG-ключ Docker..."
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "==> Добавляем репозиторий Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "==> Обновляем индекс пакетов (ещё раз)..."
sudo apt-get update

echo "==> Устанавливаем Docker Engine, CLI, containerd и compose-plugin..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "==> Добавляем пользователя $USER в группу docker..."
sudo usermod -aG docker $USER

echo "==> Включаем и запускаем сервис Docker..."
sudo systemctl enable --now docker

echo "==> Проверяем версии..."
docker --version
docker compose version

echo "==> Всё готово! Перезайдите в систему или выполните 'newgrp docker' для применения прав."