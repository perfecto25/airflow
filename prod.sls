## AIRFLOW PROD

airflow_prod_user:
    user.present:
        - name: airflow
        - fullname: airflow
        - uid: 2009
        - gid: 8102
        - shell: /bin/nologin
        - home: /opt/airflow
        - createhome: True

airflowprod_home:
    file.directory:
        - name: /opt/airflow/prod
        - dir_mode: 0755
        - user: airflow
        - group: developers

## manually install virtualenv
## cd /opt/airflow/prod
## python3.6 -m virtualenv venv
## source venv/bin/activate
## python3.6 -m pip install install apache-airflow[postgres,celery,ssh,github_enterprise]
## airflow db init

airflowprod_config:
    file.managed:
        - name: /opt/airflow/prod/airflow.cfg
        - source: salt://{{ slspath }}/files/airflow.cfg.j2
        - template: jinja
        - context: { env: prod, base_url: 8090, flower_port: 5555, worker_log_server_port: 8793 }
        - user: airflow
        - group: developers
        - mode: 644

airflowprod_env:
    file.managed:
        - name: /opt/airflow/prod/.env
        - source: salt://{{ slspath }}/files/env.j2
        - template: jinja
        - context: { env: prod, color: ff9580 }
        - user: airflow
        - group: developers
        - mode: 644

airflowprod_webserver:
    file.managed:
        - name: /usr/lib/systemd/system/airflowprod-webserver.service
        - source: salt://{{ slspath }}/files/airflow-webserver.service.j2
        - template: jinja
        - context: { env: prod }
        - user: root
        - group: root
        - mode: 644

airflowprod_scheduler:
    file.managed:
        - name: /usr/lib/systemd/system/airflowprod-scheduler.service
        - source: salt://{{ slspath }}/files/airflow-scheduler.service.j2
        - template: jinja
        - context: { env: prod }
        - user: root
        - group: root
        - mode: 644

airflowprod_worker:
    file.managed:
        - name: /usr/lib/systemd/system/airflowprod-worker.service
        - source: salt://{{ slspath }}/files/airflow-worker.service.j2
        - template: jinja
        - context: { env: prod }
        - user: root
        - group: root
        - mode: 644

combined_prod_service:
    file.managed:
        - name: /opt/airflow/prod/service
        - source: salt://{{ slspath }}/files/service.j2
        - template: jinja
        - context: { env: prod }
        - user: root
        - group: root
        - mode: 755

airflowprod_webserver_svc:
    service.running:
        - name: airflowprod-webserver
        - enable: True
        - watch:
            - file: airflowprod_config

airflowprod_scheduler_svc:
    service.running:
        - name: airflowprod-scheduler
        - enable: True
        - watch:
            - file: airflowprod_config

airflowprod_worker_svc:
    service.running:
        - name: airflowprod-worker
        - enable: True
        - watch:
            - file: airflowprod_config