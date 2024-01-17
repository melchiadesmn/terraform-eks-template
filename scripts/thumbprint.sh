#!/bin/bash

main() {
  if [ -z "$1" ]; then
    echo "É necessário fornecer um argumento para o nome da região do EKS."
    exit 1
  fi

  local region="$1"
  local host="oidc.eks.${region}.amazonaws.com"

  local thumbprint
  thumbprint=$(echo | openssl s_client -servername "$host" -showcerts -connect "$host":443 2>/dev/null |
    sed -n -e '/BEGIN/h' -e '/BEGIN/,/END/H' -e '$x' -e '$p' | tail +2 | openssl x509 -fingerprint -sha1 -noout | 
    sed -e "s/.*=//" -e "s/://g" | tr '[:upper:]' '[:lower:]')

  echo "{\"thumbprint\":\"${thumbprint}\"}"
}

main "$1"