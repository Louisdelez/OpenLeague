use super::*;

struct Owner {
    id: u32,
    priority: i32,
    name: &'static [u8],
    flags: u32,
    shader44: u32,
    shader48: u32,
}
enum Call {
    Add { id: Option<u32>, order: &'static [u32], allocations: usize },
    Remove { id: u32, order: &'static [u32], frees: usize },
    Select { floor: i32, name: Option<&'static [u8]>, mask: u32, out: bool,
        null_range: bool, eligible: &'static [u32], selected: Option<u32> },
}
struct Life { name: &'static str, fill: u8, owners: &'static [Owner], calls: &'static [Call] }
include!("native_cases.rs");

#[test]
fn matches_all_original_x86_operations() {
    let mut count = 0;
    for life in LIVES {
        let mut component = Component::default();
        let owner = |id| life.owners.iter().find(|o| o.id == id).unwrap();
        for (call_index, call) in life.calls.iter().enumerate() {
            count += 1;
            match call {
                Call::Add { id, order, allocations } => {
                    let changed = component.insert(id.map(|id| id + 1).unwrap_or(0),
                        id.map(|id| owner(id).priority).unwrap_or(0)).unwrap();
                    assert_eq!(usize::from(changed), *allocations);
                    assert_eq!(component.entries().iter().map(|e| e.owner - 1).collect::<Vec<_>>(), *order,
                        "{} fill{} call{}", life.name, life.fill, call_index);
                }
                Call::Remove { id, order, frees } => {
                    let changed = component.remove(id + 1, owner(*id).priority).unwrap();
                    assert_eq!(usize::from(changed), *frees);
                    assert_eq!(component.entries().iter().map(|e| e.owner - 1).collect::<Vec<_>>(), *order);
                }
                Call::Select { floor, name, mask, out, null_range, eligible, selected } => {
                    let range = component.priority_range(*floor);
                    assert_eq!(range.iter().map(|e| e.owner - 1).collect::<Vec<_>>(), *eligible);
                    let mut output = 0xdecafbad;
                    let actual = select(if *null_range { None } else { Some(range) }, *name, *mask, |id| {
                        let o = owner(id - 1);
                        Some(Properties { submesh: o.name, flags: o.flags, shader44: o.shader44, shader48: o.shader48 })
                    }, if *out { Some(&mut output) } else { None }).unwrap();
                    assert_eq!(actual.map(|id| id - 1), *selected, "{} fill{} call{}", life.name, life.fill, call_index);
                    assert_eq!(output, if *out && selected.is_some() {
                        eligible.iter().position(|id| Some(*id) == *selected).unwrap()
                    } else { 0xdecafbad });
                }
            }
        }
        assert!(component.entries().is_empty());
    }
    assert_eq!(count, NATIVE_CALL_COUNT);
}

#[test]
fn explicit_host_boundary_errors_do_not_claim_native_exception_parity() {
    let mut component = Component::default();
    assert_eq!(component.remove(0, 0), Err(Error::NullOwner));
    component.insert(1, 0).unwrap();
    let mut output = 77;
    assert_eq!(select(Some(component.entries()), None, 0, |_| None, Some(&mut output)), Err(Error::MissingOwner(1)));
    assert_eq!(output, 77);
    assert_eq!(select(None, None, 0, |_| panic!("null range must not look up"), Some(&mut output)), Ok(None));
    assert_eq!(output, 77);
    assert_eq!(component.entries(), &[Entry { owner: 1, priority: 0 }]);
}
