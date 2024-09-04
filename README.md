Deployed automatically when branch main is pushed, to:

https://ri.nwolff.info/

Usage statistics collected with umami.js

---

## Start a live dev server

    npx elm-spa server

## Running unit tests

    npx elm-test

## Reviewing

    npx elm-review --template jfmengels/elm-review-config/application src tests

## Building for production

    npx elm-spa build

## Finding outdated packages

    npx elm-json upgrade
