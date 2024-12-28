# Flo24 Exercise Gitea

### Pre-requisite software

1. Docker engine
2. docker-compose
3. jq

## Setup

1. Run the following command in your console

```bash
docker-compose -f gitea/gitea-docker-compose.yaml up -d
```

2. Wait for command to complete and run the docker container
3. Now, open the below url in a browser

```
http://localhost:4000
```

4. Proceed with default values
5. Now on the next screen, click on register account and fill in the below details

```
username: user1
password: admin_password
email: user1@abc.com
```

6. Click on create account
7. Come back to console and run the following scripts. This script will create a **organization** in your gitea with name `nagarro`

```bash
scripts/create_gitea_users.sh
```

8. Paste admin `username` & `password` in your `app.config.yaml` file. As shown below. This will allow backstage to authenticate to your `gitea`.

```yaml
integrations:
  gitea:
    - host: localhost:4000
      username: user1
      password: admin_password
      baseUrl: http://localhost:4000
```

## Steps to create your first repo and component

1. Run below command to start the app

```bash
yarn install
yarn dev
```

2. This will open your backstage app at [localhost:3000](http://localhost:3000)
3. Now on your right `side bar` click on `Create`
4. You will see 2 templates

- Example Node.js Template
- Create a gitea repository

5. Click on `choose` on the `Create a gitea repository` template card.
6. Now, on the first screen provide a name for your component which will be show at the end of this exercise on the catalog entities page. e.g my-nodejs-app or anything you want.
7. Click `Next` and type `nagrro` under the `owners` text field.
8. Enter `my-app` under the `repo` text field then hit `Review`.
9. At last click on the `Create` button.

> You have successfully created your first component and learn how to integrate with SCM.🤩🥳

Please ask your presenter in case of any confusions.
