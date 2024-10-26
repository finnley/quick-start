# quick usage

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



# deprecated
# deprecated
# 此文档已迁移至：http://10.186.18.11/confluence/pages/viewpage.action?pageId=34772526
# deprecated
# deprecated

- [目的](#--)
- [下载](#--)
- [快速部署](#----)
  * [用法](#--)
  * [限制](#--)
- [升级组件](#----)
  * [通过二进制升级组件](#---------)
        + [用法](#---1)
  * [通过 rpm 包升级组件](#---rpm------)
        + [用法](#---2)
  * [限制](#---1)



# 目的
1. 快速部署 DMP 环境
2. 快速升级指定组件

# 下载
wget ftp://ftpuser:ftpuser@10.186.18.90/housekeep/udp-quick-usage.tar.gz
# 快速部署
该脚本完成以下功能
1. 搭建五个 udp 五节点: udp-1, udp-2, udp-3, udp-4, udp-5
2. 在udp-1 上注册高可用管理端环境
3. 在udp-2，udp-3, udp-4, udp-5上注册高可用客户端环境
3. 在udp-2 安装了上mysql实例，并启用高可用
  
## 用法
1. 下载udp-quick-usage.tar.gz服务器,并解压
2. `cd /path-to-quick-usage/deploy && make`。 如果部署Ubuntu下的DMP环境需要 `cd /path-to-quick-usage/deploy`，
配置 `DISTRIBUTION` 为 `u20`，即 Ubuntu20.04 ，然后执行 `./prepard.sh` 重新生成 docker-compose.yaml 文件，最后执行 `make`
3. 在浏览器输入http://$vm_ip:25799, 登陆umc平台


## 使用自定义 UMC RPM包搭建环境
1. 下载udp-quick-usage.tar.gz服务器,并解压
2. 将自定义umc rpm包拷贝到 `/path-to-quick-usage/deploy`目录下
3. 修改`/path-to-quick-usage/deploy/env_setting.sh`文件中的 CUSTOM_UMC_RPM_NAME 为自定义umc rpm包的文件名
4. `cd /path-to-quick-usage/deploy && make `
5. 在浏览器输入http://$vm_ip:25799, 登陆umc平台
### 自定义UMC包搭建环境使用场景描述
用于快速验证dmp初始化流程
可以配合的操作：
移除json文件，只进行平台最基础的初始化，而不执行后续的部署步骤

## 限制
1. 服务器上已安装 docker
2. 能下载 docker image `docker-registry:5000/actiontech/balm-runtime-centos7`

# 升级组件
在本地开发环境完成一键升级功能：
1. 通过二进制文件一键快速升级虚拟机上的组件
2. 通过rpm包一键升级虚拟机上的组件

## 通过二进制升级组件
### 用法
1. `cd /path-to-quic-usage/upgrade `
2. 修改 upgrade_by_bin.sh 设置 REMOTE_SERVER_ADDR
2. 进入需要升级的项目的src目录下面，执行upgrade_by_bin.sh脚本 

## 升级 k8s 环境下的组件镜像
### 用法
1. `cd /path-to-quic-usage/upgrade `
2. 修改 upgrade_by_docker_image.sh 设置 REMOTE_MASTER
3. 修改 upgrade_by_docker_image.sh 设置 REPO_ADDR 同时设置 IMAGE_REPO USER_NAME 和 USER_PASSWD
4. 修改 upgrade_by_docker_image.sh 设置 DMP_NAMESPACE
5. 如需要修改 mysql 的 sidecar 需要设置 MYSQL_NAMESPACE
6. 当更新 umc 组件时涉及到了除二进制文件外的其他静态资源,需要先执行 make k8s/baseImage 更新 base 镜像
6. upgrade_by_docker_image.sh /project_path

## 通过 rpm 包升级组件
### 用法
1. `cd /path-to-quic-usage/upgrade `
1. 填写upgrade_by_rpm.sh脚本的REMOTE_SERVER_ADDR配置
2. 进入需要升级的项目的src目录下面，执行upgrade_by_rpm.sh脚本



## 限制
1. 必须是通过`快速部署`而搭建的集群
4. 使用二进制升级脚本，本地服务器需要能编译相关项目（umon不支持交叉编译）
4. 使用rpm包升级脚本，需要执行节点安装docker
4. 使用rpm包升级脚本，umc 要 2.18.06.0 以上版本
5. 使用rpm包升级脚本，需要存在或能够下载公司 docker image `docker-registry:5000/actiontech/universe-compiler`


## 进阶用法
1. 场景：需要搭建多机器集群（超过五台）的时候
2. 内容：项目的 `big-quick-usage` 分支可以搭建一个24台机器两个管理节点的集群，可以通过拉取 `big-quick-usage` 分支然后手动删掉 `compose/docker-compose.yaml` 和 `udp_install.json` 中多余的机器搭建自定义数量的集群
3. 原因：
    1. 有时候有些定制需求使用五台机器无法测试，如五台机器的集群就无法创建redis一主一从三分片的集群
    2. 删除多余的项比手动一项一项添加要容易，所以先给一个大的集群生成文件，然后手动删除就好了
4. 细节：
    1. `compose/docker-compose.yaml`: 删掉多余的机器就好，别的不用动
    2. `udp_install.json`: 
        1. url为v3/server/add的json是添加服务器 
        2. url为v3/server/prepare_server_env_for_guard的json是注册高可用客户端
        3. url为v3/server/prepare_server_env_for_guard_manager的json是注册高可用管理端
        4. 删掉多余机器对应的json即可


# deprecated
# deprecated
# 此文档已迁移至：http://10.186.18.11/confluence/pages/viewpage.action?pageId=34772526
# deprecated
# deprecated


# 功能点

* 自定义选择主机环境，支持 centos6、centos7、centos8、ubuntu20.
* 自定义主机数量，支持指定自定义环境的主机数量
* 支持脚本
* 支持可视化 UI 快速搭建

# TODO 

echo "generating docker-compose.yaml"
cat > ${COMPOSE_FILE} <<EOF
echo "version: '3'

$(cat templates.yaml)

services:
chaos-1:
container_name: chaos-1
hostname: "${HOST}chaos-1"
networks:
chaos_net:
ipv4_address: 172.10.20.1
ports:
- 10000:10000 ## sqle http (sqle port default is 10000)
- 25690:5690 ## udb
- 25700:5700 ## ucore
- 25711:5711 ## ucore alertmanager
- 25708:5708 ## umon prometheus http
- 25709:5709 ## umc server
- 25713:5713 ## uterm http
- 25715:5715 ## urds
- 25725:5725 ## udms http
- 25728:5728 ## umon-mgr http
- 25730:5730 ## umon-mgr http
- 25766:5766 ## umc oauth2
- 25780:5780 ## umc init
- 25799:5799 ## umc http
- 25810:5810 ## umc oauth2 server http
- 23450:2345 ## dlv
volumes:
- /Users/finnley/workspace:/root/workspace
<<: *agent_defaults
EOF


echo '' > ${DYNAMIC_DOCKER_FILE}
echo "version: '3'

$(cat centos7-altarch.yaml)

services:
chaos-1:
container_name: chaos-1
hostname: "${HOST}chaos-1"
networks:
chaos_net:
ipv4_address: 172.10.20.1
ports:
- 10000:10000 ## sqle http (sqle port default is 10000)
- 25690:5690 ## udb
- 25700:5700 ## ucore
- 25711:5711 ## ucore alertmanager
- 25708:5708 ## umon prometheus http
- 25709:5709 ## umc server
- 25713:5713 ## uterm http
- 25715:5715 ## urds
- 25725:5725 ## udms http
- 25728:5728 ## umon-mgr http
- 25730:5730 ## umon-mgr http
- 25766:5766 ## umc oauth2
- 25780:5780 ## umc init
- 25799:5799 ## umc http
- 25810:5810 ## umc oauth2 server http
- 23450:2345 ## dlv
volumes:
- /Users/finnley/workspace:/root/workspace
<<: *agent_defaults

" >> ${DYNAMIC_DOCKER_FILE}



for ((i=2; i<=${HOST_NUMBER}; i++))
do
echo "
chaos-$i:
container_name: chaos-${i}
hostname: "${HOST}chaos-${i}"
networks:
chaos_net:
ipv4_address: 172.10.20.${i}
<<: *agent_defaults
" >> ${DYNAMIC_DOCKER_FILE}
done;