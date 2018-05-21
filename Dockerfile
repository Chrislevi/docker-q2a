FROM php:5.6-apache

ENV QA_CONFIG /var/www/html/qa-config.php

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
                unzip \
                git \
        && rm -r /var/lib/apt/lists/*

RUN curl -o /q2a.zip http://www.question2answer.org/question2answer-latest.zip \
            && unzip /q2a.zip -d /q2a \
            && mv /q2a/*/* /var/www/html/ \
            && rm /q2a.zip \
            && rm -rf /q2a

RUN mv /var/www/html/qa-config-example.php ${QA_CONFIG}

RUN sed -i -e 's/127.0.0.1/db/g' ${QA_CONFIG} && \
    sed -i -e "s/'your-mysql-username'/getenv('QA_DB_USER')/g" ${QA_CONFIG} && \
    sed -i -e "s/'your-mysql-password'/getenv('QA_DB_PASS')/g" ${QA_CONFIG} && \
    sed -i -e "s/'your-mysql-db-name'/getenv('QA_DB_NAME')/g"  ${QA_CONFIG}

RUN docker-php-ext-install mysqli
