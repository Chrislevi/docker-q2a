# docker-q2a
Dockerized Question2Answer.

# Example 
`docker run -itd --name q2a -p 8088:80 -e QA_DB_USER=q2a -e QA_DB_PASS=q2apass -e QA_DB_NAME=q2a chrislevi/docker-q2a`
by default it will try to reach 'db' host as the targeted mysql host. either change it or link it as an alias in your own docker-compose

Within the [repo](https://github.com/Chrislevi/docker-q2a) theres a docker-compose with a default mysql databse to hold q2a's persistant data. just run `docker-compose -d --build`
