import torch
import torchvision.models as models

# Завантаження моделі
model = models.mobilenet_v2(pretrained=True)
model.eval()

# TorchScript через trace
dummy_input = torch.randn(1, 3, 224, 224)
traced = torch.jit.trace(model, dummy_input)

# Збереження моделі
traced.save("model.pt")

print("✅ TorchScript модель збережено як model.pt")
