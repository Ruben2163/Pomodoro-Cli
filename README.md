# Pomodoro CLI

A fast, themeable Pomodoro timer for your terminal, written in OCaml.

## Features

- Configurable work, break, and long break durations
- Progress bar with color themes
- Optional beep notification
- Config file support
- Homebrew installable

## Installation

### 1. Build from Source

First, install OCaml and opam if you don't have them:

```sh
brew install ocaml opam
```

Install dependencies:

```sh
opam install yojson
```

Build the binary:

```sh
./build.sh
```

Copy the binary to your PATH (user-wide):

```sh
mkdir -p ~/.local/bin
cp pomodoro ~/.local/bin/
```

Make sure `~/.local/bin` is in your PATH.

#### Build a Static Binary (Recommended for Homebrew)

To ensure your binary works on most macOS systems, build statically:

```sh
opam install yojson ocamlfind
ocamlfind ocamlopt -linkpkg -package yojson,unix main.ml -o pomodoro
```

### 2. Install via Homebrew (Recommended for Users)

#### Using a Homebrew Tap

1. **Build a release binary** (see above).
2. **Create a GitHub Release** and upload your `pomodoro` binary.
3. **Update the Homebrew formula** (`pomodoro.rb`) with the correct URL and SHA256.
4. **Host the formula** in a tap repo (e.g., `yourorg/homebrew-pomodoro`).

Users can then install with:

```sh
brew tap yourorg/pomodoro
brew install pomodoro
```

#### Example (after you publish):

```sh
brew tap yourorg/pomodoro
brew install pomodoro
```

## Usage

```sh
pomodoro [--config FILE] [--work N] [--break N] [--cycles N] [--long-break N] [--beep]
```

- `--config FILE` : Path to config file (default: `config.json`)
- `--work N` : Work duration in minutes
- `--break N` : Break duration in minutes
- `--cycles N` : Number of cycles
- `--long-break N` : Long break in minutes
- `--beep` : Beep at end of each timer

### Example

```sh
pomodoro --work 20 --break 5 --cycles 4 --long-break 15 --beep
```

Or with a config file:

```sh
pomodoro --config ~/.config/pomodoro-cli/config.json
```

## Configuration

You can use a JSON config file to set defaults and theme:

```json
{
  "work": 25,
  "break": 5,
  "cycles": 4,
  "long_break": 15,
  "beep": true,
  "theme": {
    "bar_color": "\u001b[34m",
    "text_color": "\u001b[36m"
  }
}
```

## Themes

Customize `bar_color` and `text_color` in your config using ANSI color codes.

- Red: `\u001b[31m`
- Green: `\u001b[32m`
- Yellow: `\u001b[33m`
- Blue: `\u001b[34m`
- Magenta: `\u001b[35m`
- Cyan: `\u001b[36m`
- Reset: `\u001b[0m`

## Development

To build:

```sh
opam install yojson
./build.sh
```

## Homebrew Formula

See [`pomodoro.rb`](./pomodoro.rb) for a sample Homebrew formula.

To create or update the formula:

1. Download your release binary and compute its SHA256:

   ```sh
   shasum -a 256 pomodoro
   ```

2. Edit `pomodoro.rb` with the new URL and SHA256.

3. Commit and push to your tap repo.

4. Test with:

   ```sh
   brew install --build-from-source ./pomodoro.rb
   ```

## License

Commercial use allowed. See LICENSE for details.
