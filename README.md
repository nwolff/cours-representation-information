Deployed automatically when branch main is pushed, to:

https://ri.nwolff.info/

Usage statistics collected with umami.js

---

## Start a live dev server

    npx elm-land server

## Running unit tests

    npx elm-test

## Formatting

    npx elm-format --yes src tests

## Reviewing

Gets a bit confused by elm-land (which generates code that review cannot see), but gives useful feedback nonetheless

    npx elm-review --template jfmengels/elm-review-config/application src tests

## Building for production

    npx elm-land build

## Finding outdated packages

    npx elm-json upgrade
