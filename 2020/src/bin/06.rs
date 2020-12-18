use std::{collections::HashSet, io};

struct Group {
    answers: HashSet<char>,
}

fn main() -> io::Result<()> {
    let groups = include_str!("06.txt")
        .trim()
        .split("\n\n")
        .map(|s| parse_group(s))
        .collect::<Vec<Group>>();

    let part1 = sum_questions(&groups);

    println!("Part 1: {}", part1);

    Ok(())
}

fn sum_questions(groups: &[Group]) -> usize {
    groups.iter().fold(0, |acc, g| acc + g.answers.len())
}

fn parse_group(s: &str) -> Group {
    let mut answers = HashSet::new();

    for line in s.lines() {
        for c in line.chars() {
            answers.insert(c);
        }
    }

    Group { answers }
}
