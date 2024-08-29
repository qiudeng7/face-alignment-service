# face-alignment-service
人脸识别服务。本仓库提供一个docker容器，部署之后可以接受一个携带base64图片的POST请求，响应图片中人脸关键点的位置。

主要功能由[1adrianb/face-alignment](https://github.com/1adrianb/face-alignment) 提供，本仓库只是封装了一个运行环境和http api。

## 快速开始

```shell
git clone https://github.com/qiudeng7/face-alignment-service
cd face-alignment-service
docker compose up -d
```

请确保
1. 8000端口未被占用
2. 你的环境中可以正常使用docker和docker compose


如果需要修改端口，找到[docker-compose.yaml](./docker-compose.yaml)中的`- "8000:8000"`这一行，比如你要改成9000端口，就写`- "9000:8000"`

执行`docker compose up -d`之后，docker会通过[Dockerfile](./Dockerfile)构建face-alignment的运行环境，然后启动web server。

启动成功之后浏览器打开localhost:8000即可查看和调试

## 项目目录和环境说明

[1adrianb/face-alignment](https://github.com/1adrianb/face-alignment) 仓库提供了人脸识别的python接口，但是它的环境不是很好配，而[自带的dockerfile](https://github.com/1adrianb/face-alignment/blob/master/Dockerfile)也已失效。

于是我重新写了一个[./Dockerfile](./Dockerfile)用作运行环境，为了和原项目的cuda、dudnn版本保持一致，基础镜像选择了[pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime](https://hub.docker.com/layers/pytorch/pytorch/1.6.0-cuda10.1-cudnn7-runtime/images/sha256-9c3aa4653f6fb6590acf7f49115735be3c3272f4fa79e5da7c96a2c901631352?context=explore)。

[./docker-compose.yaml](./docker-compose.yaml)用于快速部署服务，[./.devcontainer](./.devcontainer) 用作开发容器(推荐使用vscode开发)区分开发环境与生产环境。

为了照顾特殊网络环境，包管理器使用了清华源（[参考1: LinuxMirrors](https://linuxmirrors.cn/use/)，[参考2: 清华镜像-Ubuntu软件仓库](https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/)），pip也使用了清华源（[参考: 清华镜像: pypi使用帮助](https://mirrors.tuna.tsinghua.edu.cn/help/pypi/)）

[./lib](./lib)是face-alignment运行所需要的模型等缓存文件，原本是要从作者的个人服务器下载的，为了照顾特殊网络环境，我改成了直接本地复制粘贴过去。

最后，test.py和test-image.jpg用于验证当前环境下face-alignment是否运行正常。

## 依赖版本
python 3.7.7
pytorch 1.6 
cuda 10.1 
cudnn 7
face-alignment 1.4.1

更多环境信息请查看[requirements.txt](./requirements.txt)和[Dockerfile](./Dockerfile)

## todo
1. 通过命令行参数或者http请求切换cuda和CPU
2. 减少dockerfile的层数
3. 静态页面检测效果
4. 调用更多face功能