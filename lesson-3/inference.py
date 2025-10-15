import sys
import torch
from torchvision import transforms
from PIL import Image
import urllib.request

# Завантажити модель
model = torch.jit.load("model.pt")
model.eval()

# Класи ImageNet
url = "https://raw.githubusercontent.com/pytorch/hub/master/imagenet_classes.txt"
with urllib.request.urlopen(url) as f:
    categories = [line.strip().decode("utf-8") for line in f]

# Преобробка зображення
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    )
])

# Отримати шлях до зображення
if len(sys.argv) < 2:
    print("⚠️ Вкажіть шлях до зображення як аргумент")
    sys.exit(1)

image_path = sys.argv[1]
image = Image.open(image_path).convert("RGB")
input_tensor = preprocess(image).unsqueeze(0)

# Передбачення
with torch.no_grad():
    output = model(input_tensor)
    probabilities = torch.nn.functional.softmax(output[0], dim=0)

# Top-3
top3 = torch.topk(probabilities, 3)

print("\n🏷️ Top-3 передбачення:")
for idx in top3.indices:
    print(f"{categories[idx]} ({probabilities[idx].item():.4f})")
