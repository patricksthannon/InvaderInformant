#!/bin/zsh

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

#InvaderInformant.sh

#For script to work you must create a topic on ntfy.sh
#Following add your topic and notify server ip to the variables below (without quotes)

topic=your_ntfy_topic_here 
notifyserver=your_ntfy_server_ip_here #with forward slash at end ie -> ntfy.sh/


function main() {
    # Get local IP (Wi-Fi or Ethernet)
    host_ip=$(ipconfig getifaddr en0)
    [ -z "$host_ip" ] && host_ip=$(ipconfig getifaddr en1)

    if [ -z "$host_ip" ]; then
        echo "❌ Could not detect a local IP address on en0 or en1."
        exit 1
    fi

    subnet=$(echo "$host_ip" | awk -F. '{print $1"."$2"."$3".0/24"}')
    subnet_prefix=$(echo "$host_ip" | awk -F. '{print $1"."$2"."$3}')

    echo "✅ Detected IP: $host_ip"
    echo "🔍 Scanning subnet: $subnet"

    [ ! -f scan.txt ] && touch scan.txt
    mv scan.txt previous_scan.txt

    nmap -sn --max-parallelism 100 "$subnet" > scan.txt

    diff previous_scan.txt scan.txt | grep "$subnet_prefix" > difference.txt

    computers="difference.txt"
    if [ -s "$computers" ]; then
        echo "📡 Changes detected in subnet:"
        while IFS= read -r computer; do
            iostring="${computer:0:1}"
            line=$(echo "$computer" | sed 's/^[<>] //')

            # Extract hostname (optional) and IP
            hostname=$(echo "$line" | grep -oE "Nmap scan report for [^ ]+ \(" | sed 's/Nmap scan report for //' | sed 's/ (//')
            device_ip=$(echo "$line" | grep -oE "$subnet_prefix\.[0-9]+")

            ntfy=$notifyserver$topic
            if [ -n "$device_ip" ]; then
                if [ -n "$hostname" ]; then
                    message="$hostname ($device_ip)"
                else
                    message="$device_ip"
                fi

                if [ "$iostring" = ">" ]; then
                    echo "🆕 New Device/Host Detected on Network: $message"
                    curl -d "New Device/Host Detected on Network: $message" $ntfy
                elif [ "$iostring" = "<" ]; then
                    echo "❌ Device/Host Disconnected from Network: $message"
                    curl -d "Device/Host Disconnected from Network: $message" $ntfy
                fi
            fi
        done < "$computers"
    else
        echo "✅ No device changes detected."
    fi
}

main
