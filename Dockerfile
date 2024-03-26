FROM ruby:latest

RUN apt update && apt install -y git

WORKDIR /usr/src/app

COPY refresher.rb /usr/src/app

CMD ["./refresher.rb"]