Deployed automatically to:

http://cours-representation.nicholaswolff.com/

---

Requires elm0.19.1

To install elm and elm-spa without being sudoer:

    npm install elm elm-spa

## Start a live dev server

    npx elm-spa server

## Testing

Install elm-test with npm, then:

    npx elm-test

## Reviewing

Install elm-review with npm, then:

    npx elm-review --template jfmengels/elm-review-config/application src

## Building for production

    npx elm-spa build

## Deploying

Deployed automatically upon push to main

    Using https://github.com/isaacvando/elm-to-gh-pages
