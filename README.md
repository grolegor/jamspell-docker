# Docker container for JamsSpell

Dockerfile for building [JamSpell](https://github.com/bakwc/JamSpell) docker image based on your own training data

## Hot to use?
* replace **alphabet.txt** and **dataset.txt** files with your own
* ```docker build . -t jamspell```
* ```docker run -p 8080:8080 jamspell```
* ```curl http://localhost:8080/fix?text=text```
