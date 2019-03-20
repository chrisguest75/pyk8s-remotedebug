FROM python:3.7.2-stretch

#RUN apt install --no-cache python3-dev g++ linux-headers libffi-dev bash openssl-dev 
RUN pip install pipenv

ARG USERID=1000
ARG GROUPID=1000
RUN addgroup --system --gid $GROUPID appuser
RUN adduser --system --uid $USERID --gid $GROUPID appuser

RUN mkdir /workbench

WORKDIR /workbench
COPY ./Pipfile /workbench/Pipfile
COPY ./Pipfile.lock /workbench/Pipfile.lock 
COPY ./main.py /workbench/main.py

#RUN set -ex && pipenv install --deploy --system
RUN pipenv install --deploy --system --dev

# set to no debugger.
ENV DEBUGGER=False
ENV WAIT=False

USER appuser
EXPOSE 5678
CMD ["python3", "-u", "./main.py"]
