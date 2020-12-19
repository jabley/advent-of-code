use std::{collections::HashSet, io};

struct Group {
    anyone_answered: HashSet<char>,
    everyone_answered: HashSet<char>,
}

fn main() -> io::Result<()> {
    let groups = include_str!("06.txt")
        .trim()
        .split("\n\n")
        .map(|s| parse_group(s))
        .collect::<Vec<Group>>();

    let part1 = sum_questions(&groups);

    println!("Part 1: {}", part1);

    println!(
        "Part 2: {}",
        groups
            .iter()
            .fold(0, |acc, g| acc + g.everyone_answered.len())
    );

    Ok(())
}

fn sum_questions(groups: &[Group]) -> usize {
    groups
        .iter()
        .fold(0, |acc, g| acc + g.anyone_answered.len())
}

fn parse_group(s: &str) -> Group {
    let mut anyone_answered = HashSet::new();
    let mut everyone_answered = HashSet::new();

    let mut first = true;

    for line in s.lines() {
        let mut individual_answers = HashSet::new();

        for c in line.chars() {
            anyone_answered.insert(c);
            individual_answers.insert(c);
        }

        if first {
            everyone_answered = individual_answers;
            first = false;
        } else {
            everyone_answered = everyone_answered
                .intersection(&individual_answers)
                .cloned()
                .collect();
        }
    }

    Group {
        anyone_answered,
        everyone_answered,
    }
}
