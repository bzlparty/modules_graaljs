"graalnodejs assets from https://github.com/oracle/graaljs/releases"

ASSETS = {
    "24.0.1": {
        "linux-aarch64": struct(asset = "graalnodejs-24.0.1-linux-aarch64.tar.gz", integrity = "0QdXBdzjhkHZA/j3+ah6QM3FiXmPwa/jiXzFee9XyObHrncpdpwy/60alDixCPLJ"),
        "linux-amd64": struct(asset = "graalnodejs-24.0.1-linux-amd64.tar.gz", integrity = "3ntRca7XdGYWPz2tStLiKY7us68XmkNJ1a4XXFFbCnp1U2PD8j3znqjjVe30QyQZ"),
        "macos-aarch64": struct(asset = "graalnodejs-24.0.1-macos-aarch64.tar.gz", integrity = "L5Qu8AcnU80oRLUpi2P6Kf3CM8RE5522fC2cerT6lrePGcuh3IYf/QsJyq1FALgx"),
        "macos-amd64": struct(asset = "graalnodejs-24.0.1-macos-amd64.tar.gz", integrity = "dCqqbdebwgKpVbx9P5fHNps73rgLifyleTuHqzhsx48a5+ySJNHlcFdr9dUnTQMw"),
        "windows-amd64": struct(asset = "graalnodejs-24.0.1-windows-amd64.zip", integrity = "KLCmmpi/A3xq9ykvsGHryyUuntU0atJIC33e1lazkVCz3T1WgmylH6488lpPPsUn"),
    },
    "24.0.1-community": {
        "linux-aarch64": struct(asset = "graalnodejs-community-24.0.1-linux-aarch64.tar.gz", integrity = "sha384-APqRZrl2cQc1sX9z35SboRtpy0ZULEiJPXsUgrHUHOZ3j1pf8xzBUkbzgaPgOI6A"),
        "linux-amd64": struct(asset = "graalnodejs-community-24.0.1-linux-amd64.tar.gz", integrity = "sha384-uSD9iblJZq1uOVtxEL7dwaD63pQaxajrAitquR0NMgnnvuxazOce/Ev//hzOJd51"),
        "macos-aarch64": struct(asset = "graalnodejs-community-24.0.1-macos-aarch64.tar.gz", integrity = "sha384-RHAf2TnG3mNp4Vv3vqchrfNMmL0p32FZgxtypvTVYX+c804KmNaEIorRStIAlqqL"),
        "macos-amd64": struct(asset = "graalnodejs-community-24.0.1-macos-amd64.tar.gz", integrity = "sha384-MXvmaBK1DkMjTjXuvspAGquNqRAf3AakgbgDsl08Dx1RXyJCBYZqDNOhS1TEicsd"),
        "windows-amd64": struct(asset = "graalnodejs-community-24.0.1-windows-amd64.zip", integrity = "sha384-EiiLni577GPSuWsB7s7bGu8MStnXLjAy9LuQl/tE+unQmhUlmHdfkU2lbNe9I49M"),
    },
    "24.0.1-community-jvm": {
        "linux-aarch64": struct(asset = "graalnodejs-community-jvm-24.0.1-linux-aarch64.tar.gz", integrity = "sha384-eNFxUovFgF5ydv1l+0sXxF9Glvr5qjJ16UibZLoMllU/dBaZ2SN3SQHJHHGurz/i"),
        "linux-amd64": struct(asset = "graalnodejs-community-jvm-24.0.1-linux-amd64.tar.gz", integrity = "sha384-WjSB5TYllbgVPKwwcBH3E+EzK88noKuENr3FsO7r6H7uckFr9xMZ5i3OsacFCKhY"),
        "macos-aarch64": struct(asset = "graalnodejs-community-jvm-24.0.1-macos-aarch64.tar.gz", integrity = "sha384-s6WtgVUDoIZB7hpw4jgtTxKC1sNLzDRsfW3Jc3HE2scyUR3TabM7F/saZ5Q3A2LL"),
        "macos-amd64": struct(asset = "graalnodejs-community-jvm-24.0.1-macos-amd64.tar.gz", integrity = "sha384-xnv3rZ62FYrBPUdKTAYcl6ZjU4bdJ9FRunSJCF5K87uMYamCU6tVgwrPn7dHthEi"),
        "windows-amd64": struct(asset = "graalnodejs-community-jvm-24.0.1-windows-amd64.zip", integrity = "sha384-nNTd40mJeMvx0liLZy2bFwxB98bExI7JycMbNWUyU46z7POCa5JN+SXXsnrVeRjC"),
    },
    "24.0.1-jvm": {
        "linux-aarch64": struct(asset = "graalnodejs-jvm-24.0.1-linux-aarch64.tar.gz", integrity = "sha384-C0NHVJ8DZSgkhMWWBA49bgXlIMamsK8edFrzmIRBthS95Mn/B/YKgLQABifVDx3Q"),
        "linux-amd64": struct(asset = "graalnodejs-jvm-24.0.1-linux-amd64.tar.gz", integrity = "sha384-y0JH8xVXDfwDMq+VuY0buvEFw7H1hUn+f6Gdjy59rZf4bFPEYdBr9DQRm6j1fytk"),
        "macos-aarch64": struct(asset = "graalnodejs-jvm-24.0.1-macos-aarch64.tar.gz", integrity = "sha384-ZBVQ1J923ZVbTibUaZBd3ySPWmRevgclWT2vgV/nQumNFtCAxjYaTC13SinJ75yK"),
        "macos-amd64": struct(asset = "graalnodejs-jvm-24.0.1-macos-amd64.tar.gz", integrity = "sha384-Lq8bbqjCMd23lMAe7/tWV0Nnu/s/294sp1S4wV363XNfGk5EaxIPWtMpvQKCifud"),
        "windows-amd64": struct(asset = "graalnodejs-jvm-24.0.1-windows-amd64.zip", integrity = "sha384-xzjr9a2i8YWqMtlJrYhrb+YUW8iGEm2tFGgomUJSgBPrRMOmjn8rmo4mm1STfb/L"),
    },
}
