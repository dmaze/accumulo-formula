{%- from 'hadoop/settings.sls' import hadoop with context %}
{%- from 'zookeeper/settings.sls' import zk with context %}
{%- from 'accumulo/settings.sls' import accumulo with context %}

{%- set test_suite_logroot = accumulo.log_root + '/continuous_test' %}
{%- set test_suite_home    = '/home/accumulo/continuous_test' %}

copy-testsuite:
  cmd.run:
    - user: accumulo
    - name: rsync -r --exclude logs {{ accumulo.prefix }}/test/system/continuous/* {{ test_suite_home }}
    - unless: test -d {{ test_suite_home }}

{{ test_suite_logroot }}:
  file.directory:
    - user: accumulo
    - group: accumulo

{{ test_suite_home}}/create_ci_table:
  file.managed:
    - user: accumulo
    - group: accumulo
    - mode: 755
    - contents: |
        accumulo shell -u root -p {{ accumulo.secret }} -e "createtable ci"

# the run-verify.sh script for some reason tries to find jar files in hdfs
# this script can be used to put them there
{{ test_suite_home}}/prepare_accumulo_run_verify.sh:
  file.managed:
    - source: salt://accumulo/testconf/prepare_verify_hack.sh
    - mode: 755
    - user: hdfs
    - group: hadoop
    - template: jinja
    - context:
      dfs_command: {{ hadoop.dfs_cmd }}

{{ test_suite_home }}/logs:
  file.symlink:
    - target: {{ test_suite_logroot }}

{{ test_suite_home }}/continuous-env.sh:
  file.managed:
    - user: accumulo
    - source: salt://accumulo/testconf/continuous-env.sh
    - template: jinja
    - context:
      accumulo_prefix: {{ accumulo.prefix }}
      hadoop_prefix: {{ hadoop.alt_home }}
      zookeeper_home: {{ zk.alt_home }}
      java_home: {{ accumulo.java_home }}
      instance_name: {{ accumulo.instance_name }}
      zookeeper_host: {{ zk.zookeeper_host }}
      secret: {{ accumulo.secret }}
      continuous_log_root: {{ test_suite_logroot }}

add-controlfiles:
  file.managed:
    - user: accumulo
    - contents: |
{%- for h in accumulo.accumulo_slaves %}
        {{ h }}
{%- endfor %}
    - names:
      - {{ test_suite_home }}/ingesters.txt
      - {{ test_suite_home }}/walkers.txt
      - {{ test_suite_home }}/batch_walkers.txt
      - {{ test_suite_home }}/scanners.txt


# continuous test suite relies on pssh
{%- if grains['os'] in ['Amazon', 'Ubuntu'] %}
pssh:
  pkg.installed
{%- elif grains['os'] in ['CentOS'] %}
install-pssh-directly:
  cmd.run:
    - name: yum -y install {{ accumulo.pssh_rpm_source_url }}
    - unless: test -x /usr/bin/pssh
{%- endif %}

# fix the ubuntu packaging decision to leave the name pssh for putty
{%- if grains['os'] in ['Ubuntu'] %}
/usr/local/bin/pssh:
  file.symlink:
    - target: /usr/bin/parallel-ssh
    - require:
      - pkg: pssh
{%- endif %}

{{ test_suite_home }}/splits:
  file.recurse:
    - source: salt://accumulo/development/splits
    - user: accumulo
    - group: accumulo
    - dir_mode: 755
    - file_mode: 644

