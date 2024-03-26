FROM ruby:slim

RUN apt update && apt install -y git

WORKDIR /usr/src/app

COPY refresher.rb ./

CMD ["./refresher.rb"]