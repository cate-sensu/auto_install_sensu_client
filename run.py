###########################################################################
# This script will
# 1. check for installed components necessary for running a sensu
#    client on the machine.
# 2. install them if not already installed.
# 3. write to the necessary config files.
# 4. add the required checks (for example, app running, CPU , Memory and more)
# 5. restart the client for the changes to take effect.
###########################################################################

import os
import socket
from bson import json_util as json

def registerClientIfNeeded():
    try:
        installTheNecessaryComponents()
        writeToSensuConfigFile()
        restartTheClient()
        return
    except Exception as err:
        return err


def installTheNecessaryComponents():
    # sudo apt-get install bc   # for the bash memory check
    # gem install mail          # for email handler, in the sensu server
    # gem install carrot-top    # for rabbitmq server
    # pip install pymongo       # for mongo check

    # install the sensu package
    # wget -q http://repos.sensuapp.org/apt/pubkey.gpg -O- | sudo apt-key add -
    # sudo echo "deb     http://repos.sensuapp.org/apt sensu main" | sudo tee -a /etc/apt/sources.list.d/sensu.list
    # sudo apt-get update && sudo apt-get -y install sensu
    # sudo apt-get install -y ruby ruby-dev build-essential
    # sudo gem install sensu-plugin
    return True

def writeToSensuConfigFile():

    # sudo vi /etc/sensu/conf.d/rabbitmq.json
    # {
    #     "rabbitmq": {
    #         "vhost": "/",
    #         "host": "sensu",
    #         "port": 5672,
    #         "user": "guest",
    #         "password": "guest"
    #     }
    # }

    sensuPath = '/etc/sensu'
    sensuClientDirectory = sensuPath + '/conf.d/'
    sensuClientFileName = sensuClientDirectory + 'client.json'
    hostName = socket.gethostname()
    internalIp = getInternalIp(hostName)

    client_json = {
        "client": {
            "name": hostName,
            "address": internalIp,
            "subscriptions": [ "ALL" ],
            "logo_url": "http://cdn.frontpagemag.com/wp-content/uploads/2014/03/worker-construction-grinder-machiine.jpg"
        }
    }

    if not os.path.exists(sensuPath):
        os.system('sudo mkdir ' + sensuPath)

    if not os.path.exists(sensuClientDirectory):
        os.system('sudo mkdir ' + sensuClientDirectory)

    os.system('sudo chmod -R 777 ' + sensuClientDirectory)
    open(sensuClientFileName, "a").close()
    file = open(sensuClientFileName,'w')
    file.write(json.dumps(client_json))
    file.close()

def restartTheClient():
    os.system('sudo service sensu-client restart')

def getInternalIp(hostName):
    try:
        return socket.gethostbyname(hostName)
    except:
        return '0.0.0.0'
