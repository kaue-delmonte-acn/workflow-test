import os
import sys
import subprocess
import psycopg2
import json
from urllib.request import urlopen
from urllib.error import URLError

CKAN_INI = os.environ.get("CKAN_INI", "/srv/app/ckan.ini")


def checkDatabaseConnection():
    print("[prerun] DATABASE - checking connection")
    connectionString = os.environ.get("CKAN_SQLALCHEMY_URL")
    if not connectionString:
        print("[prerun] DATABASE - ERROR: CKAN_SQLALCHEMY_URL not defined.")
        sys.exit(1)
    try:
        connection = psycopg2.connect(connectionString)
    except psycopg2.Error as error:
        print(f"[prerun] DATABASE - ERROR: {error}")
        sys.exit(1)
    else:
        connection.close()


def setupDatabase():
    print("[prerun] DATABASE - initializing/upgrading")
    CMD = ["ckan", "-c", CKAN_INI, "db", "init"]
    try:
        subprocess.check_output(CMD, stderr=subprocess.STDOUT)
        print("[prerun] DATABASE - successfully initialized/upgraded")
    except subprocess.CalledProcessError as error:
        print(f"[prerun] DATABASE - ERROR: {error}")
        sys.exit(1)


def setupPlugins():
    print(f"[prerun] PLUGINS - Setting plugins on {CKAN_INI}")
    plugins = os.environ.get("CKAN__PLUGINS")
    CMD = ["ckan", "config-tool", CKAN_INI, f"ckan.plugins = {plugins}"]
    subprocess.check_output(CMD, stderr=subprocess.STDOUT)
    print("[prerun] PLUGINS - ckan.ini updated")


def checkSolrConnection():
    print("[prerun] SOLR - Checking connection")
    url = os.environ.get("CKAN_SOLR_URL")
    search_url = f"{url}/schema/name?wt=json"
    try:
        connection = urlopen(search_url)
    except URLError as error:
        print(f"[prerun] SOLR - ERROR: {error}")
        sys.exit(1)
    else:
        connectionInfo = connection.read()
        schema = json.loads(connectionInfo)
        output = "loaded" if "ckan" in schema["name"] else "not found"
        print("[prerun] SOLR - Succesfully connected")
        print(f"[prerun] SOLR - CKAN schema {output}")


def rebuildSolrIndex():
    print("[prerun] SOLR - Rebuilding search-index")
    CMD = ["ckan", "search-index", "rebuild"]
    try:
        subprocess.check_output(CMD, stderr=subprocess.STDOUT)
        print("[prerun] SOLR - Succesfully rebuilded search-index")
    except subprocess.CalledProcessError as error:
        print(f"[prerun] SOLR - ERROR: {error}")
        sys.exit(1)


if __name__ == "__main__":
    checkDatabaseConnection()
    setupDatabase()
    setupPlugins()
    checkSolrConnection()
    rebuildSolrIndex()
