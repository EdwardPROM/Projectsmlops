# MLOps Lesson 3: Docker Containerization

🚀 **Повноцінний ML pipeline з Docker контейнеризацією для розпізнавання зображень**

## 📋 Огляд проекту

Цей проект демонструє створення та оптимізацію Docker образів для ML inference. Використовуємо PyTorch з попередньо навченою моделлю MobileNetV2 для класифікації зображень.

### 🎯 Що робить проект:
- Створює PyTorch модель (MobileNetV2)
- Експортує модель в TorchScript формат
- Запускає inference на зображеннях
- Показує топ-3 найбільш вірогідних класи

## 🛠️ Технології

- **Python 3.9+** - основна мова програмування
- **PyTorch** - ML фреймворк
- **TorchVision** - обробка зображень
- **Docker** - контейнеризація
- **Multi-stage builds** - оптимізація образів

## 🚀 Швидкий старт

### Передумови
- Docker Desktop
- WSL2 (для Windows)

### 1. Клонування проекту
```bash
git clone <repository-url>
cd lesson-3
```

### 2. Створення моделі
```bash
# Створити TorchScript модель
python export_model.py
```

### 3. Тестування локально
```bash
# Запуск inference на зображенні
python inference.py dog.jpg
```

### 4. Збірка Docker образів
```bash
# FAT образ (повний функціонал)
docker build -f Dockerfile.fat -t ml-fat .

# SLIM образ (оптимізований)
docker build -f Dockerfile.slim -t ml-slim .
```

### 5. Запуск контейнерів
```bash
# FAT образ
docker run --rm -v ${PWD}:/app ml-fat dog.jpg

# SLIM образ
docker run --rm -v ${PWD}:/app ml-slim dog.jpg
```

## 📁 Структура проекту

```
lesson-3/
├── 📄 README.md              # Ця інструкція
├── 🐍 export_model.py        # Створення PyTorch моделі
├── 🤖 inference.py           # ML inference скрипт
├── 🖼️ dog.jpg               # Тестове зображення
├── 💾 model.pt               # Збережена TorchScript модель
├── 🐳 Dockerfile.fat         # Повний Docker образ
├── 🐳 Dockerfile.slim        # Оптимізований Docker образ
├── 📊 comparison_report.md   # Детальне порівняння образів
└── 🛠️ install_dev_tools.sh   # Налаштування середовища
```

## 🏗️ Docker образи

### ml-fat (19.1 GB)
- **Призначення:** Розробка та debugging
- **Особливості:** Повний функціонал, build інструменти
- **Використання:** Локальна розробка

### ml-slim (11.2 GB)
- **Призначення:** Production deployment
- **Особливості:** Multi-stage build, оптимізований розмір
- **Економія:** 41% менше розміру

## 📊 Результат inference

```
🏷️ Top-3 передбачення:
Labrador retriever (0.5996)
Ibizan hound (0.0999)
Weimaraner (0.0424)
```

## 🔧 Налаштування середовища

### Автоматичне налаштування (Ubuntu/WSL)
```bash
chmod +x install_dev_tools.sh
./install_dev_tools.sh
```

### Ручне налаштування
```bash
# Python віртуальне середовище
python3 -m venv mlops_env
source mlops_env/bin/activate

# Встановлення залежностей
pip install torch torchvision pillow django
```

## 📈 Порівняння образів

| Критерій | ml-fat | ml-slim |
|----------|--------|---------|
| **Розмір** | 19.1 GB | 11.2 GB |
| **Шари** | 16 | 14 |
| **Час збірки** | ~18 хв | ~15 хв |
| **Призначення** | Development | Production |

**Детальне порівняння:** [comparison_report.md](comparison_report.md)

## 🎯 Можливості оптимізації

1. **Alpine Linux** - зменшення базового образу з 87MB до 5MB
2. **Model quantization** - конвертація float32 → int8
3. **Distroless images** - видалення shell та зайвих інструментів
4. **ONNX conversion** - швидша інференція

## 🐛 Troubleshooting

### Проблема: "No such file or directory"
```bash
# Переконайтеся, що ви в правильній директорії
cd lesson-3
docker run --rm -v ${PWD}:/app ml-fat dog.jpg
```

### Проблема: "Docker not running"
- Запустіть Docker Desktop
- Перевірте WSL2 інтеграцію

### Проблема: "Module not found"
```bash
# Активуйте віртуальне середовище
source ~/mlops_env/bin/activate
```

## 📚 Корисні команди

```bash
# Перегляд образів
docker images

# Детальна інформація про образ
docker history ml-fat

# Видалення невикористаних образів
docker image prune

# Запуск інтерактивного контейнера
docker run -it --rm -v ${PWD}:/app ml-fat bash
```

## 🤝 Внесок у проект

1. Fork проекту
2. Створіть feature branch
3. Commit змін
4. Push до branch
5. Створіть Pull Request

## 📄 Ліцензія

MIT License - дивіться LICENSE файл для деталей.

---

**🎉 Готово до використання!** Запускайте inference на власних зображеннях та експериментуйте з оптимізацією Docker образів.
