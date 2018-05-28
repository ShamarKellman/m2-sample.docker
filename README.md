# INSTALATION

This will install Magento 1 with sample data running on Magento 1 docker environment.
Suitable for local development only.

Add this line to /etc/hosts
```sh
127.0.0.1 m1-sample.docker
```

## Execute these commands: 

```sh
mkdir m1-sample.docker
cd m1-sample.docker/
git clone git@github.com:tomasinchoo/m1-sample.docker.git .
git checkout m1-sample.docker
mkdir html
cp -R .git html/.git
cd html/
git checkout master
cd ..
make pull-private && make pull-db
docker-compose up -d
```
Wait few seconds for all containers to start (even if you get "done" status from containers)

```sh
make dbimport
```
Go to [http://m1-sample.docker link](http://m1-sample.docker)