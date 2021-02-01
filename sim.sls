## AIRFLOW SIM

airflow_sim_user:
    user.present:
        - name: airflow
        - fullname: airflow
        - uid: 2009
        - gid: 8102
        - shell: /bin/nologin
        - home: /opt/airflow
        - createhome: True

airflowsim_home:
    file.directory:
        - name: /opt/airflow/sim
        - dir_mode: 0755
        - user: airflow
        - group: developers

## manually install virtualenv
## cd /opt/airflow/sim
## python3.6 -m virtualenv venv
## source venv/bin/activate
## python3.6 -m pip install install apache-airflow[postgres,celery,ssh,github_enterprise]
## airflow db init


airflowsim_config:
    file.managed:
        - name: /opt/airflow/sim/airflow.cfg
        - source: salt://{{ slspath }}/files/airflow.cfg.j2
        - template: jinja
        - context: { env: sim, base_url: 8095, flower_port: 5655, worker_log_server_port: 8893 }
        - user: airflow
        - group: developers
        - mode: 644

airflowsim_env:
    file.managed:
        - name: /opt/airflow/sim/.env
        - source: salt://{{ slspath }}/files/env.j2
        - template: jinja
        - context: { env: sim, color: 32a8a2 }
        - user: airflow
        - group: developers
        - mode: 644

airflowsim_webserver:
    file.managed:
        - name: /usr/lib/systemd/system/airflowsim-webserver.service
        - source: salt://{{ slspath }}/files/airflow-webserver.service.j2
        - template: jinja
        - context: { env: sim }
        - user: root
        - group: root
        - mode: 644

airflowsim_scheduler:
    file.managed:
        - name: /usr/lib/systemd/system/airflowsim-scheduler.service
        - source: salt://{{ slspath }}/files/airflow-scheduler.service.j2
        - template: jinja
        - context: { env: sim }
        - user: root
        - group: root
        - mode: 644

airflowsim_worker:
    file.managed:
        - name: /usr/lib/systemd/system/airflowsim-worker.service
        - source: salt://{{ slspath }}/files/airflow-worker.service.j2
        - template: jinja
        - context: { env: sim }
        - user: root
        - group: root
        - mode: 644

combined_sim_service:
    file.managed:
        - name: /opt/airflow/sim/service
        - source: salt://{{ slspath }}/files/service.j2
        - template: jinja
        - context: { env: sim }
        - user: root
        - group: root
        - mode: 755

airflowsim_webserver_svc:
    service.running:
        - name: airflowsim-webserver
        - enable: True
        - watch:
            - file: airflowsim_config

airflowsim_scheduler_svc:
    service.running:
        - name: airflowsim-scheduler
        - enable: True
        - watch:
            - file: airflowsim_config

airflowsim_worker_svc:
    service.running:
        - name: airflowsim-worker
        - enable: True
        - watch:
            - file: airflowsim_config