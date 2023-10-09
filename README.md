Déployé ici :

https://cours-representation-information-ootpadsfsa-oa.a.run.app

## Développement

    gcloud beta code dev

    docker run -e PORT=80 -p 80:80 --rm -it $(docker build -q .)
