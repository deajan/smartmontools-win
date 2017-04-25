#!/usr/bin/env python

# setup.py
import sys
try:
	from distutils.core import setup
except:
	print("Missing distutils.core module")
	sys.exit(1)

try:
	import py2exe
except:
	print("Missing py2exe module")
	sys.exit(1)

sys.argv.append("py2exe")

APP_NAME='erroraction_config'

setup(
    name=APP_NAME,
	version='0.2',
	description='smartmontools-win alert GUI',
	author='Orsiris de Jong',
    #windows = [{'script': APP_NAME + ".py",
	#			'icon_resources': [(1, APP_NAME + ".ico")],
	#			'uac_info': "requireAdministrator",
	#			}],
	console=[APP_NAME + ".py"],
				
    zipfile = "shared.lib",
    data_files=[("", [APP_NAME + ".ui"])],
    options= {
        "py2exe": { 
            "includes" : ["sys",
						  "pygubu.builder.tkstdwidgets",
                          "pygubu.builder.ttkstdwidgets",
                          "pygubu.builder.widgets.dialog",
                          "pygubu.builder.widgets.editabletreeview",
                          "pygubu.builder.widgets.scrollbarhelper",
                          "pygubu.builder.widgets.scrolledframe",
                          "pygubu.builder.widgets.tkscrollbarhelper",
                          "pygubu.builder.widgets.tkscrolledframe",
                          "pygubu.builder.widgets.pathchooserinput",],
            "excludes" : ["_ssl",
                          "pyreadline",
                          "difflib",
                          "doctest",
                          "locale",
                          "optparse",
                          "calendar",
						  "doctest",
						  "pdb",
						  "unittest",
						  "difflib",
						  "inspect",
						  ],
            "compressed" : True,
			"optimize": 2,
                          
                    }},
        )

#TODO: remove tcl\tcl8.5\{encoding,demos,tzdata}
