#!/user/bin/python3

import re
import argparse
import requests
import logging
import time
from zipfile import ZipFile
from bs4 import BeautifulSoup

logging.basicConfig(level=logging.INFO)

track_downloaded = []

def download_file(url, dest="./"):
    for i in range (3):
        try:
            get_response = requests.get(url,stream=True)
            file_name  = url.split("/")[-1]
            path_to_file = dest + file_name
            with open(path_to_file, 'wb') as f:
                for chunk in get_response.iter_content(chunk_size=1024):
                    if chunk: # filter out keep-alive new chunks
                        f.write(chunk)
        except:
            logging.info("Download error. Sleep for 30s and try again !!!")
            time.sleep(30)
        else:
            break
    return file_name

def download_latest_compatible_plugin(plugin_name, current_jenkins_version, download_dependencies = False, destination = "./"):
    """
        Example usage:
        download_plugin("ansible", "2.261.3")
        => It will download the latest compatible ansible plugin for jenkins 2.261.3

        download_plugin("ansible", "1.1", "2.261.3")
        => It will download ansible plugin v 1.1 for jenkins.
        If not compatible, it will terminate
    """
    status_code = 0
    if plugin_name in track_downloaded:
        logging.info("Plugin {} downloaded. Exiting ...".format(plugin_name))
        return
    base_url = "https://updates.jenkins-ci.org"
    status_code = 0
    for i in range (3):
        try:
            page = requests.get(base_url + "/download/plugins/" + plugin_name, timeout = 10, headers={'User-Agent': 'My User Agent 1.0'})
        except:
            logging.info("Request Error. Sleep for 30s and try again !!!")
            time.sleep(30)
        else:
            status_code = page.status_code
            content = page.content
            break
    if (status_code == 404):
        print("Plugin doesn't exist, please check its name. Exiting ...")
        return

    soup = BeautifulSoup(content, "html.parser")
    artifact_elements = soup.find(class_="artifact-list")
    version_elements = artifact_elements.find_all(class_="version")

    path_download = ""
    plugin_version = ""
    required_jenkins_version = ""
    check = False

    # Iterate through all versions
    for v_element in version_elements[1:]:
        core_dependency_element = v_element.next_sibling.find(class_="core-dependency")
        t = re.search("Requires Jenkins (.+)", core_dependency_element.text)

        # Get plugin version, path download and require jenkins version
        plugin_version = v_element.text
        path_download = v_element["href"]
        required_jenkins_version = t[1]

        # If current jenkins version is okay, break the loop
        if (current_jenkins_version >= required_jenkins_version):
            check = True
            break

    if (not check):
        logging.info("Plugin: {}:{} not download".format(plugin_name,plugin_version))
        logging.info("Current jenkins version: " + current_jenkins_version)
        logging.info("Required Jenkins version: " + required_jenkins_version)
        return

    logging.info("Plugin name: " + plugin_name)
    logging.info("Plugin version compatible: " + plugin_version)
    logging.debug("Link to download: " + base_url + path_download)
    logging.info("Downloading plugin {}:{}...".format(plugin_name,plugin_version))
    file = download_file(base_url + path_download, destination)
    track_downloaded.append(plugin_name)
    logging.info("-----------------------------")

    if (not download_dependencies):
        logging.info("Not downloading dependencies. Exiting ...")
        logging.info("------------------")
        return
    for i in range(3):
        try:
            logging.info("#{} Downloading {}'s dependencies: ".format(i, plugin_name))
            with ZipFile("{}.hpi".format(destination+plugin_name)) as hpi_archive:
                manifest_mf = hpi_archive.read('META-INF/MANIFEST.MF')
        except:
            logging.info("File download not complete. Retry in 30s")
            time.sleep(30)
        else:
            break
    manifest = (manifest_mf.decode("utf-8")).replace("\r\n ","")
    temp = re.search("Plugin-Dependencies: (.+)",manifest)
    if temp == None:
        logging.info("No dependency. Exiting ...")
        logging.info("---------------")
        return
    dependencies = temp[1]
    logging.info("{}'s dependencies: {}".format(plugin_name,dependencies))
    list_of_deps = re.split(",", dependencies)

    for dep in list_of_deps:
        dep = dep.replace(";resolution:=optional","")
        dep_plugin_name = re.split(":",dep)[0]
        #dep_plugin_version = re.split(":",dep)[1]
        download_latest_compatible_plugin(dep_plugin_name, current_jenkins_version, download_dependencies= True, destination=destination)

def main():
    jenkins_version = "2.261.3"
    # download_plugin(plugin_name="ansible", current_jenkins_version=jenkins_version, download_dependencies=True)
    # download_plugin(plugin_name="ant", current_jenkins_version=jenkins_version, download_dependencies=True)

    # Initialize the parser
    parser = argparse.ArgumentParser(
        description="Script to download latest compatible jenkins plugin and its dependencies (optional)"
    )

    # Add the parameters positional/optional
    parser.add_argument('-n','--name', help="Plugin name", type=str)
    parser.add_argument('-d','--destination', help="Destination to download", type=str, default="./")
    parser.add_argument('-v','--version', help="Jenkins current version", type=str, required=True)
    parser.add_argument('-f','--file', help="List of plugin name", type=str)
    parser.add_argument('--dependency',help='download dependency: yes|no', type=str, default="yes")

    # Parse the arguments
    args = parser.parse_args()
    print(args.file)

    download_deps = True
    destination = args.destination

    if args.dependency != "yes":
        install_dependency = False
    if destination[-1] != "/":
        destination += "/"
    logging.info("destination :" + destination)
    list_of_plugins = []
    if args.file != None:
        with open(args.file,"r") as file:
            plugins = file.readlines()
        for plugin in plugins:
            list_of_plugins.append(plugin.strip())
    if args.name != None:
        list_of_plugins.append(args.name)

    for plugin in list_of_plugins:
        download_latest_compatible_plugin(
            plugin_name=plugin,
            current_jenkins_version=args.version,
            download_dependencies=download_deps,
            destination=destination
        )

main()
