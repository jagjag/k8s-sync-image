#! /bin/bash


function main()

{

  : ${1?"Usage: $0 local registry address"}
  echo ''
  : ${2?"Usage: $0 k8s version like  v1.11.5"}
  

  echo 'pls input local registry username' 
  read username  
  echo 'pls input local registry password' 
  read -s  password
  echo $1 $2 
  image_list=$(kubeadm config images list --kubernetes-version=$2 | awk -F '/' {'print $2'})

  image_repo='k8s.gcr.io' 
  echo '====== image list ====='
  echo $image_list

  echo '====== download images ====='


  for i in $image_list
  do
     docker pull k8s.gcr.io/$i || { echo " download $i error"; exit 1 ; }
  done

   
  echo "==== push to local registry $1 ====" 
  docker login $1 --username $username --password $password


  echo $image_list
  for i in $image_list
  do
     docker tag k8s.gcr.io/$i  $1/google_containers/$i  && docker push  $1/google_containers/$i 
  done


}


main $1 $2 