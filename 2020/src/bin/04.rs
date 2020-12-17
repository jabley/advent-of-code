use std::{collections::HashMap, io};

fn main() -> io::Result<()> {
    let passports = include_str!("04.txt")
        .trim()
        .split("\n\n")
        .map(|p| create_passport_map(p))
        .collect::<Vec<HashMap<&str, &str>>>();

    let part1 = count_valid_data(&passports);

    println!("Part 1: {}", part1);

    Ok(())
}

fn create_passport_map(s: &str) -> HashMap<&str, &str> {
    s.split(|c| c == ' ' || c == '\n')
        .map(|pair| {
            let key_value = pair.split(':').collect::<Vec<&str>>();
            (key_value[0], key_value[1])
        })
        .collect()
}

fn count_valid_data(passports: &[HashMap<&str, &str>]) -> usize {
    passports
        .iter()
        .filter(|p| has_expected_fields(p))
        .count()
}

fn has_expected_fields(passport: &HashMap<&str, &str>) -> bool {
    let expected_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];
    expected_fields.iter().all(|k| passport.contains_key(k))
}
