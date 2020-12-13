use std::io;

struct PasswordLine<'a> {
    first: usize,
    second: usize,
    ch: char,
    value: &'a str,
}

enum ParsingErr {
    NumberPair,
    Integer,
    Char,
    Password,
}

fn main() -> io::Result<()> {
    let content = include_str!("02.txt")
        .lines()
        .flat_map(|line| parse_line(line))
        .collect::<Vec<PasswordLine>>();

    let part1 = content.iter().filter(|pwd| validate_password(pwd)).count();

    println!("Part 1: {:?}", part1);

    let part2 = content
        .iter()
        .filter(|pwd| validate_new_policy(pwd))
        .count();

    println!("Part 2: {:?}", part2);

    Ok(())
}

fn validate_new_policy(pwd: &PasswordLine) -> bool {
    let mut count = match pwd.value.chars().nth(pwd.first - 1) {
        Some(c) => {
            if c == pwd.ch {
                1
            } else {
                0
            }
        }
        _ => 0,
    };

    count += match pwd.value.chars().nth(pwd.second - 1) {
        Some(c) => {
            if c == pwd.ch {
                1
            } else {
                0
            }
        }
        _ => 0,
    };

    count == 1
}

fn validate_password(pwd: &PasswordLine) -> bool {
    let count = pwd.value.matches(pwd.ch).count();

    count >= pwd.first && count <= pwd.second
}

// parse_line takes a line of the format '14-16 m: mmmmtmmmmmlmmmdmmm' and splits it out
fn parse_line(line: &str) -> Result<PasswordLine, ParsingErr> {
    let mut parts = line.split(' ');
    let policy = parts
        .next()
        .ok_or_else(|| ParsingErr::NumberPair)?
        .split('-')
        .collect::<Vec<&str>>();
    let first = policy[0].parse().map_err(|_| ParsingErr::Integer)?;
    let second = policy[1].parse().map_err(|_| ParsingErr::Integer)?;
    let ch = parts
        .next()
        .ok_or_else(|| ParsingErr::Char)?
        .chars()
        .next()
        .ok_or_else(|| ParsingErr::Char)?;
    let value = parts.next().ok_or_else(|| ParsingErr::Password)?;

    Ok(PasswordLine {
        first,
        second,
        ch,
        value,
    })
}
