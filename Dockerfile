# Dockerfile 

FROM jupyter/scipy-notebook:python-3.11.6

RUN pip install psycopg2-binary \
    sqlalchemy \
    scikit-learn \
    xgboost \
    plotly

COPY notebooks/ /home/jovyan/work/

WORKDIR /home/jovyan/work
