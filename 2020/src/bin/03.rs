use std::io;

fn main() -> io::Result<()> {
    let grid = include_str!("03.txt")
        .lines()
        .map(|line| line.chars().map(|c| c == '#').collect())
        .collect::<Vec<Vec<bool>>>();

    let part1 = count_trees(&grid, 3, 1);

    println!("Part 1: {}", part1);

    let part2 = count_trees(&grid, 1, 1)
        * part1
        * count_trees(&grid, 5, 1)
        * count_trees(&grid, 7, 1)
        * count_trees(&grid, 1, 2);

    println!("Part 2: {}", part2);

    Ok(())
}

fn count_trees(grid: &[Vec<bool>], dx: usize, dy: usize) -> i64 {
    let height = grid.len();
    let width = grid[0].len();

    let mut x = 0;
    let mut y = 0;

    let mut result = 0;

    while y + dy < height {
        x += dx;
        x %= width;
        y += dy;
        if grid[y][x] {
            result += 1;
        }
    }

    result
}
