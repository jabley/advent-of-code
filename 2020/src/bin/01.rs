use std::io;

fn main() -> io::Result<()> {
    let input = include_str!("01.txt")
        .trim()
        .split('\n')
        .map(|x| x.parse().expect("not a number"))
        .collect::<Vec<i64>>();

    'part_1: for first in &input {
        for second in &input {
            if first + second == 2020 {
                println!("Part 1: {:?}", first * second);
                break 'part_1;
            }
        }
    }

    'part_2: for first in &input {
        for second in &input {
            for third in &input {
                if first + second + third == 2020 {
                    println!("Part 2: {:?}", first * second * third);
                    break 'part_2;
                }
            }
        }
    }

    Ok(())
}
