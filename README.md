## Duplicate a GeoServer workspace

Some scripts to help duplicate Geoserver workspace.

To duplicate a specific workspace directly on the file system, we must change:

  - The identifier of XML documents (mandatory);
  - The name of root directory (mandatory);
  - The names of inside directories (optional);
  - Some patterns inside documents, like prefix of Layers, Workspace, Namespace... (optional);

Even using these scripts, we still need to inspect the files and manually change other things like datastore description and database parameters used to connect to the target database, if applicable.

Specific things like SQL views also need attention.

After copying to the target instance, follow the steps:

  - Reload the GeoServer catalogue;
  - Open each Layer to update the bbox if necessary;
  - Manually change each layer-related style;
  - Open each workspace in the web UI administrator and save without changing anything. I don't know why, but in my tests it's necessary;

In this work, the goal is to duplicate the workspace, so I need to change all identifiers related to GeoServer objects like WorkspaceInfoImpl, NamespaceInfoImpl, DataStoreInfoImpl, LayerInfoImpl and FeatureTypeInfoImpl. 

To complete the changes, I duplicate the gwc-layers related files for each layer using the new LayerInfoImpl identifier in the filename and inside the file.


## Start changes

Use the start.sh script to accomplish this.
Before running the script, check the configuration entries within it as shown below.

```sh
# at start.sh script
INPUT_DIR="/home/andre/Scripts/workspace"
```

And another two lists of patterns inside the rename_dirs.sh and replace_in_files.sh scripts.

```sh
# at rename_dirs.sh script
PATTERNS=("amsh:cerh" "AMSh29:CES29" "amz_:cer_" "csAmz_:csCer_")

# at replace_in_files.sh script
PATTERNS=("ams-:cer-" "amsh:cerh" "amz_:cer_" "csAmz_:csCer_" "AMS29:CES" "AMS2:CES" "public.deter_publish_date:deter.deter_publish_date")
```

## Recalculate bbox (optional)

Need attention to implement that.

https://docs.geoserver.org/stable/en/user/rest/api/featuretypes.html


Using Postman to test...

  - Call the URL using GET to retrive the XML document of featuretype;
  - Call the URL using PUT send the same XML document and give the credentials and parameters to recalculate bbox;

```http
# example

http://localhost:8080/geoserver/rest/workspaces/cerh/datastores/CES/featuretypes/cer_states.xml?recalculate=nativebbox,latlonbbox
```