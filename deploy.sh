# building the images and ensure to get the latest version, because of the lack in K8s doing
# updates when version is not specific UNIQUE TAGGING
docker build -t th3v055i/multi-client:latest -t th3v055i/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t th3v055i/multi-server:latest -t th3v055i/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t th3v055i/multi-worker:latest -t th3v055i/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# pushing latest to Docker Hub
docker push th3v055i/multi-client:latest
docker push th3v055i/multi-server:latest
docker push th3v055i/multi-worker:latest

# pushing SHA related to Docker Hub
docker push th3v055i/multi-client:$SHA
docker push th3v055i/multi-server:$SHA
docker push th3v055i/multi-worker:$SHA

# set up the clusters
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=th3v055i/multi-server:$SHA
kubectl set image deployments/client-deployment client=th3v055i/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=th3v055i/multi-worker:$SHA