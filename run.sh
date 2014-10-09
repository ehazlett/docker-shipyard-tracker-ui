#!/bin/bash
ADMIN_USER=${ADMIN_USER:-admin}
ADMIN_PASS=${ADMIN_PASS:-admin}
INFLUXDB_HOST=${INFLUXDB_HOST:-localhost:8083}
INFLUXDB_DATABASE=${INFLUXDB_DATABASE:-shipyard-metrics}
INFLUXDB_USER=${INFLUXDB_USER:-root}
INFLUXDB_PASS=${INFLUXDB_PASS:-root}

echo "$ADMIN_PASS" |htpasswd -ci /etc/users.htpasswd $ADMIN_USER

cat << EOF > /app/config.js
define(['settings'],
function (Settings) {
  return new Settings({
    datasources: {
      influxdb: {
        type: 'influxdb',
        url: "http://$INFLUXDB_HOST/db/$INFLUXDB_DATABASE",
        username: '$INFLUXDB_USER',
        password: '$INFLUXDB_PASS'
      },
      grafana: {
        type: 'influxdb',
        url: "http://$INFLUXDB_HOST/db/$INFLUXDB_DATABASE",
        username: '$INFLUXDB_USER',
        password: '$INFLUXDB_PASS',
        grafanaDB: true
      }
    },
    search: {
      max_results: 20
    },
    default_route: '/dashboard/file/default.json',
    unsaved_changes_warning: true,
    playlist_timespan: "1m",
    window_title_prefix: 'Shipyard Tracker - ',
    plugins: {
      panels: [],
      dependencies: [],
    }
  });
});
EOF
    
nginx -c /etc/nginx.conf
