#!/bin/bash
while :
do
	docker cp <CONTAINER ID>:/DoggoWithAJobbo/countVal.txt /home/opc/DogApp/countVal.txt
	sleep 300
done 
