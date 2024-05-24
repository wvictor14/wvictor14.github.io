FROM hugomods/hugo:base-0.126.1

WORKDIR /app
COPY . /app

RUN hugo --gc --minify -d public
