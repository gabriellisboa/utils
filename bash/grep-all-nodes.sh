#!/bin/bash
  

GREP_TERM=$1

getPropertieFromNode() {
  echo "Getting kubernetes nodes"
  NODES_LIST=$(kubectl get nodes | awk 'FNR > 1 {print $1}')

  echo "Grepping (-i) all nodes description for: ${GREP_TERM}"
  for node in $NODES_LIST
  do
    NODE_GREP_RESULT=$(kubectl describe node ${node} | grep -i $GREP_TERM)
    echo "Content from node: ${node}"
    echo "${NODE_GREP_RESULT}"
    echo ""
    echo ""
  done
}

main(){
  getPropertieFromNode
}

if [ -z "$1" ]
then
  echo "You need to provide a propertie to grep in every node description as an input"
else
  main
fi
