open Printf
open Yojson.Basic.Util

type theme = {
  bar_color: string;
  text_color: string;
}

type config = {
  work: int;
  break_: int;
  cycles: int;
  long_break: int;
  beep: bool;
  theme: theme;
}

let default_theme = {
  bar_color = "\027[32m"; (* green *)
  text_color = "\027[0m";  (* reset *)
}

let default_config = {
  work = 25;
  break_ = 5;
  cycles = 4;
  long_break = 15;
  beep = false;
  theme = default_theme;
}

let load_config filename =
  try
    let json = Yojson.Basic.from_file filename in
    let theme_json = json |> member "theme" in
    let theme = {
      bar_color = theme_json |> member "bar_color" |> to_string_option |> Option.value ~default:default_theme.bar_color;
      text_color = theme_json |> member "text_color" |> to_string_option |> Option.value ~default:default_theme.text_color;
    } in
    {
      work = json |> member "work" |> to_int_option |> Option.value ~default:default_config.work;
      break_ = json |> member "break" |> to_int_option |> Option.value ~default:default_config.break_;
      cycles = json |> member "cycles" |> to_int_option |> Option.value ~default:default_config.cycles;
      long_break = json |> member "long_break" |> to_int_option |> Option.value ~default:default_config.long_break;
      beep = json |> member "beep" |> to_bool_option |> Option.value ~default:default_config.beep;
      theme;
    }
  with _ -> default_config

let sleep_seconds s =
  let rec loop n =
    if n > 0 then (Unix.sleep 1; loop (n-1))
  in loop s

let beep () =
  print_char '\007';
  flush stdout

let print_progress_bar ~total ~current ~bar_color ~text_color ~label =
  let width = 30 in
  let filled = (current * width) / total in
  let empty = width - filled in
  let minutes = current / 60 in
  let seconds = current mod 60 in
  printf "\r%s%s: [%s%s%s%s] %02d:%02d%s"
    text_color label
    bar_color (String.make filled '#')
    "\027[0m" (String.make empty '-')
    minutes seconds
    text_color;
  flush stdout

let countdown seconds label beep_enabled theme =
  for i = seconds downto 1 do
    print_progress_bar ~total:seconds ~current:i ~bar_color:theme.bar_color ~text_color:theme.text_color ~label;
    sleep_seconds 1
  done;
  print_endline "";
  if beep_enabled then beep ()

let pomodoro ~work ~break_ ~cycles ~long_break ~beep_enabled ~theme =
  let total_work = ref 0 in
  let total_break = ref 0 in
  for c = 1 to cycles do
    Printf.printf "%s\nCycle %d: Work%s\n" theme.text_color c "\027[0m";
    countdown work "Work" beep_enabled theme;
    total_work := !total_work + work;
    if c < cycles then begin
      Printf.printf "%sTime for a break%s\n" theme.text_color "\027[0m";
      countdown break_ "Break" beep_enabled theme;
      total_break := !total_break + break_
    end
  done;
  Printf.printf "%s\nAll cycles complete! Time for a long break!%s\n" theme.text_color "\027[0m";
  countdown long_break "Long Break" beep_enabled theme;
  Printf.printf "%s\nPomodoro session complete!%s\n" theme.text_color "\027[0m";
  Printf.printf "%sSummary:\n  Work: %d min\n  Short breaks: %d min\n  Long break: %d min%s\n"
    theme.text_color
    (!total_work / 60) (!total_break / 60) (long_break / 60)
    "\027[0m"

let get_default_config_path () =
  try
    let home =
      try Sys.getenv "HOME"
      with Not_found -> Filename.dirname (Sys.executable_name)
    in
    Filename.concat home ".pomoconfig.json"
  with _ -> "config.json"

let () =
  let config = ref default_config in
  let config_file = ref (get_default_config_path ()) in
  let work = ref None in
  let break_ = ref None in
  let cycles = ref None in
  let long_break = ref None in
  let beep_enabled = ref None in
  let usage = "Usage: pomodoro [--config FILE] [--work N] [--break N] [--cycles N] [--long-break N] [--beep]" in
  let speclist = [
    ("--config", Arg.Set_string config_file, "Config file (default config.json)");
    ("--work", Arg.Int (fun n -> work := Some n), "Work duration in minutes");
    ("--break", Arg.Int (fun n -> break_ := Some n), "Break duration in minutes");
    ("--cycles", Arg.Int (fun n -> cycles := Some n), "Number of cycles");
    ("--long-break", Arg.Int (fun n -> long_break := Some n), "Long break in minutes");
    ("--beep", Arg.Unit (fun () -> beep_enabled := Some true), "Beep at end of each timer");
  ] in
  Arg.parse speclist (fun _ -> ()) usage;
  config := load_config !config_file;
  let get v def = match v with Some x -> x | None -> def in
  let work = get !work !config.work in
  let break_ = get !break_ !config.break_ in
  let cycles = get !cycles !config.cycles in
  let long_break = get !long_break !config.long_break in
  let beep_enabled = get !beep_enabled !config.beep in
  pomodoro
    ~work:(work * 60)
    ~break_:(break_ * 60)
    ~cycles
    ~long_break:(long_break * 60)
    ~beep_enabled
    ~theme:!config.theme