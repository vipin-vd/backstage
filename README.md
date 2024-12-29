# [Backstage](https://backstage.io)

This is your newly scaffolded Backstage App, Good Luck!

## Pre-requisites:

<details>
  <summary>Installation Steps</summary>
  
### Add pre-commit
We are integrating the `husky` tool to automate pre-commit tasks such as running `yarn prettier`, `yarn lint:all`, and executing test cases. These tasks will automatically run every time you make a commit. The commands are defined in the pre-commit script file located in the `.husky` folder.
1. Run the following command to install Husky:
    ```bash
    yarn dlx husky init
    ```
2. The above command will make some changes to your `package.json` and `pre-commit` files. Please undo/revert these changes, as the necessary scripts have already been added to the pre-commit file.
</details>

## Start App

To start the app, run:

```sh
yarn install
yarn dev
```

## Exercises

### [Gitea Excercise](./exercise/gitea-exercise.md)
