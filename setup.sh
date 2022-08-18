#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${APM_TMP_DIR}" ]]; then
    echo "APM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_INSTALL_DIR}" ]]; then
    echo "APM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${APM_PKG_BIN_DIR}" ]]; then
    echo "APM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/AttifyOS/gnuradio/releases/download/v3.10.3.0/gnuradio-3.10.3.0.tar.gz -O $APM_TMP_DIR/gnuradio-3.10.3.0.tar.gz
  tar xf $APM_TMP_DIR/gnuradio-3.10.3.0.tar.gz -C $APM_PKG_INSTALL_DIR/
  rm $APM_TMP_DIR/gnuradio-3.10.3.0.tar.gz
  PATH=$APM_PKG_INSTALL_DIR/bin/:$PATH conda-unpack
  echo "#!/usr/bin/env bash" > $APM_PKG_BIN_DIR/gnuradio-companion
  echo "source $APM_PKG_INSTALL_DIR/bin/activate" >> $APM_PKG_BIN_DIR/gnuradio-companion
  echo "exec gnuradio-companion" >> $APM_PKG_BIN_DIR/gnuradio-companion
  chmod +x $APM_PKG_BIN_DIR/gnuradio-companion
}

uninstall() {
  rm -rf $APM_PKG_INSTALL_DIR/*
  rm $APM_PKG_BIN_DIR/gnuradio-companion
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1