#!/usr/bin/env python
from json import loads
from subprocess import run
from sys import executable


def pip_list_outdated():
    list_stdout = run(
        [
            executable,
            "-m",
            "pip",
            "--disable-pip-version-check",
            "list",
            "--outdated",
            "--format=json",
        ],
        check=True,
        capture_output=True,
        text=True,
    ).stdout
    return [package["name"] for package in loads(list_stdout)]


def pip_upgrade_list(packages=[]):
    if packages:
        run(
            [
                executable,
                "-m",
                "pip",
                "install",
                "--root-user-action=ignore",
                "--upgrade",
                "--no-cache-dir",
                "--no-compile",
            ]
            + packages,
            check=True,
        )


def pip_upgrade_all():
    outdated = pip_list_outdated()
    pip_upgrade_list(outdated)


pip_upgrade_all()
