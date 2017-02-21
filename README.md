![https://www.augustash.com](http://augustash.s3.amazonaws.com/logos/ash-inline-color-500.png)

**This container is not currently aimed at public consumption. It exists as an internal tool for August Ash containers.**

## About

PHP-FPM (FastCGI Process Manager) is an alternative PHP FastCGI implementation with some additional features useful for sites of any size, especially busier sites.

## TL;DR

```bash
docker-compose up -d
```

## Usage

The image used for this container provides the ability to run single, one-off commands. Run a single command in the following manner:

```bash
docker run --rm -it augustash/phpfpm:7.0 php -v
```

The example syntax will:

- Stage 1: prepare the container environment variables, block the startup of the second stage until `s6` is effectively started.
- Stage 2: run all end-user files, such as `/etc/fix-attrs.d` and `/etc/cont-init.d`.
    - Run the specified command.
- Stage 3: shutdown and cleanup

For single-use PHP commands, you can skip the `s6` process like this:

```bash
docker run --rm -it --entrypoint /usr/bin/php augustash/phpfpm:7.0 --version
```

## Configuration

### Mount Custom Configuration

If you need to change configuration values, the best option is to mount your own custom configuration:

```bash
docker run --rm -it \
    -v $(pwd)/conf/www.conf:/config/php/pool.d/www.conf
    -v $(pwd)/conf/php.ini:/config/php/php.ini
    augustash/phpfpm:7.0 php -i
```

### User/Group Identifiers

To help avoid nasty permissions errors, the container allows you to specify your own `PUID` and `PGID`. This can be a user you've created or even root (not recommended).

## Extensions

The following extra PHP extensions are enabled:

- `bcmath`
- `curl`
- `gd`
- `intl`
- `mbstring`
- `mcrypt`
- `memcache`
- `mhash`
- `opcache`
- `redis`
- `soap`
- `xsl`
- `zip`

### Environment Variables

The following variables can be set and will change how the container behaves. You can use the `-e` flag, an environment file, or your Docker Compose file to set your preferred values. The default values are shown:

- `PUID`=501
- `PGID`=20
- `PHP_VERSION`=7.0
