const std = @import("std");

const List = std.ArrayList;
const NumList = List(isize);

const print = std.debug.print;
const tokenizeSeq = std.mem.tokenizeSequence;
const tokenizeSca = std.mem.tokenizeScalar;
const parseInt = std.fmt.parseInt;

const data = @embedFile("data/day01.txt");

const Solution = struct {
    fn populateLists(first: *NumList, second: *NumList) !void {
        var lines = tokenizeSca(u8, data, '\n');
        while (lines.next()) |line| {
            var segments = tokenizeSca(u8, line, ' ');
            var index: usize = 0;
            while (segments.next()) |seg| : (index += 1) {
                const num = try parseInt(isize, seg, 10);
                try if (index == 0) first.append(num) else second.append(num);
            }
        }
    }

    fn part1(alloc: std.mem.Allocator) !usize {
        var listA = NumList.init(alloc);
        var listB = NumList.init(alloc);
        try populateLists(&listA, &listB);

        std.mem.sort(isize, listA.items, {}, std.sort.asc(isize));
        std.mem.sort(isize, listB.items, {}, std.sort.asc(isize));

        var sum: usize = 0;
        for (listA.items, listB.items) |a, b| {
            sum += @abs(a - b);
        }
        return sum;
    }

    fn part2(alloc: std.mem.Allocator) !usize {
        var listA = NumList.init(alloc);
        var listB = NumList.init(alloc);
        try populateLists(&listA, &listB);

        var sum: usize = 0;

        for (listA.items) |elm| {
            const needle = [_]isize{elm};
            const count = std.mem.count(isize, listB.items, &needle);
            sum += count * @as(usize, @intCast(elm));
        }

        return sum;
    }
};

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const alloc = arena.allocator();

    print("Part 1 Solution: {d}\n", .{try Solution.part1(alloc)});
    print("Part 2 Solution: {d}\n", .{try Solution.part2(alloc)});
}
