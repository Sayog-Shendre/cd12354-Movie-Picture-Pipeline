FROM public.ecr.aws/docker/library/python:3.10-alpine
RUN adduser -u 1000 -D app
ENV CFLAGS="-Wno-error=incompatible-pointer-types"
RUN apk update && \
apk add --no-cache \
pcre \
pcre-dev \
build-base \
gcc \
linux-headers \
openssl \
libffi-dev \
&& pip install --no-cache-dir pipenv
WORKDIR /app
COPY Pipfile* /app/
RUN pipenv install --system --deploy
COPY . /app
ENV FLASK_APP=__init__.py
ENV FLASK_RUN_HOST=0.0.0.0
ENV FLASK_RUN_PORT=5000
EXPOSE 5000
CMD ["python", "-m", "flask", "run"]
