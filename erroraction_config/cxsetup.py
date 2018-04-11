from cx_Freeze import setup, Executable


import os.path
PYTHON_INSTALL_DIR = os.path.dirname(os.path.dirname(os.__file__))

os.environ['TCL_LIBRARY'] = os.path.join(PYTHON_INSTALL_DIR, 'tcl', 'tcl8.6')
os.environ['TK_LIBRARY'] = os.path.join(PYTHON_INSTALL_DIR, 'tcl', 'tk8.6')

options = {
    'build_exe': {
        'include_files':[
            os.path.join(PYTHON_INSTALL_DIR, 'DLLs', 'tk86t.dll'),
            os.path.join(PYTHON_INSTALL_DIR, 'DLLs', 'tcl86t.dll'),
            'erroraction_config.ui',
            'smartd_pyngui.ui',
         ],
         #'includes':["pygubu.builder"],
         #'excludes':["PyQt4.QtSql", "sqlite3", 
		#				"scipy.lib.lapack.flapack",
		#				"PyQt4.QtNetwork",
		#				"PyQt4.QtScript",
		#				"numpy.core._dotblas", 
		#				"PyQt5", "email", "http", "pyodoc_data", "unittest", "xml", "urllib"],
		"optimize": 2,
    },
}


# On appelle la fonction setup
setup(
	options = options,
    name = "smartd_pyngui",
    version = "0.3.0.2",
    description = "Smartmontools-win GUI",
    executables = [Executable("erroraction_config.py", icon= 'erroraction_config.ico', base = None), Executable("smartd_pyngui.py", icon= 'smartd_pyngui.ico', base = None)]
)
