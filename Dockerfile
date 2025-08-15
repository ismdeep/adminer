FROM debian:11 AS builder
WORKDIR /adminer
COPY . .
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
      apt-utils htop xz-utils wget curl git locales vim zip gcc g++ make cmake unzip zlib1g-dev \
      nginx php-fpm php-mysql php-zip php-xml php-gd php-mbstring php-redis php-curl && \
    locale-gen en_US.UTF-8 && \
    curl -sS https://getcomposer.org/installer -o composer-setup.php && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    rm -f composer-setup.php && \
    # Download dependencies
    rm -rf designs/pepa-linha-dark/ && \
    git clone https://github.com/pepa-linha/Adminer-Design-Dark.git designs/pepa-linha-dark/ && \
    rm -rf designs/hydra/ && \
    git clone https://github.com/Niyko/Hydra-Dark-Theme-for-Adminer.git designs/hydra/ && \
    rm -rf externals/jush/ && \
    git clone https://github.com/vrana/jush.git externals/jush/ && \
    rm -rf externals/JsShrink/ && \
    git clone https://github.com/vrana/JsShrink.git externals/JsShrink/ && \
    # Install php composer dependencies
    composer install && \
    # Compile adminer.php
    php compile.php

FROM adminer:5.3.0
COPY --from=builder /adminer/adminer-5.3.0.php /var/www/html/adminer.php
