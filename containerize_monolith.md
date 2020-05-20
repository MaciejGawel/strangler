# Containerize the Monolith

In this module you will build a Docker image for the monolith application and
push it to the Amazon [Elastic Container Registry][1] (ECR).

## Implementation instructions

### Step 1: Prerequisites

In the next steps you are going to use:

- Docker
- Github
- Amazon ECR
- Amazon ECS

To complete this course make sure that you have the following tools:

- Docker CE - [installation guide][2]
- Git client
- AWS account
- AWS CLI - [installation guide][3]

### Step 2: Download & open the project

Download the source code from Github

<!-- TODO: Add repo url -->

```sh
git clone <repo url>
```

### Step 3: Provision a repository

<!-- TODO: Verify these steps -->
<!-- TODO: Change repository name -->

Create the repository:

1. Navigate to the [ECR console][4].
1. On the **Repositories** page, select **Create Repository**.
1. On the Create repository page, enter the following name your repository:
   *monolith*.
1. Select Create repository.

   After the repository is created, a confirmation message showing with the
   repository address. The repository address is in the following format:
   `[account-ID].dkr.ecr.[region].amazonaws.com/[repo-name]`.
   The `[account-ID]`, `[region]`, and `[repo-name]` will be specific to your
   setup.

   ---

   **NOTE:** You will need the repository address throughout this tutorial.

   ---

### Step 4: Build & Push the Docker image

<!-- TODO: Verify these steps -->

Use the terminal to:

1. Authenticate Docker log in

   ```sh
   $(aws ecr get-login --no-include-email --region [your-region])
   ```

   Replace `[your-region]` with your specific information. If the authentication
   was successful, you will receive the confirmation message: *Login Succeeded*.

1. Build the image

   ```sh
   docker build -t monolith .
   ```

1. Tag the image so you can push it to Amazon ECR

   ```sh
   docker tag api:latest [account-ID].dkr.ecr.[region].amazonaws.com/monolith:v1
   ```

   Replace the `[account-ID]` and `[region]` placeholders with your specific
   information.

1. Push the image to Amazon ECR

   ```sh
   docker push [account-id].dkr.ecr.[region].amazonaws.com/monolith:v1
   ```

   Replace the `[account-ID]` and `[region]` placeholders with your specific
   information.

1. Navigate to your Amazon ECR repository, and verify if the docker image is
   present.

[1]: https://aws.amazon.com/ecr/
[2]: https://docs.docker.com/engine/install/
[3]: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html
[4]: https://console.aws.amazon.com/ecs/home?#/repositories
