#!/bin/bash

# Обновление системы
sudo apt update && sudo apt upgrade -y

# Установка необходимых пакетов
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Добавление GPG ключа Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Добавление репозитория Docker
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# Установка Docker
sudo apt update
sudo apt install -y docker-ce

# Добавление пользователя в группу docker (чтобы запускать без sudo)
sudo usermod -aG docker ${USER}

# Установка Docker Compose (последняя стабильная версия)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Проверка версий
docker --version
docker-compose --version

echo "Установка завершена! Перезайдите в систему или выполните: exec su -l $USER"