#!/bin/bash

LOGFILE="install.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "=== Start environment setup ==="

# Перевірка встановлення інструментів
check_installed() {
  command -v $1 >/dev/null 2>&1
}

# Docker
if check_installed docker; then
  echo "✅ Docker is installed: $(docker --version)"
else
  echo "🔧 Installing Docker..."
  sudo apt update
  sudo apt install -y docker.io
  sudo systemctl start docker
  sudo systemctl enable docker
fi

# Docker Compose
if check_installed docker-compose; then
  echo "✅ Docker Compose is installed: $(docker-compose --version)"
else
  echo "🔧 Installing Docker Compose..."
  sudo apt install -y docker-compose
fi

# Python 3.9+
PYTHON_VERSION=$(python3 --version 2>/dev/null | cut -d' ' -f2)
if [[ $(printf '%s\n' "3.9" "$PYTHON_VERSION" | sort -V | head -n1) = "3.9" ]]; then
  echo "✅ Python >= 3.9 is installed: $PYTHON_VERSION"
else
  echo "🔧 Installing Python 3.9..."
  sudo apt update
  sudo apt install -y python3.9 python3.9-venv python3.9-distutils
fi

# pip
if check_installed pip3; then
  echo "✅ pip is installed: $(pip3 --version)"
else
  echo "🔧 Installing pip..."
  sudo apt install -y python3-pip
fi

# Python-бібліотеки
for package in django torch torchvision pillow; do
  if python3 -c "import $package" 2>/dev/null; then
    echo "✅ $package is already installed"
  else
    echo "🔧 Installing $package..."
    pip3 install $package
  fi
done

echo "✅ Environment setup complete"