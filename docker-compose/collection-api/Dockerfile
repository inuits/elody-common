
### Base stage
FROM python:3.12-alpine AS base-stage

ENV FLASK_APP=app.py
ARG PROJECT_FOLDER

RUN adduser --disabled-password --home /app --shell /bin/bash app
USER app
WORKDIR /app

COPY collection-api/docker/entrypoint*.sh /
COPY collection-api/docker/run-tests.sh /
COPY collection-api/docker/test-coverage.sh /
COPY collection-api/requirements.txt ./
COPY collection-api/requirements_dev.txt ./
COPY clients/${PROJECT_FOLDER}/client-collection-module/requirements.txt ./module_requirements.txt

RUN echo "export PATH=${PATH}:/app/.local/bin" >> .bashrc

ENTRYPOINT ["/entrypoint.sh"]

### Development stage
FROM base-stage AS development-stage

ENV APP_ENV=dev

COPY collection-api/docker/pip.conf /etc

RUN pip install --no-cache-dir -r requirements.txt -r requirements_dev.txt -r module_requirements.txt

EXPOSE 5000

### Build stage
FROM base-stage AS build-stage

COPY collection-api/docker/pip.conf /etc
COPY collection-api/api ./api

RUN pip install --no-cache-dir -r requirements.txt -r module_requirements.txt

### Production stage
FROM base-stage AS production-stage

ENV APP_ENV=prod

COPY --from=build-stage /app /app

ENV GUNICORN_CMD_ARGS="--workers=3"

EXPOSE 8000
