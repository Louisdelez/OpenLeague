//! Reconstructed point-agent circle navigation. No terrain or spell state is owned here.
use crate::{Navigation, Point};
use std::collections::{HashMap, VecDeque};

#[derive(Clone, Copy, Debug)]
pub(crate) struct Circle {
    pub center: Point,
    pub radius: f32,
}

fn valid_grid(nav: &Navigation) -> bool {
    let m = &nav.metadata;
    m.width > 0
        && m.height > 0
        && m.width <= isize::MAX as usize
        && m.height <= isize::MAX as usize
        && m.width.checked_mul(m.height) == Some(nav.cells.len())
        && m.cell_size.is_finite()
        && m.cell_size > 0.
        && m.min.iter().all(|v| v.is_finite())
}

fn valid_circles(circles: &[Circle]) -> bool {
    circles
        .iter()
        .all(|c| c.center.finite() && c.radius.is_finite() && c.radius > 0.)
}

fn grid_point(nav: &Navigation, p: Point) -> (f64, f64) {
    (
        (f64::from(p.x) - f64::from(nav.metadata.min[0]))
            / f64::from(nav.metadata.cell_size),
        (f64::from(p.z) - f64::from(nav.metadata.min[2]))
            / f64::from(nav.metadata.cell_size),
    )
}

fn bounded_index(nav: &Navigation, p: Point) -> Option<usize> {
    if !p.finite() {
        return None;
    }
    let (x, z) = grid_point(nav, p);
    if !(0. <= x
        && x < nav.metadata.width as f64
        && 0. <= z
        && z < nav.metadata.height as f64)
    {
        return None;
    }
    let index = (z.floor() as usize)
        .checked_mul(nav.metadata.width)?
        .checked_add(x.floor() as usize)?;
    // Preserve the static navigation cell convention. Fail closed on a
    // floating-point boundary that the two computations classify differently.
    (index < nav.cells.len() && nav.index(p) == Some(index)).then_some(index)
}

fn cell_open(nav: &Navigation, x: isize, z: isize) -> bool {
    x >= 0
        && z >= 0
        && (x as usize) < nav.metadata.width
        && (z as usize) < nav.metadata.height
        && nav.cells[z as usize * nav.metadata.width + x as usize].1
}

fn circle_distance_squared(p: Point, c: Circle) -> f64 {
    let x = f64::from(p.x) - f64::from(c.center.x);
    let z = f64::from(p.z) - f64::from(c.center.z);
    x * x + z * z
}

fn circle_segment_clear(a: Point, b: Point, c: Circle) -> bool {
    let dx = f64::from(b.x) - f64::from(a.x);
    let dz = f64::from(b.z) - f64::from(a.z);
    let ax = f64::from(a.x) - f64::from(c.center.x);
    let az = f64::from(a.z) - f64::from(c.center.z);
    let length_squared = dx * dx + dz * dz;
    let t = if length_squared == 0. {
        0.
    } else {
        (-(ax * dx + az * dz) / length_squared).clamp(0., 1.)
    };
    let x = ax + t * dx;
    let z = az + t * dz;
    x * x + z * z >= f64::from(c.radius).powi(2)
}

fn terrain_segment(nav: &Navigation, a: Point, b: Point) -> bool {
    let (Some(start), Some(end)) = (bounded_index(nav, a), bounded_index(nav, b)) else {
        return false;
    };
    if !nav.cells[start].1 || !nav.cells[end].1 {
        return false;
    }
    if a == b {
        return true;
    }
    let width = nav.metadata.width;
    let (mut x, mut z) = ((start % width) as isize, (start / width) as isize);
    let (end_x, end_z) = ((end % width) as isize, (end / width) as isize);
    let (ax, az) = grid_point(nav, a);
    let (bx, bz) = grid_point(nav, b);
    let (dx, dz) = (bx - ax, bz - az);
    let axis = |origin: f64, delta: f64, cell: isize| {
        if delta > 0. {
            (1, (cell as f64 + 1. - origin) / delta, 1. / delta)
        } else if delta < 0. {
            (-1, (origin - cell as f64) / -delta, 1. / -delta)
        } else {
            (0, f64::INFINITY, f64::INFINITY)
        }
    };
    let (step_x, mut next_x, delta_x) = axis(ax, dx, x);
    let (step_z, mut next_z, delta_z) = axis(az, dz, z);
    let on_vertical = dx == 0. && ax.fract() == 0. && x > 0;
    let on_horizontal = dz == 0. && az.fract() == 0. && z > 0;
    let open = |cx, cz| {
        cell_open(nav, cx, cz)
            && (!on_vertical || cell_open(nav, cx - 1, cz))
            && (!on_horizontal || cell_open(nav, cx, cz - 1))
    };
    let Some(limit) = x
        .abs_diff(end_x)
        .checked_add(z.abs_diff(end_z))
        .and_then(|n| n.checked_add(1))
    else {
        return false;
    };
    // Each iteration moves at least one cell toward the exact end cell.
    for _ in 0..limit {
        if !open(x, z) {
            return false;
        }
        if (x, z) == (end_x, end_z) {
            return true;
        }
        if next_x < next_z {
            x += step_x;
            next_x += delta_x;
        } else if next_z < next_x {
            z += step_z;
            next_z += delta_z;
        } else {
            // A corner must not allow a diagonal crack between blocked cells.
            if !open(x + step_x, z) || !open(x, z + step_z) {
                return false;
            }
            x += step_x;
            z += step_z;
            next_x += delta_x;
            next_z += delta_z;
        }
    }
    false
}

pub(crate) fn point_allowed(nav: &Navigation, p: Point, circles: &[Circle]) -> bool {
    valid_grid(nav)
        && valid_circles(circles)
        && bounded_index(nav, p).is_some_and(|i| nav.cells[i].1)
        && circles
            .iter()
            .all(|c| circle_distance_squared(p, *c) >= f64::from(c.radius).powi(2))
}

pub(crate) fn segment_allowed(
    nav: &Navigation,
    a: Point,
    b: Point,
    circles: &[Circle],
) -> bool {
    valid_grid(nav)
        && valid_circles(circles)
        && terrain_segment(nav, a, b)
        && circles.iter().all(|c| circle_segment_clear(a, b, *c))
}

pub(crate) fn path(
    nav: &Navigation,
    start: Point,
    end: Point,
    circles: &[Circle],
) -> Option<VecDeque<Point>> {
    if circles.is_empty() {
        return nav.path(start, end);
    }
    if !point_allowed(nav, start, circles) || !point_allowed(nav, end, circles) {
        return None;
    }
    let (s, g) = (bounded_index(nav, start)?, bounded_index(nav, end)?);
    if s == g {
        return segment_allowed(nav, start, end, circles).then(|| VecDeque::from([end]));
    }
    let at = |i| if i == s { start } else if i == g { end } else { nav.center(i) };
    let mut queue = VecDeque::from([s]);
    let mut parent = HashMap::from([(s, s)]);
    while let Some(i) = queue.pop_front() {
        if i == g {
            let mut result = VecDeque::new();
            let mut n = g;
            while n != s {
                result.push_front(at(n));
                n = parent[&n];
            }
            return Some(result);
        }
        let (x, z) = ((i % nav.metadata.width) as isize, (i / nav.metadata.width) as isize);
        for (dx, dz) in [(1, 0), (-1, 0), (0, 1), (0, -1)] {
            let (nx, nz) = (x + dx, z + dz);
            if !cell_open(nav, nx, nz) {
                continue;
            }
            let n = nz as usize * nav.metadata.width + nx as usize;
            if !parent.contains_key(&n) && segment_allowed(nav, at(i), at(n), circles) {
                parent.insert(n, i);
                queue.push_back(n);
            }
        }
    }
    None
}

pub(crate) fn nearest_walkable(
    nav: &Navigation,
    point: Point,
    circles: &[Circle],
) -> Option<Point> {
    if circles.is_empty() {
        return nav.nearest_walkable(point);
    }
    if !point.finite() || !valid_grid(nav) || !valid_circles(circles) {
        return None;
    }
    // Destination snapping is independent of a route's origin. A blocked or
    // out-of-map requested point may snap to a valid center; path(start, snap)
    // remains responsible for terrain and pillar accessibility afterward.
    nav.cells
        .iter()
        .enumerate()
        .filter(|(_, cell)| cell.1)
        .map(|(i, _)| nav.center(i))
        .filter(|p| point_allowed(nav, *p, circles))
        .min_by(|a, b| {
            let squared = |p: Point| {
                let x = f64::from(p.x) - f64::from(point.x);
                let z = f64::from(p.z) - f64::from(point.z);
                x * x + z * z
            };
            squared(*a).total_cmp(&squared(*b))
        })
}

#[cfg(test)]
mod tests {
    use super::*;

    fn grid(width: usize, height: usize, size: f32, blocked: &[usize]) -> Navigation {
        Navigation {
            metadata: crate::NavigationMetadata {
                min: [0., 0., 0.],
                cell_size: size,
                width,
                height,
            },
            cells: (0..width * height)
                .map(|i| (0., !blocked.contains(&i), if blocked.contains(&i) { 2 } else { 0 }))
                .collect(),
        }
    }

    #[test]
    fn empty_pillars_preserve_old_path_and_nearest_outputs() {
        let nav = grid(8, 6, 50., &[10, 18, 26]);
        let start = Point { x: 25., z: 125. };
        for end in [Point { x: 375., z: 125. }, Point { x: 125., z: 125. }, start] {
            assert_eq!(path(&nav, start, end, &[]), nav.path(start, end));
            assert_eq!(nearest_walkable(&nav, end, &[]), nav.nearest_walkable(end));
        }
        let invalid = Point { x: f32::NAN, z: 0. };
        assert_eq!(path(&nav, start, invalid, &[]), nav.path(start, invalid));
        assert_eq!(nearest_walkable(&nav, invalid, &[]), nav.nearest_walkable(invalid));
    }

    #[test]
    fn multiple_pillars_require_real_detours_and_reject_blocked_endpoint() {
        let nav = grid(12, 9, 50., &[]);
        let circles = [
            Circle { center: Point { x: 225., z: 225. }, radius: 85. },
            Circle { center: Point { x: 425., z: 225. }, radius: 85. },
        ];
        let start = Point { x: 25., z: 225. };
        let end = Point { x: 575., z: 225. };
        assert!(!segment_allowed(&nav, start, end, &circles));
        let route = path(&nav, start, end, &circles).unwrap();
        assert_eq!(route.back(), Some(&end));
        assert!(route.iter().any(|p| (p.z - start.z).abs() >= 100.));
        let mut previous = start;
        for next in route {
            assert!(segment_allowed(&nav, previous, next, &circles));
            previous = next;
        }
        assert!(path(&nav, start, circles[0].center, &circles).is_none());
    }

    #[test]
    fn new_pillar_invalidates_precomputed_segment_with_exact_tangent_allowed() {
        let nav = grid(10, 8, 50., &[]);
        let start = Point { x: 25., z: 175. };
        let end = Point { x: 475., z: 175. };
        assert!(nav.path(start, end).is_some());
        let circle = Circle { center: Point { x: 250., z: 175. }, radius: 150. };
        assert!(!segment_allowed(&nav, start, end, &[circle]));
        assert!(segment_allowed(&nav, Point { x: 25., z: 325. }, Point { x: 475., z: 325. }, &[circle]));
        assert!(point_allowed(&nav, Point { x: 250., z: 325. }, &[circle]));
        assert!(!point_allowed(&nav, Point { x: 250., z: 324.75 }, &[circle]));
        let small = grid(2, 2, 100., &[]);
        let subcell = Circle { center: Point { x: 50., z: 25. }, radius: 10. };
        let (a, b) = (Point { x: 25., z: 25. }, Point { x: 75., z: 25. });
        assert!(point_allowed(&small, a, &[subcell]) && point_allowed(&small, b, &[subcell]));
        assert!(path(&small, a, b, &[subcell]).is_none());
    }

    #[test]
    fn terrain_dda_blocks_thin_walls_corners_and_unsafe_ejection() {
        let nav = grid(8, 5, 50., &[3, 11, 19, 27, 35]);
        assert!(!segment_allowed(&nav, Point { x: 25., z: 125. }, Point { x: 375., z: 125. }, &[]));
        let diagonal = grid(3, 3, 50., &[1, 3]);
        assert!(!segment_allowed(&diagonal, Point { x: 25., z: 25. }, Point { x: 125., z: 125. }, &[]));
        let line = grid(3, 3, 50., &[0]);
        assert!(!segment_allowed(&line, Point { x: 50., z: 25. }, Point { x: 50., z: 125. }, &[]));
        let trapped = grid(5, 3, 50., &[2, 7, 12]);
        let inside = Point { x: 25., z: 75. };
        let circle = Circle { center: inside, radius: 100. };
        let snapped = nearest_walkable(&trapped, inside, &[circle]).unwrap();
        assert!(point_allowed(&trapped, snapped, &[circle]));
        // A snapped destination is not authorization to teleport or eject.
        assert!(!segment_allowed(&trapped, inside, snapped, &[circle]));
        let open = grid(8, 8, 50., &[]);
        let start = Point { x: 175., z: 175. };
        let own = Circle { center: start, radius: 75. };
        let exit = nearest_walkable(&open, start, &[own]).unwrap();
        assert!(point_allowed(&open, exit, &[own]));
        assert!(terrain_segment(&open, start, exit));
        assert!(!segment_allowed(&open, start, exit, &[own]));
    }

    #[test]
    fn destination_snap_accepts_blocked_outside_and_barrier_separated_requests() {
        let nav = grid(9, 7, 50., &[31]);
        let circles = [Circle { center: Point { x: 225., z: 125. }, radius: 60. }];
        let requested = Point { x: 225., z: 175. };
        assert!(!point_allowed(&nav, requested, &circles));
        let snap = nearest_walkable(&nav, requested, &circles).unwrap();
        assert!(point_allowed(&nav, snap, &circles));
        assert_eq!(snap.distance(requested), 50.);
        assert!(path(&nav, Point { x: 25., z: 175. }, snap, &circles).is_some());
        let outside = Point { x: 475., z: 175. };
        assert_eq!(nearest_walkable(&nav, outside, &circles), Some(Point { x: 425., z: 175. }));
        let barrier = grid(5, 3, 50., &[2, 7, 12]);
        let harmless = [Circle { center: Point { x: 25., z: 25. }, radius: 5. }];
        let behind = Point { x: 225., z: 75. };
        assert_eq!(nearest_walkable(&barrier, behind, &harmless), Some(behind));
        assert!(path(&barrier, Point { x: 25., z: 75. }, behind, &harmless).is_none());
        let blocked = Point { x: 125., z: 75. };
        let near_blocked = nearest_walkable(&barrier, blocked, &harmless).unwrap();
        assert_eq!(near_blocked.distance(blocked), 50.);
        assert!(point_allowed(&barrier, near_blocked, &harmless));
    }

    #[test]
    fn invalid_numbers_grid_and_map_bounds_fail_closed_with_active_pillar() {
        let nav = grid(4, 4, 50., &[]);
        let good = Point { x: 25., z: 25. };
        let circle = Circle { center: Point { x: 150., z: 150. }, radius: 10. };
        for point in [Point { x: f32::NAN, z: 25. }, Point { x: f32::INFINITY, z: 25. }, Point { x: -0.25, z: 25. }, Point { x: 200., z: 25. }, Point { x: f32::MAX, z: 25. }] {
            assert!(!point_allowed(&nav, point, &[circle]));
            assert!(!segment_allowed(&nav, good, point, &[circle]));
            assert!(path(&nav, good, point, &[circle]).is_none());
            assert_eq!(nearest_walkable(&nav, point, &[circle]).is_some(), point.finite());
        }
        for radius in [0., -1., f32::NAN, f32::INFINITY] {
            assert!(!point_allowed(&nav, good, &[Circle { radius, ..circle }]));
        }
        assert!(!point_allowed(&nav, good, &[Circle { center: Point { x: f32::NAN, z: 1. }, ..circle }]));
        for size in [0., -1., f32::NAN, f32::INFINITY] {
            let mut invalid = nav.clone();
            invalid.metadata.cell_size = size;
            assert!(!segment_allowed(&invalid, good, good, &[circle]));
        }
        let mut mismatch = nav.clone();
        mismatch.cells.pop();
        assert!(!point_allowed(&mismatch, good, &[circle]));
    }
}
