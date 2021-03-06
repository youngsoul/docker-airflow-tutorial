FROM python:3.7-slim-buster

RUN apt-get update -yqq \
    	&& apt-get upgrade -yqq \
    	&& apt-get install -yqq --no-install-recommends \
	apt-utils \
	build-essential \
	libffi-dev \
	libpq-dev \
	libssl-dev \
	python3-pandas \
	python3-numpy

RUN apt-get install -y curl

ENV PYTHONPATH="${PYTHONPATH}:/usr/lib/python3/dist-packages"
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
RUN pip install -U pip setuptools wheel \
	&& pip install pyOpenSSL \
    	&& pip install apache-airflow[crypto,aws,slack,postgres]

COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 8080

ENV AIRFLOW_HOME=/app/airflow
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False
ENV AIRFLOW__CORE__LOAD_DEFAULT_CONNECTIONS=False
ENV AIRFLOW__CORE__FERNET_KEY=this-should-be-unique-and-secret
ENV AIRFLOW__WEBSERVER__EXPOSE_CONFIG=True

COPY ./airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

ENTRYPOINT [ "/entrypoint.sh" ]
