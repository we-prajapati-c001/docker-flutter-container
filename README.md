## Build and run image
docker build --pull --rm -f "Dockerfile" -t flutter-ci-cd-docker:latest "."

## Print the logs as well
docker build --pull --rm -f "Dockerfile" -t flutter-ci-cd-docker:latest "." --progress=plain

## Build without using cache
docker build --pull --rm -f "Dockerfile" -t flutter-ci-cd-docker:latest "." --no-cache

## Pass arguments
docker build --pull --rm -f "Dockerfile" -t flutter-ci-cd-docker:latest "." --progress=plain --build-arg flutter_app_branch=develop --build-arg cachebust=$(date +%s)
