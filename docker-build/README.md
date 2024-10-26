# docker build

## centos7

### altarch

### 构建

构件时需要带上 `DOCKER_BUILDKIT=0`，否则构建失败。

指定文件构建镜像

```shell
docker build -f /path/to/a/Dockerfile .
```

#### altarch

```bash
docker build -f Dockerfile.altarch -t reg.einscat.com:10010/library/centos7:altarch .
```

#### x64

```shell
docker build -f Dockerfile.x64 -t reg.einscat.com:10010/library/centos7:x64 .
```

## MacOS 下 Centos7 无法使用systemctl 命令，提示:

```shell
systemctl
Failed to get D-Bus connection: No such file or directory
```

解决方案：
```shell
vim ~/Library/Group\ Containers/group.com.docker/settings.json
修改"deprecatedCgroupv1"参数为true，默认是false
然后重启docker环境
```

参考：https://blog.csdn.net/lideqiang110119/article/details/129525432


### Dockerfile 解释

CMD ["/usr/sbin/init"]：这行指令定义了容器启动时要执行的默认命令。在本例中，容器将执行 /usr/sbin/init 命令作为其主要进程。通常情况下，将 init 进程作为容器的主进程有助于正确处理信号和进程管理，确保容器的正常运行。

要以这种方式通过 `docker run` 手动启动一个容器，你可以使用以下命令：

```bash
docker run -v /sys/fs/cgroup:/sys/fs/cgroup <image_name>
```

这个命令中的 `-v /sys/fs/cgroup:/sys/fs/cgroup` 部分是关键，它将主机的 `/sys/fs/cgroup` 目录挂载到容器内部的同一位置。这样做确保容器内的进程可以访问并正确使用 cgroup 文件系统。请将 `<image_name>` 替换为你要运行的容器镜像名称。

如果你想在容器启动时执行 `/usr/sbin/init`，可以使用以下命令：

```bash
docker run -v /sys/fs/cgroup:/sys/fs/cgroup <image_name> /usr/sbin/init
```

这样容器将以 `/usr/sbin/init` 作为启动命令运行。记得将 `<image_name>` 替换为你实际使用的容器镜像名称。

总结起来，通过这些命令可以手动启动一个容器，并确保 cgroup 文件系统正确挂载以及指定启动命令为 `/usr/sbin/init`。

macos启动一个centos7镜像的容器：
docker run -ti centos:centos7.9.2009 /bin/bash
docker run -d -p 52222:22 --name centos7-test --privileged=true centos:centos7.9.2009 /usr/sbin/init

## 指定文件构建镜像

```bash
docker build -f /path/to/a/Dockerfile .
```

如：
```bash
docker build -f Dockerfile.altarch -t finnley/centos7:altarch .
docker build -f Dockerfile.x64 -t finnley/centos7:x64 .
docker build -f Dockerfile.x64 -t centos7:x64 .


docker build -f Dockerfile.x64 -t reg.einscat.com:10010/library/centos7:x64 .
reg.einscat.com:10010/library/busybox@sha256:a77fe109c026308f149d36484d795b42efe0fd29b332be9071f63e1634c36ac9
docker push reg.einscat.com:10010/library/centos7:x64

docker push reg.einscat.com:10010/library/centos7:x64
docker tag reg.einscat.com:10010/library/centos7:x64 111.231.87.78:10010/library/centos7:x64 
docker push 111.231.87.78:10010/library/centos7:x64 
```

## 启动容器

```shell
docker run -itd --privileged --add-host reg.actiontech.com:10.186.18.23 --name=chaos-1 --hostname=chaos-1 --network=quick_usage_net --ip=172.10.20.1  finnley/centos7:altarch
```

docker buildx build --platform linux/amd64,linux/arm64 --tag finnley/centos7 --push .

DOCKER_BUILDKIT=1 docker buildx build -t 镜像:标签 --platform linux/arm64 .
DOCKER_BUILDKIT=1 docker buildx build --platform linux/amd64,linux/arm64 --tag finnley/centos7 --push .

mac 执行下面代码：
```shell
docker run -d -p 2222:22 --name centos7-test --privileged=true reg.actiontech.com/actiontech-dev/balm-runtime-centos7 /usr/sbin/init


docker buildx build -t finnley/centos7:v0.1 --platform linux/amd64,linux/arm64 . --push
```


```shell
RUN sed -i.backup 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf \
        && curl -o CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
        && curl -o epel.repo http://mirrors.aliyun.com/repo/epel-7.repo \
        && yum clean all
```

禁用该插件
在 `fastestmirror.conf` 文件中，`enabled=1` 的意思是启用了最快镜像功能。这个配置文件通常用于 Yum 和 DNF 包管理器，用来自动选择最快的软件包镜像服务器下载软件包。设置为 `enabled=1` 表示系统会尝试通过测试各个镜像的下载速度，并选择最快的镜像进行下载，从而提高软件包下载的速度和效率。

设置 `enabled=0` 的好处在于可以禁用最快镜像功能。这可能有几个应用场景和好处：

1. **固定镜像源：** 如果你已经知道或者需要固定使用特定的镜像源，而不希望系统自动选择最快的镜像，可以将 `enabled` 设置为 `0`，以避免不必要的镜像切换。

2. **网络环境控制：** 在某些特定的网络环境下，自动选择最快镜像可能不适用或者导致不必要的延迟。通过禁用这一功能，可以确保稳定的镜像选择，减少系统不必要的网络请求和时间消耗。

3. **镜像源管理：** 有时管理者或用户希望手动管理镜像源的选择和更新频率，而不依赖于系统的自动选择。这种情况下，禁用最快镜像功能可以提供更多的控制权和可预测性。

总之，将 `enabled=0` 可以在需要时保持镜像源的静态选择和控制，而不受系统自动优化的影响。

```shell
sed -i.backup 's/^enabled=1/enabled=0/' fastestmirror.conf
```

## 

```shell
这条命令 echo root:sshpass | chpasswd 的作用如下：

echo root:sshpass 打印出 root:sshpass 这个字符串。
| 表示管道，将 echo 命令输出的结果传递给下一个命令。
chpasswd 是一个命令，用来批量修改用户密码。
因此，这条命令的意思是将用户名为 root 的用户的密码修改为 sshpass。其中 root:sshpass 表示用户名和密码之间使用 : 分隔。当这条命令被执行后，用户 root 的密码将会被设置为 sshpass。请注意，使用明文密码作为参数传递可能存在安全风险，建议谨慎使用。
```

## 
https://developer.moduyun.com/article/561f7ad5-7df0-11ee-b225-6c92bf60bba4.html