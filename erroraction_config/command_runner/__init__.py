#! /usr/bin/env python
#  -*- coding: utf-8 -*-
#
# This file is part of command_runner module

"""
command_runner is a quick tool to launch commands from Python, get exit code
and output, and handle most errors that may happen

Versionning semantics:
    Major version: backward compatibility breaking changes
    Minor version: New functionnality
    Patch version: Backwards compatible bug fixes

"""

__intname__ = 'command_runner'
__author__ = 'Orsiris de Jong'
__copyright__ = 'Copyright (C) 2015-2020 Orsiris de Jong'
__licence__ = 'BSD 3 Clause'
__version__ = '0.5.0-dev'
__build__ = '2020111101'


import os
import sys
from logging import getLogger
from typing import Union, Optional, List, Tuple, NoReturn
import subprocess
from datetime import datetime
from time import sleep


logger = getLogger()


def live_command_runner(command: str, valid_exit_codes: Optional[List[int]] = None, timeout: int = 1800,
                        shell: bool = False, encoding: str = 'utf-8',
                        windows_no_window: bool = False,
                        stdout: Union[int, str] = subprocess.PIPE, stderr: Union[int, str] = subprocess.STDOUT,
                        **kwargs) -> Tuple[Optional[int], str]:
    """
    Just the same as command_runner, but allows to show stdout / stderr output on the fly
    Needs python >= 3.7

    """
    # Set default values for kwargs
    errors = kwargs.pop('errors', 'backslashreplace')  # Don't let encoding issues make you mad
    universal_newlines = kwargs.pop('universal_newlines', False)
    creationflags = kwargs.pop('creationflags', 0)
    if windows_no_window:
        # Disable the following pylint error since the code also runs on nt platform, but
        # triggers and error on Unix
        # pylint: disable=E1101
        creationflags = creationflags | subprocess.CREATE_NO_WINDOW

    # If stdout is a file, let's create it
    if isinstance(stdout, str):
        stdout = open(stdout, 'w')
        stdout_to_file = True
    else:
        stdout_to_file = False
    if isinstance(stderr, str):
        stderr = open(stderr, 'w')

    output = ''

    try:
        begin_time = datetime.now()
        process = subprocess.Popen(command, shell=shell,
                                         universal_newlines=universal_newlines, encoding=encoding,
                                         errors=errors, creationflags=creationflags,
                                         stdout=stdout, stderr=stderr, **kwargs)

        while process.poll() is None:
            if not stdout_to_file:
                current_output = process.stdout.readline()
                sys.stdout.write(current_output)
                output += str(current_output)

            if (datetime.now() - begin_time).total_seconds() > timeout:
                # Try to terminate nicely before killing the process
                process.terminate()
                # Let the process terminate itself before trying to kill it not nicely
                # Under windows, terminate() and kill() are equivalent
                sleep(.5)
                if process.poll() is None:
                    process.kill()
                logger.error('Timeout [{} seconds] expired for command [{}] execution.'.format(timeout, command))
                return None, 'Timeout of {} seconds expired.'.format(timeout)

        # Get remaining output from process after a grace period
        sleep(.5)
        try:
            current_output = process.stdout.read()
            sys.stdout.write(current_output)
            output += str(current_output)
        except AttributeError:
            # process.stdout.read() might not exist anymore
            pass
        exit_code = process.poll()
        if isinstance(output, str):
            logger.debug(output)
        return exit_code, output
    # OSError if not a valid executable
    except FileNotFoundError as exc:
        logger.error('Command [{}] failed, file not found: {}'.format(command, exc))
        return None, exc.__str__()
    except (OSError, IOError) as exc:
        logger.error('Command [{}] failed because of OS: {}.'.format(command, exc))
        return None, exc.__str__()
    except Exception as exc:
        logger.error('Command [{}] failed for unknown reasons: {}.'.format(command, exc))
        logger.debug('Error:', exc_info=True)
        return None, exc.__str__()


def command_runner(command: str, valid_exit_codes: Optional[List[int]] = None, timeout: int = 1800, shell: bool = False,
                   encoding: str = 'utf-8',
                   windows_no_window: bool = False, **kwargs) -> Tuple[Optional[int], str]:
    """
    Unix & Windows compatible subprocess wrapper that handles encoding, timeout, and
    various exit codes.
    Accepts subprocess.check_output and subprocess.popen arguments
    Whenever we can, we need to avoid shell=True in order to preseve better security
    Runs system command, returns exit code and stdout/stderr output, and logs output on error
    valid_exit_codes is a list of codes that don't trigger an error
    """

    # Set default values for kwargs
    errors = kwargs.pop('errors', 'backslashreplace')  # Don't let encoding issues make you mad
    universal_newlines = kwargs.pop('universal_newlines', False)
    creationflags = kwargs.pop('creationflags', 0)
    if windows_no_window:
        # Disable the following pylint error since the code also runs on nt platform, but
        # triggers an error on Unix
        # pylint: disable=E1101
        creationflags = creationflags | subprocess.CREATE_NO_WINDOW

    try:
        # universal_newlines=True makes netstat command fail under windows
        # timeout does not work under Python 2.7 with subprocess32 < 3.5
        # decoder may be cp437 or unicode_escape for dos commands or utf-8 for powershell
        # Disabling pylint error for the same reason as above
        # pylint: disable=E1123
        output = subprocess.check_output(command, stderr=subprocess.STDOUT, shell=shell,
                                         timeout=timeout, universal_newlines=universal_newlines, encoding=encoding,
                                         errors=errors, creationflags=creationflags, **kwargs)

    except subprocess.CalledProcessError as exc:
        exit_code = exc.returncode
        try:
            output = exc.output
        except Exception:
            output = "command_runner: Could not obtain output from command."
        if exit_code in valid_exit_codes if valid_exit_codes is not None else [0]:
            logger.debug('Command [%s] returned with exit code [%s]. Command output was:' % (command, exit_code))
            if isinstance(output, str):
                logger.debug(output)
            return exc.returncode, output
        else:
            logger.error('Command [%s] failed with exit code [%s]. Command output was:' %
                         (command, exc.returncode))
            logger.error(output)
            return exc.returncode, output
    # OSError if not a valid executable
    except (OSError, IOError) as exc:
        logger.error('Command [%s] failed because of OS [%s].' % (command, exc))
        return None, exc.__str__()
    except subprocess.TimeoutExpired:
        logger.error('Timeout [%s seconds] expired for command [%s] execution.' % (timeout, command))
        return None, 'Timeout of %s seconds expired.' % timeout
    except Exception as exc:
        logger.error('Command [%s] failed for unknown reasons [%s].' % (command, exc))
        logger.debug('Error:', exc_info=True)
        return None, exc.__str__()
    else:
        logger.debug('Command [%s] returned with exit code [0]. Command output was:' % command)
        if output:
            logger.debug(output)
        return 0, output


def deferred_command(command: str, defer_time: Optional[int] = None) -> NoReturn:
    """
    This is basically an ugly hack to launch commands in windows which are detached from parent process
    Especially useful to auto update/delete a running executable

    #TODO: Implement delete on reboot

    """
    if not isinstance(defer_time, int):
        raise ValueError('defer_time needs to be in seconds.')
        
    if os.name == 'nt':
        deferrer = 'ping 127.0.0.1 -n %s > NUL & ' % defer_time
    else:
        deferrer = 'ping 127.0.0.1 -c %s > /dev/null && ' % defer_time
        
    subprocess.Popen(deferrer + command, shell=True, stdin=None, stdout=None, stderr=None, close_fds=True)
    

def _selftest():

    print('Example code for %s, %s, %s' % (__intname__, __version__, __build__))
    """
    exit_code, output = command_runner('ping 127.0.0.1')
    assert exit_code == 0, 'Exit code should be 0 for ping command'
    
    exit_code, output = command_runner('ping 127.0.0.1', timeout=1)
    assert exit_code == None, 'Exit code should be none on timeout'   
    assert 'Timeout' in output, 'Output should have timeout'
    """
    exit_code, output = live_command_runner('ping 127.0.0.1', encoding='cp437')
    assert exit_code == 0, 'Exit code should be 0 for ping command'

    exit_code, output = live_command_runner('ierhiohehierog2342')
    assert exit_code != 0, 'Unknown command should trigger an error'

    exit_code, output = live_command_runner('ping 127.0.0.1', timeout=1)
    assert exit_code == None, 'Exit code should be none in timeout'
    assert 'Timeout' in output, 'Output should have timeout'

    #exit_code = live_command_runner('ping 127.0.0.1', stdout=r'C:\GIT\test.log', stderr='/var/log/stderr.log')


if __name__ == '__main__':
    _selftest()
