#!/bin/bash
# Installs signup-with-plugins helm chart
## Usage: ./install.sh [kubeconfig]

if [ $# -ge 1 ] ; then
  export KUBECONFIG=$1
fi

NS=signup
CHART_VERSION=1.2.0

while true; do
    read -p "Do you want to continue installing signup services? (y/n): " ans
    if [ "$ans" = "Y" ] || [ "$ans" = "y" ]; then
        break
    elif [ "$ans" = "N" ] || [ "$ans" = "n" ]; then
        exit 1
    else
        echo "Please provide a correct option (Y or N)"
    fi
done

function installing_signup_with_plugins() {

    while true; do
      read -p "Do you want to continue installing signup service? (y/n): "
      if [ "$ans" = "Y" ] || [ "$ans" = "y" ]; then
          break
      elif [ "$ans" = "N" ] || [ "$ans" = "n" ]; then
          exit 1
      else
          echo "Please provide a correct option (Y or N)"
      fi
  done

  NS=signup
  CHART_VERSION=1.2.0

  helm repo add mosip https://mosip.github.io/mosip-helm
  helm repo update

  echo Create $NS namespace
  kubectl create ns $NS || true

  while true; do
    read -p "Is Prometheus Service Monitor Operator deployed in the k8s cluster? (y/n): " response
    if [[ "$response" == "y" || "$response" == "Y" ]]; then
      servicemonitorflag=true
      break
    elif [[ "$response" == "n" || "$response" == "N" ]]; then
      servicemonitorflag=false
      break
    else
      echo "Not a correct response. Please respond with y (yes) or n (no)."
    fi
  done

  echo "Do you have public domain & valid SSL? (Y/n) "
  echo "Y: if you have public domain & valid ssl certificate"
  echo "n: If you don't have a public domain and a valid SSL certificate. Note: It is recommended to use this option only in development environments."
  read -p "" flag

  if [ -z "$flag" ]; then
    echo "'flag' was provided; EXITING;"
    exit 1;
  fi
  ENABLE_INSECURE=''
  if [ "$flag" = "n" ]; then
    ENABLE_INSECURE='--set enable_insecure=true';
  fi

  while true; do
    read -p "Do you want to use the default plugins? (y/n): " ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
      echo "Default plugins are listed below, please provide the correct plugin number."
      echo "1. esignet-mock-plugin.jar"
      echo "2. mosip-identity-plugin.jar"
      read -p "Enter the plugin number: " plugin_no
        while true; do
          if [[ "$plugin_no" == "1" ]]; then
            plugin_option="--set plugin_name_env=esignet-mock-plugin.jar"
            break
          elif [[ "$plugin_no" == "2" ]]; then
            plugin_option="--set plugin_name_env=mosip-identity-plugin.jar"
            break
          else
            echo "please provide the correct plugin number (1 or 2)."
          fi
        done
      break
    elif [[ "$ans" == "n" || "$ans" == "N" ]]; then
      read -p "Provide the URL to download the plugins zip " plugin_url
      read -p "Provide the plugin jar name (with extension eg., test-plugin.jar) " plugin_jar
      plugin_option="--set pluginNameEnv=$plugin_jar --set pluginUrlEnv=$plugin_url"
      break
    else
      echo " Invalid response. Please respond with y (yes) or n (no)."
    fi
  done

  echo Installing signup-with-plugins
  helm -n $NS install signup mosip/signup \
    -f values.yaml --version $CHART_VERSION $ENABLE_INSECURE $plugin_option \
    --set metrics.serviceMonitor.enabled=$servicemonitorflag --wait

  kubectl -n $NS  get deploy -o name |  xargs -n1 -t  kubectl -n $NS rollout status

  echo Installed signup-with-plugins
  return 0
}

# set commands for error handling.
set -e
set -o errexit   ## set -e : exit the script if any statement returns a non-true return value
set -o nounset   ## set -u : exit the script if you try to use an uninitialised variable
set -o errtrace  # trace ERR through 'time command' and other functions
set -o pipefail  # trace ERR through pipes
installing_signup_with_plugins   # calling function
