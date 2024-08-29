import base64
import io
from PIL import Image
import numpy as np
import torch

def base64_image_to_tensor(base64_img) -> list:
    # 去除 base64 字符串中的任何前缀（例如 "data:image/png;base64,"）
    if base64_img.startswith('data:image'):
        base64_img = base64_img.split(',')[1]
    # base64解码
    image_data = base64.b64decode(base64_img)
    # 使用 BytesIO 创建一个内存文件
    image_stream = io.BytesIO(image_data)
    # 使用 PIL 打开图像文件
    image = Image.open(image_stream)
    # 将 PIL 图像转换为 numpy 数组
    image_np = np.array(image)
    # 转化为张量
    tensor = torch.tensor(image_np)
    return tensor 