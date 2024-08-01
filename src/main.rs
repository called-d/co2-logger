use std::error::Error;
use std::result::Result;
use std::{env, io::Write};

use chrono::{DateTime, Local};
use co2mon::{Reading, Sensor};
use std::path::Path;
use std::time::SystemTime;

fn read() -> Result<(SystemTime, Reading), Box<dyn Error>> {
    let sensor = Sensor::open_default()?;
    let reading = sensor.read()?;
    let now = SystemTime::now();
    Ok((now, reading))
}

fn append_log(dir: &Path, file_name: String, line: String) -> Result<(), std::io::Error> {
    let mut file = std::fs::OpenOptions::new()
        .create(true)
        .append(true)
        .open(dir.join(file_name))?;
    file.write_fmt(format_args!("{}\n", line))
}

fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<String> = env::args().collect();
    let arg = args[1..].first().expect("$ co2-logger <log-directory>");
    let dir = Path::new(arg);
    assert!(dir.exists() && dir.is_dir());

    let (now, reading) = read()?;

    let unixtime = now.duration_since(SystemTime::UNIX_EPOCH)?;
    let timestamp = unixtime.as_secs();
    let (co2, temperature) = (reading.co2(), reading.temperature());

    let datetime: DateTime<Local> = now.clone().into();
    let file_name = datetime.format("%F").to_string();
    let line = format!("{:?}\t{:?}\t{:?}", timestamp, co2, temperature);
    append_log(dir, file_name, line)?;
    Ok(())
}
