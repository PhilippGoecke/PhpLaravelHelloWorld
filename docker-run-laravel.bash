docker build --no-cache --rm -f Containerfile -t laravel:demo .
docker run --interactive --tty -p 8080:8080 laravel:demo
echo "browse http://localhost:8080/"
