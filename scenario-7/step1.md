_There is an issue with the way Katacoda configures the bash shell. Please execute the following command to launch a new shell that is properly configured._

```
bash
```{{execute}}

Now we are ready.


The ModSecurity Core Rule Set are being developed under the umbrella of *OWASP*, the Open Web Application Security Project. The rules themselves are available on *GitHub* and can be downloaded via *git* or with the following *wget* command:

```
cd /apache/conf
```{{execute}}

```
wget https://github.com/coreruleset/coreruleset/archive/v3.3.0.tar.gz
```{{execute}}
```
tar -xvzf v3.3.0.tar.gz
```{{execute}}
```
coreruleset-3.3.0
coreruleset-3.3.0/
coreruleset-3.3.0/.github/
coreruleset-3.3.0/.github/ISSUE_TEMPLATE.md
coreruleset-3.3.0/.gitignore
coreruleset-3.3.0/.gitmodules
coreruleset-3.3.0/.travis.yml
coreruleset-3.3.0/CHANGES
coreruleset-3.3.0/IDNUMBERING
coreruleset-3.3.0/INSTALL
coreruleset-3.3.0/KNOWN_BUGS
coreruleset-3.3.0/LICENSE
coreruleset-3.3.0/README.md
coreruleset-3.3.0/crs-setup.conf.example
coreruleset-3.3.0/documentation/
coreruleset-3.3.0/documentation/OWASP-CRS-Documentation/
coreruleset-3.3.0/documentation/README
...
```

```
sudo ln -s coreruleset-3.3.0 /apache/conf/crs
```{{execute}}

```
cp crs/crs-setup.conf.example crs/crs-setup.conf
```{{execute}}

```
rm v3.3.0.tar.gz
```{{execute}}

This unpacks the base part of the Core Rule Set in the directory `/apache/conf/coreruleset-3.3.0`. We create a link from `/apache/conf/crs` to this folder. Then we copy a file named `crs-setup.conf.example` to a new file `crs-setup.conf` and finally, we delete the Core Rule Set tar file.

The setup file allows us to tweak many different settings. It is worth a look - if only to see what is included. However, we are OK with the default settings and will not touch the file: We just make sure it is available under the new filename `crs-setup.conf`. Then we can continue to update the configuration to include the rules files.
