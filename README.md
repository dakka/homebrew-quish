# Homebrew tap for quish

[Homebrew][1] tap for [quish][2] — a reliable interactive terminal
client/server using QUIC for unstable networks.

## Install

```sh
brew tap dakka/quish
brew install quish
```

To track development (`main` branch tip):

```sh
brew install --HEAD quish
```

## Update

```sh
brew update
brew upgrade quish
```

## Uninstall

```sh
brew uninstall quish
brew untap dakka/quish
```

## Supported platforms

- macOS (Apple Silicon and Intel)
- Linux (via [Homebrew on Linux][1])

`quish-flaker` (a TUN-based network degradation tool) is Linux-only;
the macOS build skips it pending a `utun` port.

## What gets installed

| Binary          | Role                                  |
|:---             |:---                                   |
| `quish`         | client                                |
| `quish-server`  | server                                |
| `quish-setup`   | interactive provisioner               |
| `qcp`           | parallel file transfer over QUIC      |
| `quish-flaker`  | network degradation tool (Linux only) |

## Documentation

See the [main repository][2] for usage, configuration, and architecture
documentation.

## Issues

File formula issues here. File **quish** issues at the
[main repository's issue tracker][3].

## License

quish is [Apache-2.0][4]. This tap is also Apache-2.0.

[1]: https://brew.sh
[2]: https://github.com/dakka/quish
[3]: https://github.com/dakka/quish/issues
[4]: https://github.com/dakka/quish/blob/main/LICENSE
