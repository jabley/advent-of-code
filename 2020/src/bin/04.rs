use std::{collections::HashMap, io};

fn main() -> io::Result<()> {
    let passports = include_str!("04.txt")
        .trim()
        .split("\n\n")
        .map(|p| create_passport_map(p))
        .collect::<Vec<HashMap<&str, &str>>>();

    let part1 = count_valid_data(&passports);

    println!("Part 1: {}", part1);

    // Considering the split as valid data versus good data, as per https://www.google.co.uk/books/edition/Building_Scalable_Web_Sites/wIWU94zKEtYC?hl=en&gbpv=1&dq=scalable%20web%20sites%20good%20data&pg=PT110&printsec=frontcover
    let part2 = count_good_data(&passports);

    println!("Part 2: {}", part2);

    Ok(())
}

fn count_good_data(passports: &[HashMap<&str, &str>]) -> usize {
    passports
        .iter()
        .map(|p| is_good(p))
        .filter_map(Result::ok)
        .count()
}

fn is_good(passport: &HashMap<&str, &str>) -> Result<bool, ()> {
    parse_number_field(passport, "byr", 1920, 2002)?;
    parse_number_field(passport, "iyr", 2010, 2020)?;
    parse_number_field(passport, "eyr", 2020, 2030)?;
    parse_height(passport)?;
    parse_hair_colour(passport)?;
    parse_eye_colour(passport)?;
    parse_id(passport)?;

    Ok(true)
}

fn parse_id(passport: &HashMap<&str, &str>) -> Result<(), ()> {
    if let Some(id) = passport.get("pid") {
        if id.len() == 9 && id.chars().all(|c| (c >= '0' && c <= '9')) {
            return Ok(());
        }
    }

    Err(())
}

fn parse_eye_colour(passport: &HashMap<&str, &str>) -> Result<(), ()> {
    if let Some(eye) = passport.get("ecl") {
        match *eye {
            "amb" | "blu" | "brn" | "gry" | "grn" | "hzl" | "oth" => {
                return Ok(());
            }
            _ => {}
        }
    }

    Err(())
}

fn parse_hair_colour(passport: &HashMap<&str, &str>) -> Result<(), ()> {
    if let Some(hair) = passport.get("hcl") {
        if hair.len() == 7
            && hair.starts_with('#')
            && hair[1..]
                .chars()
                .all(|c| (c >= '0' && c <= '9') || (c >= 'a' && c <= 'z'))
        {
            return Ok(());
        }
    }

    Err(())
}

fn parse_height(passport: &HashMap<&str, &str>) -> Result<(), ()> {
    if let Some(value) = passport.get("hgt") {
        let len = value.len();
        let numeric_part = &value[0..(len - 2)];
        match &value[(len - 2)..] {
            "cm" => {
                parse_range(numeric_part, 150, 193)?;
                return Ok(());
            }
            "in" => {
                parse_range(numeric_part, 59, 76)?;
                return Ok(());
            }
            _ => {
                return Err(());
            }
        };
    }

    Err(())
}

fn parse_number_field(
    passport: &HashMap<&str, &str>,
    key: &str,
    min: i32,
    max: i32,
) -> Result<i32, ()> {
    if passport.contains_key(key) {
        return parse_range(passport[key], min, max);
    }
    Err(())
}

fn parse_range(value: &str, min: i32, max: i32) -> Result<i32, ()> {
    let v = value.parse::<i32>().map_err(|_| ())?;

    if v < min || v > max {
        Err(())
    } else {
        Ok(v)
    }
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
    passports.iter().filter(|p| has_expected_fields(p)).count()
}

fn has_expected_fields(passport: &HashMap<&str, &str>) -> bool {
    let expected_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"];
    expected_fields.iter().all(|k| passport.contains_key(k))
}
