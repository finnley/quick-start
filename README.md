# quick start

## 注意

1. 为了保证mac下容器能够使用systemd，修改了mac下 `~/Library/Group\ Containers/group.com.docker/settings-store.json` 文件，将 `deprecatedCgroupv1` 参数设置为 `true`，默认是 `false`。

## 其他


# 通过将普通用户加入到sudoers，这样普通用户就可以通过 sudo 命令来暂时获得 root 权限
RUN sed -i '/^root.*ALL=(ALL).*ALL/a\going\tALL=(ALL) \tALL' /etc/sudoers

RUN tee -a $HOME/.bashrc <<-'EOF'

if [ ! -d $HOME/workspace ]; then
    mkdir -p $HOME/workspace
fi

# 用户特定环境
# Basic envs
export LANG="en_US.UTF-8"

export WORKSPACE="$HOME/workspace"
export PATH=$HOME/bin:$PATH

# 默认入口目录
cd $WORKSPACE
EOF

RUN bash

# 配置 git
RUN git config --global user.name "4343"
RUN git config --global user.email "43@43.com"
# 设置git保存用户名和密码
RUN git config --global credential.helper store
# 解决Git中“File too long”的错误
RUN git config --global core.longpaths true
RUN git config --global core.quotePath false
RUN git lfs install --skip-repo

# 配置Go
RUN wget -P /tmp/ https://golang.org/dl/go1.17.1.linux-amd64.tar.gz

```shell
## 功能

1. 使用Docker快速搭建环境，方便快捷，不会影响本地环境。
2. 能够搭建不同架构的Linux环境，支持 centos6、centos7、centos8、ubuntu20.04，在Linux中可以安装所需的应用来用于开发、测试、学习。

    比如，搭建 CentOS7 x86_64 的环境，Ubuntu20.04 amd64 的环境。
3. 能够根据配置构建应用该架构的不同 Linux Docker镜像。

    比如，在x86_64的Linux环境中构建一个支持x86_64的 CentOS7、Ubuntu20.04 AMD64 的Docker镜像。
4. 能够根据配置一键创建多个Linux环境的容器

    比如:
    - 一键生成5个 CentOS7 x86_64、Ubuntu20.04 AMD64 的环境的 docker-compose.yaml 文件;
    - 配置文件支持自定义主机容器数量，如，创建5个CentOS7的容器；
    - 配置文件支持自定义不同的Linux容器，如5个CentOS7容器，3个Ubuntu20.04的容器；
    - 配置文件支持根据不同的容器主机设置暴露的端口、挂载的目录、容器名、容器IP等信息；


## 分支

- altarch: 对应本地 Mac arm64 环境
- x86_64：对应 CentOS7 x86_64 环境
- dmp-centos8_arm64：对应 DMP CentOS8 aarch64 环境
- quick-start：对应 DMP quick-usage 环境

## templates.yaml

x-templates 用法是 YAML 文件中的一个常见模式，尽管它不是专属于 Docker Compose 的特性，而是 YAML 自身的功能。这种模式利用了 YAML 文件的锚点（anchors）和引用（alias），用于在文件中定义可以重用的配置段。

具体用法解析
定义锚点 (&):

x-templates 定义了一组预配置的模板，每个模板通过 & 后的名称（例如 &agent_centos7_x86_64）标识出一个可重用的配置块。
引用配置 (*):

在实际的服务定义中（通常在 services 下），可以使用 * 加上锚点名称来引用这些模板。例如，在服务定义中使用 *agent_centos7_x86_64 将会插入之前定义的整个模板配置。


解释
x-templates: 这个部分并不是 Docker Compose 强制要求的，而是一个约定用法，用于组织和重用配置。
<<: *alias_name: 在服务中使用该语法来引入整个模板配置。这么做可以避免在多个服务中重复相同的配置，方便维护和修改。
好处
减少重复: 将共用的配置提取为模板，减少重复定义。
易于维护: 更改一次模板配置，所有引用的地方都会反映变化。
组织清晰: 配置文件更加整洁、有条理。
虽然 x-templates 和定义中间配置段的锚点和引用是 YAML 的功能，但这种使用模式在 docker-compose.yml 文件中非常有用，特别是在处理复杂配置时。

`x-templates` 并不是 YAML 或 Docker Compose 的特定关键字，而是一个习惯用法或约定指定的名称。在 YAML 中，你可以使用任何有效的标识符作为键名称。在 Docker Compose 文件中，`x-` 前缀通常用于定义自定义片段或扩展字段，这是一种通过规则命名避免与 Docker Compose 官方保留字段冲突的方式。这种命名惯例广泛应用于需要共享或重用配置时。

### 具体说明

- **YAML 标准**: YAML 本身允许你定义任意的关键字和结构，只要它们满足规范。例如，键名可以是任何字符串。

- **自定义字段（`x-` 前缀）**: 当你希望在 Docker Compose 中定义一些不直接作为 Docker Compose 语法一部分的结构时，可以用以 `x-` 开头的键。这样做的好处是避免与 Docker Compose 已有或未来可能增加的字段冲突。示例常见的用法包括 `x-templates、x-common、x-logging` 等。

- **具体应用**:
  - **结构化配置**: 使用 `x-templates` 这样的键来组织模板，提高配置文件的可读性和维护性。
  - **避免冲突**: 由于 `x-` 开头的字段不是标准 Docker Compose 语法的一部分，Compose 在解析时会忽略它们。这意味着它们纯粹是为了方便用户组织配置，不会影响实际运行。


### 自定义port和port
通过键索引访问端口和卷：

使用 --arg idx "chaos-${i}" 来构造当前的键，并且访问 JSON 的相应部分，如 .ports[$idx] 和 .volumes[$idx]。
对于在 JSON 中不存在的键（如没有 chaos-2 的配置情况），使用 // [] 来处理可能的 null 值。
确保移植性和容错能力：

在解析后的 ports 和 volumes 如果不为空，才执行相关的迭代和输出动作

### 在 Docker Compose 中的作用

在实践中，通过 `x-templates` 或类似方法，你可以在项目中共享配置块，而不是在每个服务下重复相同的设置。这种用法可以显著提高配置文件的灵活性和可维护性。

所以，`x-templates` 本身不是 YAML 或 Docker Compose 的保留关键字，仅仅是一种通过 `x-` 前缀实现配置管理的惯例。

