# Pomodoro CLI

## Make `pomodoro` Available Anywhere

After building, move the binary to a directory in your `PATH`:

```sh
mkdir -p ~/.local/bin
cp pomodoro ~/.local/bin/
```

Ensure `~/.local/bin` is in your `PATH`.  
Add this to your shell config (`~/.zshrc`, `~/.bashrc`, or `~/.bash_profile`):

```sh
export PATH="$HOME/.local/bin:$PATH"
```

Reload your shell config:

```sh
source ~/.zshrc   # or source ~/.bashrc
```

Now you can run `pomodoro` from any directory in your terminal.

## Usage

```sh
pomodoro [OPTIONS]
```

## Options

```
--config FILE      Config file (default config.json)
--work N           Work duration in minutes
--break N          Break duration in minutes
--cycles N         Number of cycles
--long-break N     Long break in minutes
--beep              Beep at end of each timer
```

## Example

```sh
pomodoro --work 25 --break 5 --cycles 4 --long-break 15 --beep
```

## Configuration

By default, Pomodoro CLI looks for a config file at `~/.pomoconfig.json`.  
You can override this with `--config FILE`.

Example `~/.pomoconfig.json`:

```json
{
  "work": 25,
  "break": 5,
  "cycles": 4,
  "long_break": 15,
  "beep": false,
  "theme": {
    "bar_color": "\u001b[32m",
    "text_color": "\u001b[0m"
  }
}
```

## Theme

You can customize the theme colors using ANSI color codes. For example:

```json
"theme": {
  "bar_color": "\u001b[34m",
  "text_color": "\u001b[36m"
}
```

## Build

To build `pomodoro`, run:

```sh
ocamlfind ocamlopt -linkpkg -package yojson,unix main.ml -o pomodoro
```

## Install

To install `pomodoro`, you can use the provided `pomodoro.rb` formula for Homebrew:

```ruby
class Pomodoro < Formula
  desc "Fast, themeable Pomodoro timer for your terminal (OCaml)"
  homepage "https://github.com/ruben2163/pomodoro-cli"
  url "https://github.com/ruben2163/pomodoro-cli/releases/download/v1.0.0/pomodoro"
  sha256 "f91acb9347f8f74543ce88fb7e0052d3e6f2967fffa3a1f9db3fa5163a29d6a4"
  version "1.0.0"

  def install
    bin.install "pomodoro"
  end

  test do
    system "#{bin}/pomodoro", "--help"
  end
end
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.