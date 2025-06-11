FROM docker.io/php:8.4-cli

RUN DEBIAN_FRONTEND=noninteractive apt update && DEBIAN_FRONTEND=noninteractive apt upgrade -y \
  # install dependencies
  && DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends curl git unzip \
  # make image smaller
  && rm -rf "/var/lib/apt/lists/*" \
  && rm -rf /var/cache/apt/archives \
  && rm -rf /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && composer --version

WORKDIR /app

RUN composer create-project --prefer-dist laravel/laravel helloworld \
  && ls -lisah helloworld

WORKDIR /app/helloworld

RUN php artisan make:controller HelloController \
  && sed -i "s/}/  public function index() { return view('hello_index'); }\n}/g" app/Http/Controllers/HelloController.php \
  && echo "Route::get('/hello', 'App\Http\Controllers\HelloController@index');" >> routes/web.php \
  && php artisan route:list \
  && echo "Hello World!" > resources/views/hello_index.blade.php

RUN composer install

EXPOSE 8080

CMD php artisan serve --host=0.0.0.0 --port=8080

HEALTHCHECK CMD curl -f "http://localhost:8080" || exit 1
