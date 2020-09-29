FROM php:5.6-apache

ENV QA_CONFIG /var/www/html/qa-config.php
ENV QA_EDITOR_CONFIG /var/www/html/qa-plugin/wysiwyg-editor/ckeditor/config.js

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
             unzip \
             git   \
        && rm -r /var/lib/apt/lists/*

COPY ./question2answer-latest.zip /question2answer-latest.zip

RUN unzip /question2answer-latest.zip -d /q2a \
&& mv /q2a/*/* /var/www/html/ \
&& rm /question2answer-latest.zip                \
&& rm -rf /q2a

RUN cd /var/www/html/                                                                                      \
 && git clone https://github.com/alixandru/q2a-open-login.git              qa-plugin/qa-open-login         \
 && git clone https://github.com/ganbox/qa-filter.git                      qa-plugin/qa-filter             \
 && git clone https://github.com/NoahY/q2a-poll.git                        qa-plugin/qa-poll               \
 && git clone https://github.com/svivian/q2a-user-activity-plus.git        qa-plugin/qa-user-activity      \
 && git clone https://github.com/NoahY/q2a-history.git                     qa-plugin/qa-user-history       \
 && git clone https://github.com/NoahY/q2a-log-tags.git                    qa-plugin/qa-log-tags           \
 && git clone https://github.com/dunse/qa-category-email-notifications.git qa-plugin/qa-email-notification \
 && git clone https://github.com/nakov/q2a-plugin-open-questions.git       qa-plugin/qa-questions-open     

RUN mv qa-plugin/qa-open-login/providers-sample.php qa-plugin/qa-open-login/providers.php

RUN mv /var/www/html/qa-config-example.php ${QA_CONFIG}                     \
 && sed -i -e 's/127.0.0.1/db/g' ${QA_CONFIG}                               \
 && sed -i -e "s/'your-mysql-username'/getenv('QA_DB_USER')/g" ${QA_CONFIG} \
 && sed -i -e "s/'your-mysql-password'/getenv('QA_DB_PASS')/g" ${QA_CONFIG} \
 && sed -i -e "s/'your-mysql-db-name'/getenv('QA_DB_NAME')/g"  ${QA_CONFIG} \
 && chown -R www-data:www-data /var/www/html/

RUN rm -rf /var/www/html/qa-plugin/wysiwyg-editor/ckeditor/* 

COPY ./ckeditor /var/www/html/qa-plugin/wysiwyg-editor/ckeditor

# May changing this row in the future this one only removes the config.toolbar lines
# RUN sed -i -e '6,22d' ${QA_EDITOR_CONFIG}

RUN docker-php-ext-install mysqli