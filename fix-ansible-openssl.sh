#!/bin/bash

set -e

echo "==> Определяем версию Python 3..."
PYTHON_BIN=$(which python3)
PYTHON_VERSION=$($PYTHON_BIN -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")
PYTHON_SITE_PACKAGES="/usr/local/lib/python${PYTHON_VERSION}/dist-packages"

echo "Используется Python: $PYTHON_BIN ($PYTHON_VERSION)"
echo "Site-packages: $PYTHON_SITE_PACKAGES"

echo "==> Удаляем pip-версии pyOpenSSL и cryptography (если есть)..."
sudo pip3 uninstall -y pyOpenSSL cryptography || true

echo "==> Удаляем остатки из $PYTHON_SITE_PACKAGES ..."
sudo rm -rf $PYTHON_SITE_PACKAGES/OpenSSL*
sudo rm -rf $PYTHON_SITE_PACKAGES/cryptography*
sudo rm -rf $PYTHON_SITE_PACKAGES/pyOpenSSL*
sudo rm -rf $PYTHON_SITE_PACKAGES/pyOpenSSL-*.dist-info
sudo rm -rf $PYTHON_SITE_PACKAGES/cryptography-*.dist-info

echo "==> Переустанавливаем системные пакеты..."
sudo apt update
sudo apt install --reinstall -y python3-openssl python3-cryptography python3-pip

echo "==> Обновляем pip..."
sudo pip3 install --upgrade pip

echo "==> Устанавливаем pyOpenSSL и cryptography через pip..."
sudo pip3 install --force-reinstall pyOpenSSL cryptography

echo "==> Проверяем импорт и путь к библиотекам..."
$PYTHON_BIN -c "import OpenSSL; print('pyOpenSSL:', OpenSSL.__version__, OpenSSL.__file__)"
$PYTHON_BIN -c "import cryptography; print('cryptography:', cryptography.__version__, cryptography.__file__)"

echo "==> Проверка импорта X509StoreFlags..."
$PYTHON_BIN -c 'from OpenSSL.crypto import X509StoreFlags; print("X509StoreFlags OK")'

echo "==> Всё готово для работы Ansible!"