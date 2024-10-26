# ftp setting
export FTP_URL="ftp://ftpuser:ftpuser@10.186.18.90"

# install setting
export UDP_HOME=/opt
export UMC_HOME=${UDP_HOME}/umc
export UMC_ADDR=172.20.134.1
export UMC_PORT=5799

export DBLE_VERSION=3.22.07.0 #for dmp before 3.20.08.0 the default value should be 2.19.11.1

export VERSION=5.22.10.0
export DISTRIBUTION=7 # Linux Distribution, e.g. u20. default 7.
export CUSTOM_UMC_PACKAGE_NAME=  # DMP-8100 --> e.g.  umc.standard.qa.el7.x86_64.rpm
export CUSTOM_STAGE=  # when set value to "FOR_UPGRADE", quickly create environment for upgrade testing
export USE_CACHE=yes  #yes or no, set it to no if you don't want to use cache
export HOST_NUMBER=5 # number of hosts in the DMP cluster, valid range is from 5 to 253
export DISTRIBUTION_MACHINE_NUMBER=5 # The number of distribution host
export INSTALLATION_MODE=0 # 0-normal installation|1-pure installation: will not install MySQL instances|2-oceanbase installation
