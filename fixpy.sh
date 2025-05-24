#!/bin/bash

echo "Удаляем pyOpenSSL и cryptography через pip/pip3 для всех пользователей..."

for bin in pip pip3; do
  if command -v $bin >/dev/null 2>&1; then
    sudo $bin uninstall -y pyOpenSSL cryptography || true
    sudo -H -u ansible $bin uninstall -y pyOpenSSL cryptography || true
  fi
done

echo "Удаляем вручную возможные остатки из /usr/local и ~/.local..."
for pyver in 3.6 3.7 3.8 3.9 3.10 3.11; do
  sudo rm -rf /usr/local/lib/python${pyver}/dist-packages/OpenSSL*
  sudo rm -rf /usr/local/lib/python${pyver}/dist-packages/cryptography*
  sudo rm -rf /usr/local/lib/python${pyver}/site-packages/OpenSSL*
  sudo rm -rf /usr/local/lib/python${pyver}/site-packages/cryptography*
  rm -rf ~/.local/lib/python${pyver}/site-packages/OpenSSL*
  rm -rf ~/.local/lib/python${pyver}/site-packages/cryptography*
done

echo "Переустанавливаем системные пакеты python3-openssl и python3-cryptography..."
sudo apt-get update
sudo apt-get install --reinstall -y python3-openssl python3-cryptography

echo "Путь к OpenSSL в текущем python3:"
python3 -c "import OpenSSL; print(OpenSSL.__file__)"

echo "Если путь выше начинается с /usr/lib/python3/dist-packages/ — всё ОК!"