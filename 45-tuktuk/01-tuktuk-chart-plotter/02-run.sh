#!/bin/bash -e

on_chroot << EOF

   echo " - Install tuktuk"
   cd /opt/
   git clone https://gitlab.com/FredericGuilbault/tuktuk-chart-plotter
   cd tuktuk-chart-plotter
   git checkout lysmarine/master

   npm install -g --unsafe-perm --loglevel error # --cache /tmp/empty-cache;
   echo " -package Install done"
   npm install --unsafe-perm webpack

   NODE_ENV=production npm run bundle:js
   NODE_ENV=production npm run bundle:css
   echo " - Bundle done"

   cd /
   echo " Compiling Done for tuktuk"
EOF

install files/client-config.json "${ROOTFS_DIR}/opt/tuktuk-chart-plotter/client-config.json"
install -m 644 -v files/tuktuk.service  "${ROOTFS_DIR}/etc/systemd/system/tuktuk.service"

on_chroot << EOF
  systemctl enable tuktuk.service

  rm -rf /opt/tuktuk-chart-plotter/charts
  ln -s /srv/charts /opt/tuktuk-chart-plotter/charts;
EOF
