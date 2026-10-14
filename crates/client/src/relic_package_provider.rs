//! Original 903EE0 / 904110 package lookup. Prepared directory tables and
//! acyclic parents are supplied; merged INI and actor selection remain external.
use std::ffi::{CStr, CString};
use crate::relic_namespace_cache::{NamespaceCache, Origin as CacheOrigin};

pub struct PackageProvider {
    skin: NamespaceCache,
    base_directory: NamespaceCache,
    parent: Option<Parent>,
}
pub enum Parent {
    Package(Box<PackageProvider>),
    /// Original base-provider scoped lookup 904E10, with no further parent.
    TerminalGlobal(NamespaceCache),
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Layer { Skin, BaseDirectory, TerminalGlobal, Empty }
pub struct Selected {
    pub value: CString,
    pub layer: Layer,
    pub order_index: Option<usize>,
    pub parent_hops: usize,
}
impl Selected {
    fn empty() -> Self {
        Self { value: CString::default(), layer: Layer::Empty, order_index: None, parent_hops: 0 }
    }
}
impl Parent {
    fn scoped(&mut self, scope: &CStr, requested: &CStr) -> Selected {
        match self {
            Self::Package(package) => package.scoped(scope, requested),
            Self::TerminalGlobal(cache) => {
                let selected = cache.lookup(&[scope], requested);
                if selected.value.to_bytes().is_empty() { return Selected::empty(); }
                Selected { value: selected.value.to_owned(), layer: Layer::TerminalGlobal,
                    order_index: Some(0), parent_hops: 0 }
            }
        }
    }
}
impl PackageProvider {
    pub fn prepared(skin: NamespaceCache, base_directory: NamespaceCache, parent: Option<Parent>) -> Self {
        Self { skin, base_directory, parent }
    }
    /// Only the specified namespace is queried on every parent hop.
    pub fn scoped(&mut self, scope: &CStr, requested: &CStr) -> Selected {
        let selected = self.skin.lookup(&[scope], requested);
        if !selected.value.to_bytes().is_empty() {
            return Selected { value: selected.value.to_owned(), layer: Layer::Skin,
                order_index: Some(0), parent_hops: 0 };
        }
        let selected = self.base_directory.lookup(&[scope], requested);
        if !selected.value.to_bytes().is_empty() {
            return Selected { value: selected.value.to_owned(), layer: Layer::BaseDirectory,
                order_index: Some(0), parent_hops: 0 };
        }
        if let Some(parent) = &mut self.parent {
            let mut selected = parent.scoped(scope, requested);
            if !selected.value.to_bytes().is_empty() { selected.parent_hops += 1; return selected; }
        }
        Selected::empty()
    }
    /// All skin namespaces, all directory namespaces, then scoped parent queries.
    /// An empty active order never searches a fallback provider.
    pub fn lookup(&mut self, order: &[&CStr], requested: &CStr) -> Selected {
        let selected = self.skin.lookup(order, requested);
        if let CacheOrigin::Namespace { order_index } = selected.origin {
            return Selected { value: selected.value.to_owned(), layer: Layer::Skin,
                order_index: Some(order_index), parent_hops: 0 };
        }
        let selected = self.base_directory.lookup(order, requested);
        if let CacheOrigin::Namespace { order_index } = selected.origin {
            return Selected { value: selected.value.to_owned(), layer: Layer::BaseDirectory,
                order_index: Some(order_index), parent_hops: 0 };
        }
        if let Some(parent) = &mut self.parent {
            for (order_index, scope) in order.iter().enumerate() {
                let mut selected = parent.scoped(scope, requested);
                if !selected.value.to_bytes().is_empty() {
                    selected.parent_hops += 1;
                    selected.order_index = Some(order_index);
                    return selected;
                }
            }
        }
        Selected::empty()
    }
}

#[cfg(test)]
#[path = "relic_package_provider_tests.rs"]
mod tests;
