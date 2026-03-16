Metagenomic Cancer Prediction: A Containerized Analysis Pipeline

A reproducible Docker-based environment for analyzing metagenomic data to predict cancer status using machine learning. This project compares classification performance across multiple datasets and validates results against published research.

Shotgun metagenomic data from Vogtmann et al. (2016) and Wirbel et al. (2019) were obtained via the curatedMetagenomicData R package (Pasolli et al., 2017; the exact version was not recorded at time of download., accessed 2022). Both datasets were processed using the MetaPhlAn2 pipeline as part of the curatedMetagenomicData legacy collection.

Both the Python and R containers are accessible through "http://localhost:<port>", 
where <port> is specified in the docker-compose.yml file. Neither requires authentication 
— they open directly in the browser without a password.

The PostgreSQL container does require credentials, which should be specified in a .env 
file. A template is provided as ".env.template".

⚠️ This setup is intended for local development only and should not be exposed to the 
public internet without re-enabling authentication.  