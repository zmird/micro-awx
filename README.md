# Micro-awx

Vagrant environment for [Awx](https://github.com/ansible/awx) and [Gitlab](https://gitlab.com).


## Getting Started

You can easly create all the machines by running

```sh
~ $ vagrant up
```

## Awx

To start awx run


``` sh
~ $ vagrant up awx
```

Open the browser at http://192.168.50.10 and wait until the migration is done.

![Awx migration](.images/awx_upgrading.png)

Proceed with the login, default username and password are `admin` and `password`.

![Awx login](.images/awx_login.png)

and you are done!

![Awx dashboard](.images/awx_dashboard.png)
