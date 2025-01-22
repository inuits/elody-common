# elody common

*Note: for more information, please check out our [documentation repo](https://github.com/inuits/elody-docs). This contains more technical information in detail.*

## Initializing

### How to start for the first time

#### Add customer repository
This is the base repository for Elody. When you execute the `task clone-repos` command, all repositories in the `repositories.txt` file will be pulled and saved under the directory specified in this file.
The structure of the file is as follows: `${repo-url} ${folder-to-clone-to}` each line in the file specifies a repository URL and the target folder for cloning.

1. The base version of this file contain all the generic Elody repos.

2. To start an Elody application, you will need to have a customer common repo. This repository contains a same structure as this one, which will pull all needed customer repositories for that specific customer.
When you have this, you can place the clone ssh url in this `repositories.txt` file together with the directory `clients/${name_of_client}`.
    *IMPORTANT: The name of the client **has to be** equal to the `PROJECT_FOLDER` variable in the `.env.dist` of the customers common repository.*
    *TIP: Remember the file structure noted above.*

4. Now, when you execute the `task clone-repos` command again, customer repos will also be pulled. After this you can go further with setting up an Elody application. 

#### An example flow
*Important: For when you have added te customer repo*
1. Install `task` command from [taskfile.dev](https://taskfile.dev/installation/) (if not available).
2. Run `task` to see what commands are available
3. Run `task setup-env` (this command runs multiple task commands, advised to check the commands to understand what is happening).
4. Configure your credentials for the ENV variable COMPOSER_AUTH to be able to download packages with composer
5. Run `task build-client`.
6. Run `task start-client`
7. Run `task import-keycloak-realm`. *Note: This will add a realm to keycloak which is used for authentication*
8. Run `task import-mongo-data`. *Note: This will add a user entity to authenticate with*
9. Run `task add-static-key-to-env`. *Note: This will create a bearer token that is used for authentication*
10. Run `task start-client` *Note: Recreate the containers so the static key is included in the containers*
10. Run `task generate`.
11. Run `task links` to open all available links and open the application / service you want

*Note: If the local environment is already running for a client, skip steps 1 & 2.*

*It is possible that you get some errors when importing keycloak or mongo, for this the fix is to remove the keycloak realm of the client you want to work on and also to remove the mongo database. Through terminal this is possible but not easy and would suggest to use the GUI https://www.mongodb.com/try/download/compass also make sure to re-run step 7 task add-static-key-to-env*

### Stopping environments

#### Stop a client environment
- Run `task stop-client’.

#### Stop the root environment
- Run `task stop-root’.

#### Starting a client enviroment
- Run `task start-client’.

### Working on a client

*If you've made adjustments requiring a build, such as installing a new library:*
- Run `task build-client’.

*If you've made adjustments to the queries:*
- Run `task generate’.

*show all links:*
1. Go to client directory
2. Run `task links`

*login*
- user: `developers@inuits.eu`
- password: `developers`
  *this is in most cases but can be changed in the client realm import


## Repo structure

### Main repo

#### Services
- In the main folder, all repos for services used by multiple clients will be pulled.
    - For non-client-specific configurations, add them to `docker-compose.yml`.
    - Client-specific configurations should go in `docker-compose-include` or in the client's docker-compose file.

  In `docker-compose-include`, you can use client names and specific environment variables. If a service is not needed for every client, or if `docker-compose-include` is insufficient, place the service in the client-specific docker-compose.

#### Modules
- Modules play a critical role in customizing the user interface for each client. They determine the layout of the dashboard components through specific GraphQL queries, a required feature for personalizing the client experience. Additionally, modules have the capability to add optional client-specific endpoints to the GraphQL service, further enhancing the adaptability and functionality for individual client needs.

#### Taskfile
- Contains commands to manage the Elody common repo and the clients.
- Use `task --list` for more details.
- Taskfile installation required: [Taskfile Installation](https://taskfile.dev/installation/)

#### Docker-compose data
- For additional local setup content such as data imports, entrypoint files, or docker files, place them in the `docker-compose` folder.

#### env.dist
- A template for the environment file for common services. Usually pre-configured and copied to `.env` when preparing the repo.
- **Important**: Make persistent changes in `dist.env`, not `.env`.

#### repositories.txt
- Determines which repositories are pulled for the project, including services, modules, and clients.
- The structure of the file is as follows: `${repo-url} ${folder-to-clone-to}` each line in the file specifies a repository URL and the target folder for cloning.

### Client repo

#### Client collection module
The client collection module is a key component for tailoring the Elody platform to meet specific client needs. It encompasses:

1. **Hooks**: Code segments that execute before or after an existing endpoint, allowing for additional processing or validations as needed.

2. **Policies**: Designed to define and enforce read and write permissions for client-specific entities, ensuring data is accessed and manipulated securely and appropriately.

3. **Extra Endpoints**: Custom endpoints embedded with client-specific domain logic. These endpoints are crucial for offering functionalities that are uniquely tailored to each client's operational requirements.

4. **Data Serializers for LOD Formats**: These serializers are responsible for converting Elody data into various Linked Open Data (LOD) formats, like RDF (Resource Description Framework). This capability is essential for integrating Elody with different LOD systems and enhancing data interoperability.

5. **Data Import Serializers**: Tools for importing data from external sources into the Elody data structure. These serializers are adaptable to a wide range of data formats, both LOD and non-LOD, thereby offering flexibility in handling diverse data integration scenarios.

#### client-frontend folder
- Contains frontend files:
- Bootstrap file with a list of GraphQL modules to load.
- Client-specific Tailwind theme and logo.

#### client graphQL module
- Each instance uses the same frontend PWA build, served with Nginx.
- Customization per client is achieved through GraphQL queries to specify UI elements like entity types, forms, views, filters, and search pages.

#### docker-compose and script
- Similar to the root repo, but with client-specific files.
- Essential items include initial database data, Keycloak realm export, and collection-API configurations.

#### Taskfile
- Add client-specific tasks here.
- Default task pulls all repositories for the client.

#### env.dist
- A template for the environment file for client services. Configure new clients by adjusting variables, primarily the client name.
- **Important**: Make persistent changes in `dist.env’, not `.env`.
- If you make changes in the client `.env` and recreated it with `task remove-env && task create-env`, don't forget to `task add-static-key-to-env`

#### repositories.txt (client specific)
- Functions similarly to the `repositories.txt` in the Main Repo.
- Determines which repositories are pulled specifically for the client, including client-specific services, modules, and configurations.
- The file format follows the same structure as in the Main Repo.

