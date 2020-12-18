use std::{collections::HashSet, io};

fn main() -> io::Result<()> {
    let seat_ids = include_str!("05.txt")
        .lines()
        .map(|boarding_pass| parse_boarding_pass(boarding_pass))
        .collect::<Vec<usize>>();

    let part1 = max_seat_id(&seat_ids);

    println!("Part 1: {}", part1);

    let part2 = find_mine(&seat_ids, part1);

    println!("Part 2: {}", part2);

    Ok(())
}

fn find_mine(seat_ids: &[usize], max_id: usize) -> usize {
    let s: HashSet<usize> = seat_ids.iter().cloned().collect();

    (1..max_id)
        .find(|x| !s.contains(&x) && s.contains(&(*x - 1)) && s.contains(&(*x + 1)))
        .unwrap()
}

fn max_seat_id(seat_ids: &[usize]) -> usize {
    match seat_ids.iter().max() {
        Some(boarding_pass) => *boarding_pass,
        None => panic!(),
    }
}

fn parse_boarding_pass(boarding_pass: &str) -> usize {
    let chars = boarding_pass.chars().collect::<Vec<char>>();
    let row = binary_search(&chars[0..7], 'B');
    let column = binary_search(&chars[7..], 'R');

    row * 8 + column
}

fn binary_search(s: &[char], upper_char: char) -> usize {
    s.iter()
        .fold((0, 2usize.pow((s.len() - 1) as u32)), |acc, c| {
            if *c == upper_char {
                (acc.0 + acc.1, acc.1 / 2)
            } else {
                (acc.0, acc.1 / 2)
            }
        })
        .0
}
