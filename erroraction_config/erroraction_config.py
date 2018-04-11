#!/usr/bin/env python
# -*- coding: utf-8 -*-

#### BASIC FUNCTIONS & DEFINITIONS #########################################################################

class Constants:
	"""Simple class to use constants
	usage
	_CONST = Constants
	print(_CONST.NAME)
	"""
	APP_NAME="erroraction_config"
	APP_VERSION="0.3"
	APP_BUILD="2018032901"
	APP_DESCRIPTION="smartmontools for Windows mail config"
	CONTACT="ozy@netpower.fr - http://www.netpower.fr"
	AUTHOR="Orsiris de Jong"
	
	ERRORACTION_CMD_FILENAME="erroraction.cmd"
	ERRORACTION_CONFIG_FILENAME="erroraction_config.cmd"
	MAILSEND_BINARY="mailsend.exe"
	
	IS_STABLE=True

	LOG_FILE=APP_NAME + ".log"

	def __setattr__(self, *_):
		pass
    
_CONSTANT = Constants

#### LOGGING & DEBUG CODE ####################################################################################

import os

try:
	os.environ["_DEBUG"]
	_DEBUG = True
except:
	_DEBUG = False

import tempfile
import logging
from logging.handlers import RotatingFileHandler

logger = logging.getLogger()

# Set file log (try temp log file if not allowed to write to current dir)
try:
	logFileHandler = RotatingFileHandler(_CONSTANT.LOG_FILE, mode='a', encoding='utf-8', maxBytes=1000000, backupCount=1)
except:
	logFileHandler = RotatingFileHandler(tempfile.gettempdir() + os.sep + _CONSTANT.LOG_FILE, mode='a', encoding='utf-8', maxBytes=1000000, backupCount=1)

logFileHandler.setLevel(logging.DEBUG)
logFileHandler.setFormatter(logging.Formatter('%(asctime)s :: %(levelname)s :: %(message)s'))
logger.addHandler(logFileHandler)

# Set stdout log
logStdoutHandler = logging.StreamHandler()
if _DEBUG == True:
	logStdoutHandler.setLevel(logging.DEBUG)
else:
	logStdoutHandler.setLevel(logging.ERROR)
logger.addHandler(logStdoutHandler)

#### IMPORTS ################################################################################################

import sys
import getopt
import platform									# Detect OS
import re										# Regex handling
import time										# sleep command
import codecs									# unicode encoding
from subprocess import Popen, PIPE				# call to external binaries
import base64									# Support base64 mail passwords

from datetime import datetime

# GUI
try:
	import tkinter as tk		# Python 3
	from tkinter import messagebox
except:
	import Tkinter as tk		# Python 2
	import tkMessageBox as messagebox

try:
	import pygubu					# GUI builder
except:
	logger.critical("Cannot find pygubu module. Try installing it with python -m pip install pygubu")
	sys.exit(1)
	
# Manually resolve dependancies from pygubu with nuitka / other freezers like cx_freeze (Thanks to pygubu author Alejandro https://github.com/alejandroautalan)
# As a side effect, show various messages in console on startup
import nuitkahelper

if platform.system() == "Windows":
	import ctypes			# In order to perform UAC call

logger.info("Running on python " + platform.python_version() + " / " + str(platform.uname()))

#### ACTUAL APPLICATION ######################################################################################

CONFIG = "" # Contains full config as Configuration class

class Configuration:
	errorActionCmdPath = ""
	
	def __init__(self, filePath= ''):
		"""Determine smartd configuration file path"""
		
		# __file__ variable doesn't exist in frozen py2exe mode, get appRoot
		try:
			self.appRoot = os.path.dirname(os.path.abspath(__file__))
		except:
			self.appRoot = os.path.dirname(os.path.abspath(sys.argv[0]))
		
		try:
			#TODO: undo double checked, here and in readconf
			if not os.path.isfile(filePath):
				raise TypeError
			else:
				self.errorActionCmdPath = filePath
		except:
			#rootWindow.widthdraw()
			msg="Wrong configuration file path provided."
			logger.critical(msg)
			messagebox.showinfo("Error", msg)
			sys.exit(1)

class Application:
	"""pygubu tkinter GUI class"""
	
	configValues = ['MAIL_ALERT', 'SOURCE_MAIL', 'DESTINATION_MAIL', 'SMTP_SERVER', 'SMTP_PORT',
	'LOCAL_ALERT', 'WARNING_MESSAGE', 'COMPRESS_LOGS', 'DEVICE_LIST', 'SMART_LOG_FILE', 'ERROR_LOG_FILE', 'PROGRAM_PATH']
					
	authValues = ['SMTP_USER', 'SMTP_PASSWORD', 'SECURITY']
	
	def __init__(self, master, configDict):
		self.master = master
		self.configDict = configDict
		self.builder = builder = pygubu.Builder()

		# Load GUI xml description file
		filePath = os.path.join(CONFIG.appRoot, _CONSTANT.APP_NAME + ".ui")
		try:
			self.builder.add_from_file(filePath)
		except Exception as e:
			logger.critical("Cannot find ui file [" + filePath + "].")
			logger.debug(e)
			sys.exit(1)

		self.mainwindow = builder.get_object('MainFrame', master)
		
		# Bind GUI actions to functions
		self.builder.connect_callbacks(self)
		callbacks = {
			'onUseAuthentication': self.onUseAuthentication,
			'onTriggerAlert': self.onTriggerAlert,
			'onSaveAndExit': self.onSaveAndExit,
		}
		self.builder.connect_callbacks(callbacks)

		# Read config values but prefer passed arguments over read ones
		tempDict = self.configDict
		self.configDict = readErrorConfigFile(CONFIG.errorActionCmdPath)
		self.configDict.update(tempDict)
			
		# Populate values in GUI
		for key, value in self.configDict.items():
			try:
				try:
					self.builder.get_object(key, master).delete("1.0", "end")
				except:
					self.builder.get_object(key, master).delete("0", "end")

				self.builder.get_object(key, master).insert("end", value)
				self.builder.get_variable(key).set(value)
			except:
				if value == "yes":
					try:
						self.builder.get_object(key, master).select()
					except:
						pass
				elif value == "no":
					try:
						self.builder.get_object(key, master).deselect()
					except:
						pass

		if "SMTP_USER" in self.configDict:
			self.builder.get_object('UseAuthentication', master).select()
			self.onUseAuthentication()

	def prepareConfigDict(self):
		self.conficDict = {}
		values = self.configValues
		if self.builder.get_variable('useAuthentication').get() == True:
			values.extend(self.authValues)
			
		for key in values:
			try:
				self.configDict[key] = self.builder.get_object(key, self.master).get()
			except:
				pass
			try:
				self.configDict[key] = self.builder.get_object(key, self.master).get("1.0", "end")
			except:
				pass
			try:
				self.configDict[key] = self.builder.get_variable(key).get()
			except:
				pass
	
	def onUseAuthentication(self):
		if self.builder.get_variable('useAuthentication').get() == True:
			background = "#aaffaa"
		else:
			background = "#aaaaaa"
		
		for key in self.authValues:
			self.builder.get_object(key)['background']=background
	
	def onTriggerAlert(self):
		self.prepareConfigDict()
		writeErrorConfigFile(CONFIG.errorActionCmdPath, self.configDict)
		TriggerAlert(self.configDict)
		
	def onSaveAndExit(self):
		try:
			self.prepareConfigDict()
			writeErrorConfigFile(CONFIG.errorActionCmdPath, self.configDict)
			messagebox.showinfo('Information', 'Configuration saved')
		except:
			messagebox.showinfo('Error', 'Guru meditation failure !')
			return False
			
		sys.exit(0)

def stringToBase64(s):
    return base64.b64encode(s.encode('utf-8'))

def base64ToString(b):
    return base64.b64decode(b).decode('utf-8')

def readErrorConfigFile(fileName):
	if not os.path.isfile(fileName):
		logger.info("No suitable [" + _CONSTANT.ERRORACTION_CONFIG_FILENAME + "] file found, creating new file [" + CONFIG.errorActionCmdPath + "].")
		
		return False
	
	try:
		fileHandle = open(fileName, 'r')
	except Exception as e:
		msg="Cannot open config file [ " + fileName + "]."
		logger.error(msg)
		logger.debug(e)
		messagebox.showinfo("Error", msg)
		return False
		
	try:
		configDict = {}
		for line in fileHandle.readlines():
			if not line[0] == "#" and not line[0] == " " and not line[0] == "\n" and not line[0] == "\r":
				conf = line.split('=', 1)
				key = conf[0].replace('SET ', '', 1).replace('set ', '', 1)
				if len(conf) > 1:
					value = conf[1].strip()
					if key == "SMTP_PASSWORD":
						value = base64ToString(value)
					configDict[key] = value
					
		logger.debug("Read: " + str(configDict))
	except Exception as e:
		msg="Cannot read in config file [" + fileName + "]."
		logger.error(msg)
		logger.debug(e)
		messagebox.showinfo("Error", msg)
		return False
		
	try:
		fileHandle.close()
		return configDict
	except Exception as e:
		logger.error("Cannot close file [" + fileName + "].")
		logger.debug(e)

def writeErrorConfigFile(fileName, configDict):
	logger.debug("Writing " + str(configDict))
	configLines = ""
	for key, value in configDict.items():
		if key == "SMTP_PASSWORD":
			try:
				configLines += "SET " + key + "=" + stringToBase64(value).decode('utf-8') + "\n"
			except Exception as e:
				logger.critical("Cannot encode " + key)
				sys.exit(1)
		else:
			configLines += "SET " + key + "=" + value + "\n"
	
	try:
		fileHandle = open(fileName, 'w')
	except Exception as e:
		msg="Cannot open config file [ " + fileName + "]."
		logger.error(msg)
		logger.debug(e)
		messagebox.showinfo("Error", msg)
		return False
		
	try:
		fileHandle.write(":: This file was generated on " + str(datetime.now()) + " by " + _CONSTANT.APP_NAME + " " + _CONSTANT.APP_VERSION  + "\n:: http://www.netpower.fr\n")
		fileHandle.write(configLines)
	except Exception as e:
		msg="Cannot write config file [ " + fileName + "]."
		logger.error(msg)
		logger.debug(e)
		messagebox.showinfo("Error", msg)
		return False
	try:
		fileHandle.close()
	except Exception as e:
		logger.error("Cannot close file [" + fileName + "].")
		logger.debug(e)

def TriggerAlert(configDict):
	erroraction_cmd = CONFIG.appRoot + os.sep + ".." + os.sep + _CONSTANT.ERRORACTION_CMD_FILENAME

	if not os.path.isfile(erroraction_cmd):
		erroraction_cmd = CONFIG.appRoot + os.sep + _CONSTANT.ERRORACTION_CMD_FILENAME
		if not os.path.isfile(erroraction_cmd):
			msg="Cannot find [ " + erroraction_cmd + "]."
			logger.error(msg)
			messagebox.showinfo("Error", msg)
			return False

	command=[erroraction_cmd, '--test']

	pHandle = Popen(command, stdout=PIPE, stderr=PIPE)
	output, err = pHandle.communicate()
	if not pHandle.returncode == 0:
		msg="Cannot execute test action:\r\n" + output.decode('iso-8859-1') + "\r\n" + err.decode('iso-8859-1')
		logger.error(msg)
		messagebox.showinfo('Error', msg)
		return False
		
	messagebox.showinfo('Information', 'Finished testing alert action.')	
				
def usage():
	print(_CONSTANT.APP_NAME + " v" + _CONSTANT.APP_VERSION + " " + _CONSTANT.APP_BUILD)
	print(_CONSTANT.AUTHOR)
	print(_CONSTANT.CONTACT)
	print("")
	print("Works on Windows only")
	print("Usage:\n")
	print(_CONSTANT.APP_NAME + " -c [c:\\path\\to\\" + _CONSTANT.ERRORACTION_CONFIG_FILENAME + "] [OPTIONS]")
	print("")
	print("[OPTIONS]")
	print("-f [..]              Specify a source email for alerts")
	print("-t [..]              Destination email for alerts")
	print("-s [..]              SMTP server address")
	print("-P [..]              SMTP server port")
	print("-u [..]              SMTP server username")
	print("-p [..]              SMTP server password")
	print("--security=[..]      SMTP server security. Valid values are: none, ssl, tls")
	print("-z                   Compress log files before sending")
	print("-m                   Enable mail warnings (automatically enabled if destination mail provided)")
	print("-l                   Enable smart warnings on screen")
	print("--warning=\"[..]\"     Specify a warning message that will be used for alerts")
	print("--help, -h, -?       Will show this message")
	print("")
	print("Example:")
	print(_CONSTANT.APP_NAME + " -c \"C:\Program Files\smartmontools for windows\bin\erroraction_config.cmd\" -f infra@example.tld -t monitoring@example.tld -s my.smtp.server.tld -P 587 -u infra@example.tld -p MyPassword -z")
	sys.exit(1)

def main(argv):
	global CONFIG
	
	if _CONSTANT.IS_STABLE == False:
		logger.warn("Warning: This is an unstable developpment version.")
	
	configDict={}
	
	try:
		opts, args = getopt.getopt(argv, "hmlz?c:?f:?t:?s:u:?p:?P:?", [ 'security=', 'warning=' ])
	except getopt.GetoptError:
		usage()
	for opt, arg in opts:
		if opt == '-h' or opt == "--help" or opt == "-?":
			usage()
		elif opt == '-c':
			confFile = arg
		elif opt == '-m':
			configDict['MAIL_ALERT'] = "yes"
		elif opt == '-f':
			configDict['SOURCE_MAIL'] = arg
		elif opt == '-t':
			configDict['DESTINATION_MAIL'] = arg
			configDict['MAIL_ALERT'] = "yes"
		elif opt == '-s':
			configDict['SMTP_SERVER'] = arg
		elif opt == '-P':
			configDict['SMTP_PORT'] = arg
		elif opt == '-u':
			configDict['SMTP_USER'] = arg
		elif opt == '-p':
			configDict['SMTP_PASSWORD'] = arg
		elif opt == '--security' and (arg == "none" or arg == "tls" or arg == "ssl"):
			configDict['SECURITY'] = arg
		elif opt == '-l':
			configDict['LOCAL_ALERT'] = "yes"
		elif opt == '--warning':
			configDict['WARNING_MESSAGE'] = arg
		elif opt == '-z':
			configDict['COMPRESS_LOGS'] = "yes"
	
	# Mailer variable for compat
	configDict['MAILER'] = 'mailsend'


	if 'confFile' in locals():
		CONFIG = Configuration(confFile)
	else:
		CONFIG = Configuration('')

	try:
		root = tk.Tk()
		root.title(_CONSTANT.APP_NAME)
		app = Application(root, configDict)
		root.mainloop()

	except Exception as e:
		logger.critical("Cannot instanciate main tk app.")
		logger.debug(e)
		sys.exit(1)

# Modification of https://stackoverflow.com/questions/130763/request-uac-elevation-from-within-a-python-script
def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        logger.critical("Cannot get admin privileges.")
        lgger.debug(e)
        raise False

if __name__ == '__main__':
	if platform.system() == "Windows":
		if is_admin():
			# Detect if running frozen version invoked as ShellExecuteW, where filename argument exists twice
			if os.path.basename(sys.argv[0]) == os.path.basename(sys.argv[1]):
				main(sys.argv[2:])
			else:
				main(sys.argv[1:])
		else:
			# Re-run the program with admin rights, don't use __file__ since py2exe won't know about it
			# Use sys.argv[0] as script path and sys.argv[1:] as arguments, join them as lpstr, quoting each parameter or spaces will divide parameters
			#lpParameters = sys.argv[0] + " "
			lpParameters = ""
			for i, item in enumerate(sys.argv[0:]):
				lpParameters += '"' + item + '" '
			try:
				ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, lpParameters , None, 1)
			except:
				sys.exit(1)
	else:
		main(sys.argv[1:])
