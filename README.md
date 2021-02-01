# Apache AIRFLOW

see article explaining full setup:

https://perfecto25.medium.com/runnig-airflow-on-separate-environments-592f023f0232


## Install new Airflow environment (ie, SIM )

create new SIM environment (separate from Prod)

    mkdir /opt/airflow/sim 
    cd /opt/airflow/sim
    python3.6 -m virtualenv venv
    source venv/bin/activate
    pip install apache-airflow['postgres']

create DB user

    # if user is not present (should be present due to Prod environment)
    postgres=# CREATE USER airflow PASSWORD 'airflow';
    CREATE ROLE

    postgres=# CREATE DATABASE airflowsim;
    CREATE DATABASE
    
    postgres=# grant all privileges on database airflowsim to airflow;
    GRANT

Initialize DB (leave virtualenv)
    
    /opt/airflow/sim> source .env
    
    # now init virtualenv
    /opt/airflow/sim> source venv/bin/activate
    (venv) /opt/airflow/sim> airflow db init


Create Fernet key (update airflow.cfg with Fernet key)
    
    pip install cryptography
    python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
    
Update Flask secret key in airflow.cfg (generate new key)
    
    openssl rand -hex 30
    paste into config file, secret_key

Create Admin user
    
    source .env
    airflow users create -f Joe -l Smith -p abracadabra -r Admin -u jsmith -e jsmith@company.com
    

Change Background color and other settings via ENV variable

https://airflow.apache.org/docs/apache-airflow/stable/configurations-ref.html#navbar-color

## Postgres Backups

cron backup

    root@server:opt $ runuser -l postgres  -c 'pg_dump -O -F c -f /opt/airflow/prod/backups/backup.dat -Z 3 --blobs -p 5432 -h localhost -d airflowprod'