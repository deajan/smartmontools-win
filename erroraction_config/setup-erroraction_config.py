#!/usr/bin/env python

# setup.py
import sys
from distutils.core import setup
import py2exe

sys.argv.append("py2exe")

setup(
    #options = {'py2exe': {'optimize': 2}},
    windows = [{'script': "erroraction_config.py",
				'icon_resources': [(1, "erroraction_config.ico")]}],
    
    zipfile = "shared.lib",
    #console=["smartd-pyngui.py"],
    data_files=[("", ["erroraction_config.ui"])],
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
                          "calendar",],
            "compressed" : True,
                          
                    }},
        )
