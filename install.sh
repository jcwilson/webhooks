#! env bash

while getopts "n:p:u:c:e:" OPT; do
    case $OPT in
        n) name=$OPTARG ;;
        p) port=$OPTARG ;;
        u) user=$OPTARG ;;
        c) capture_location=$OPTARG ;;
        e) handler=$OPTARG ;;
    esac
done
shift $((OPTIND-1))

[[ -z $name ]] && echo "Must provide -n <name> option" && exit 1

src_dir=$(cd $(dirname $0) && pwd)
capture_location=${capture_location:-}

src_dir=$src_dir port=$port user=$user \
name="${name}" \
capture_location=${capture_location:+-c ${capture_location}} \
handler=${handler:+-e ${handler}} \
eval "cat <<EOF
$(<xinetd.d/webhook)
EOF
" | tee /etc/xinetd.d/webhook-${name}

echo "Created service config at /etc/xinetd.d/webhook"
echo "Refresh xinetd to start service"
