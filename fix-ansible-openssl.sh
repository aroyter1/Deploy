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

echo "==> Создаём директорию для ключей, если не существует..."
sudo install -m 0755 -d /etc/apt/keyrings

echo "==> Скачиваем и добавляем официальный GPG-ключ Docker..."
sudo rm -f /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "==> Исправляем права на ключ docker.gpg..."
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "==> Удаляем все старые и конфликтующие записи репозитория Docker..."
sudo grep -lr 'download.docker.com' /etc/apt/sources.list /etc/apt/sources.list.d/ | while read file; do
    echo "    Чистим $file"
    sudo sed -i '/download.docker.com/d' "$file"
done

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