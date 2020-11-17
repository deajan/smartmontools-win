#! /usr/bin/env python
#  -*- coding: utf-8 -*-
#
# Copyright 2017-2020 Orsiris de Jong
# This file is part of command_runner module

"""
elevate is a Windows/ unix compatible function elevator for Python 3+

usage:
    import sys
    from elevate import elevate

    def main(argv):
        print('Hello world, with arguments %s' % argv)

        # Hey, check my exit code ;)
        sys.exit(123)

    if __name__ == '__main__':
        elevate(main, sys.argv)

Versionning semantics:
    Major version: backward compatibility breaking changes
    Minor version: New functionnality
    Patch version: Backwards compatible bug fixes

"""

__intname__ = 'command_runner.elevate'
__author__ = 'Orsiris de Jong'
__copyright__ = 'Copyright (C) 2020 Orsiris de Jong'
__licence__ = 'BSD 3 Clause'
__version__ = '0.2.0'
__build__ = '2020040201'

from logging import getLogger
import os
import sys
from command_runner import command_runner

if os.name == 'nt':
    try:
        import win32event  # monitor process
        import win32process  # monitor process
        from win32com.shell.shell import ShellExecuteEx
        from win32com.shell.shell import IsUserAnAdmin
        from win32com.shell import shellcon
    except ImportError:
        raise ImportError('Cannot import ctypes for checking admin privileges on Windows platform.')

logger = getLogger()


def is_admin():
    """
    Checks whether current program has administrative privileges in OS
    Works with Windows XP SP2+ and most Unixes

    :return: Boolean, True if admin privileges present
    """
    current_os_name = os.name

    # Works with XP SP2 +
    if current_os_name == 'nt':
        try:
            return IsUserAnAdmin()
        except Exception:
            raise EnvironmentError('Cannot check admin privileges')
    elif current_os_name == 'posix':
        # Check for root on Posix
        # os.getuid only exists on postix OSes
        return os.getuid() == 0
    else:
        raise EnvironmentError('OS does not seem to be supported for admin check. OS: %s' % current_os_name)


def elevate(fn, *args, **kwargs):
    if is_admin():
        fn(*args, **kwargs)
    else:
        # UAC elevation / sudo code working for CPython, Nuitka >= 0.6.2, PyInstaller, PyExe, CxFreeze

        # Regardless of the runner (CPython, Nuitka or frozen CPython), sys.argv[0] is the relative path to script,
        # sys.argv[1] are the arguments
        # The only exception being CPython on Windows where sys.argv[0] contains absolute path to script
        # Regarless of OS, sys.executable will contain full path to python binary for CPython and Nuitka,
        # and full path to frozen executable on frozen CPython

        # Recapitulative table create with
        # (CentOS 7x64 / Python 3.4 / Nuitka 0.6.1 / PyInstaller 3.4) and
        # (Windows 10 x64 / Python 3.7x32 / Nuitka 0.6.2.10 / PyInstaller 3.4)
        # --------------------------------------------------------------------------------------------------------------
        # | OS  | Variable       | CPython                       | Nuitka               | PyInstaller                  |
        # |------------------------------------------------------------------------------------------------------------|
        # | Lin | argv           | ['./script.py', '-h']         | ['./test', '-h']     | ['./test.py', -h']           |
        # | Lin | sys.executable | /usr/bin/python3.4            | /usr/bin/python3.4   | /absolute/path/to/test       |
        # | Win | argv           | ['C:\\Python\\test.py', '-h'] | ['test', '-h']       | ['test', '-h']               |
        # | Win | sys.executable | C:\Python\python.exe          | C:\Python\Python.exe | C:\absolute\path\to\test.exe |
        # --------------------------------------------------------------------------------------------------------------

        # Nuitka 0.6.2 and newer define builtin __nuitka_binary_dir
        # Nuitka does not set the frozen attribute on sys
        # Nuitka < 0.6.2 can be detected in sloppy ways, ie if not sys.argv[0].endswith('.py') or len(sys.path) < 3
        # Let's assume this will only be compiled with newer nuitka, and remove sloppy detections
        try:
            # Actual if statement not needed, but keeps code inspectors more happy
            if __nuitka_binary_dir or '__compiled__' in globals() is not None:
                is_nuitka_compiled = True
        except NameError:
            is_nuitka_compiled = False

        if is_nuitka_compiled:
            # On nuitka, sys.executable is the python binary, even if it does not exist in standalone,
            # so we need to fill runner with sys.argv[0] absolute path
            runner = os.path.abspath(sys.argv[0])
            arguments = sys.argv[1:]
            # current_dir = os.path.dirname(runner)

            logger.debug('Running elevator as Nuitka with runner [%s]' % runner)
            logger.debug('Arguments are %s' % arguments)

        # If a freezer is used (PyInstaller, cx_freeze, py2exe)
        elif getattr(sys, "frozen", False):
            runner = os.path.abspath(sys.executable)
            arguments = sys.argv[1:]
            # current_dir = os.path.dirname(runner)

            logger.debug('Running elevator as Frozen with runner [%s]' % runner)
            logger.debug('Arguments are %s' % arguments)

        # If standard interpreter CPython is used
        else:
            runner = os.path.abspath(sys.executable)
            arguments = [os.path.abspath(sys.argv[0])] + sys.argv[1:]
            # current_dir = os.path.abspath(sys.argv[0])

            logger.debug('Running elevator as CPython with runner [%s]' % runner)
            logger.debug('Arguments are %s' % arguments)

        if os.name == 'nt':
            # Re-run the function with admin rights
            # Join arguments and double quote each argument in order to prevent space separation
            arguments = ' '.join('"' + arg + '"' for arg in arguments)
            try:
                # Old method using ctypes which does not wait for executable to exit nor deos get exit code
                # See https://docs.microsoft.com/en-us/windows/desktop/api/shellapi/nf-shellapi-shellexecutew
                # int 0 means SH_HIDE window, 1 is SW_SHOWNORMAL
                # needs the following imports
                # import ctypes

                # ctypes.windll.shell32.ShellExecuteW(None, 'runas', runner, arguments, None, 0)

                # Method with exit code that waits for executable to exit, needs the following imports
                # import win32event  # monitor process
                # import win32process  # monitor process
                # from win32com.shell.shell import ShellExecuteEx
                # from win32com.shell import shellcon
                childProcess = ShellExecuteEx(nShow=0, fMask=shellcon.SEE_MASK_NOCLOSEPROCESS,
                                              lpVerb='runas', lpFile=runner, lpParameters=arguments)

                procHandle = childProcess['hProcess']
                win32event.WaitForSingleObject(procHandle, win32event.INFINITE)
                exit_code = win32process.GetExitCodeProcess(procHandle)
                logger.debug('Child exited with code: %s' % exit_code)
                sys.exit(exit_code)

            except Exception as e:
                logger.info(e)
                logger.debug('Trace:', exc_info=True)
                sys.exit(255)
        # Linux runner and hopefully Unixes
        else:
            # Search for sudo executable in order to avoid using shell=True with subprocess
            sudo_path = None
            for path in os.environ.get('PATH', ''):
                if os.path.isfile(os.path.join(path, 'sudo')):
                    sudo_path = os.path.join(path, 'sudo')
            if sudo_path is None:
                logger.error('Cannot find sudo executable. Cannot elevate privileges. Trying to run wihtout.')
                fn(*args, **kwargs)
            else:
                command = 'sudo "%s"%s%s' % (
                    runner,
                    (' ' if len(arguments) > 0 else ''),
                    ' '.join('"%s"' % argument for argument in arguments)
                )
                exit_code, output = command_runner(command, shell=False,
                                                   timeout=None)

                logger.info('Child output: %s' % output)
                sys.exit(exit_code)
