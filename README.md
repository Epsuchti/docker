docker build -f dockerfile -t test .
docker run --name test -d -P test
docker rm test
