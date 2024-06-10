[![Netlify Status](https://api.netlify.com/api/v1/badges/e638dd3b-7b94-47c7-b1f3-ba4f9a891dc1/deploy-status)](https://app.netlify.com/sites/wvictor14/deploys)

This is the repository that hosts my personal website (victoryuan.com)[https://victoryuan.com]. It is hosted on Digital Ocean

Built using  hugo theme [congo](https://jpanther.github.io/congo).

# dev

congo specific documentation: https://jpanther.github.io/congo/docs/configuration/

needs: HUGO v1.119.0 extended version

I used the "git submodule" method to install. Reason being digital ocean does not play nicely with detecting GO + HUGO, so the go module install method, which is recommend by congo author, does not work well.

Git submodule is not always straightforward, sometimes submodule does not have files, but can see that it is added in .gitmodules. To pull files in submodule folder congo/theme:

```
git submodule update --init # if congo/themes empty
```

To serve locally, the website is built in public folder. To build into public:

```
# build
hugo --gc --minify -d public

# build 
docker run -p 8080:8080 -v ${PWD}:/src -v ${HOME}/hugo_cache:/tmp/hugo_cache \
  hugomods/hugo:0.119.0 \
  hugo --gc --minify -d public

# then can serve the site via docker
docker run -p 8080:8080 -v ${PWD}:/src -v ${HOME}/hugo_cache:/tmp/hugo_cache \
  hugomods/hugo:0.119.0 \
  hugo server --bind 0.0.0.0 -p 8080

```