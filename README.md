Deployed automatically to:

https://nwolff.github.io/cours-representation-information/

## Developing

Installing dependencies:

    npm install

Running the app under development, with automatic reload:

    npm run dev -- --open

Formatting:

    npm run format

Type-checking:

    npm run check

Verifying the production build:

When building for prod, svelte tries to render server-side as much as possible to make
pages appear rapidly. A lot of our routes can only run in the browser and we disable
server-side-rendering for those.
This step makes sure we haven't forgotten anything.

    npm run build
    npm run preview -- --open

Deploying to GitHub pages:

Automatically triggered by a push to the main branch
