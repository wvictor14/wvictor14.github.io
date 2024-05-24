FROM hugomods/hugo:exts

WORKDIR /app
COPY . /app

RUN hugo mod get -u && hugo --gc --minify -d public
