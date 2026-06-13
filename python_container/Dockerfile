# Dockerfile 

FROM jupyter/scipy-notebook:python-3.11.6

RUN pip install psycopg2-binary \
    sqlalchemy \
    scikit-learn \
    xgboost \
    plotly

WORKDIR /home/jovyan/work
