#! /bin/bash

ftp -n <<EOF
open files.000webhost.com
user thanos-reports thanos_reports@123
cd public_html
put report.html
EOF