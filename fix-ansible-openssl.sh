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
    lsb-release

echo "==> Создаём директорию для ключей, если не существует..."
sudo mkdir -p /usr/share/keyrings

echo "==> Скачиваем и добавляем официальный GPG-ключ Docker..."
sudo rm -f /usr/share/keyrings/docker-archive-keyring.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
    sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "==> Удаляем все старые и конфликтующие записи репозитория Docker..."
sudo grep -lr 'download.docker.com' /etc/apt/sources.list /etc/apt/sources.list.d/ | while read file; do
    echo "    Чистим $file"
    sudo sed -i '/download.docker.com/d' "$file"
done

echo "==> Добавляем репозиторий Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "==> Обновляем индекс пакетов (ещё раз)..."
sudo apt-get update

echo "==> Устанавливаем Docker Engine, CLI и containerd..."
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