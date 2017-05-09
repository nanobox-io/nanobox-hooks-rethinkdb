
service_name="RethinkDB"
default_port=28015

wait_for_running() {
  container=$1
  until docker exec ${container} bash -c "ps aux | grep [r]ethinkdb"
  do
    sleep 1
  done
}

wait_for_listening() {
  container=$1
  ip=$2
  port=$3
  until docker exec ${container} bash -c "nc -q 1 ${ip} ${port} < /dev/null"
  do
    sleep 1
  done
}

wait_for_stop() {
  container=$1
  while docker exec ${container} bash -c "ps aux | grep [r]ethinkdb"
  do
    sleep 1
  done
}

verify_stopped() {
  container=$1
  run docker exec ${container} bash -c "ps aux | grep [r]ethinkdb"
  echo_lines
  [ "$status" -eq 1 ] 
}

insert_test_data() {
  container=$1
  ip=$2
  port=$3
  key=$4
  data=$5
  run docker exec ${container} bash -lc "cd /var/tmp; /data/bin/npm install rethinkdb"
  run docker cp util/insert.js ${container}:/var/tmp/insert.js
  run docker exec ${container} bash -lc "/data/bin/node /var/tmp/insert.js $ip $port $key $data"
  echo_lines
}

update_test_data() {
  container=$1
  ip=$2
  port=$3
  key=$4
  data=$5
  run docker exec ${container} bash -lc "cd /var/tmp; /data/bin/npm install rethinkdb"
  run docker cp util/update.js ${container}:/var/tmp/update.js
  run docker exec ${container} bash -lc "/data/bin/node /var/tmp/update.js $ip $port $key $data"
  echo_lines
  [ "$status" -eq 0 ]
}

verify_test_data() {
  container=$1
  ip=$2
  port=$3
  key=$4
  data=$5
  run docker exec ${container} bash -lc "cd /var/tmp; /data/bin/npm install rethinkdb"
  run docker cp util/verify.js ${container}:/var/tmp/verify.js
  run docker exec ${container} bash -lc "/data/bin/node /var/tmp/verify.js $ip $port $key"
  data=$(echo -e "    \"value\": \"${data}\"")
  echo_lines
  echo ${lines[5]}
  echo ${data}
  [ "${lines[5]}" = "${data}" ]
  [ "$status" -eq 0 ]
}

verify_plan() {
  [ "${lines[0]}" = "{" ]
  [ "${lines[1]}" = "  \"redundant\": false," ]
  [ "${lines[2]}" = "  \"horizontal\": false," ]
  [ "${lines[3]}" = "  \"users\": [" ]
  [ "${lines[4]}" = "  ]," ]
  [ "${lines[5]}" = "  \"ips\": [" ]
  [ "${lines[6]}" = "    \"default\"" ]
  [ "${lines[7]}" = "  ]," ]
  [ "${lines[8]}" = "  \"port\": 28015," ]
  [ "${lines[9]}" = "  \"behaviors\": [" ]
  [ "${lines[10]}" = "    \"migratable\"," ]
  [ "${lines[11]}" = "    \"backupable\"" ]
  [ "${lines[12]}" = "  ]" ]
  [ "${lines[13]}" = "}" ]
}