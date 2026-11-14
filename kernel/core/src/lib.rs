#![no_std]

//! Platform-independent primitives for the SAIF OS kernel.
//! Boot code will be added after the firmware boundary is selected.

pub const KERNEL_CORE_VERSION: &str = env!("CARGO_PKG_VERSION");

/// A validated half-open physical memory region.
/// This type does not imply that the region is mapped or allocatable.
#[derive(Clone, Copy, Debug, Eq, PartialEq)]
pub struct PhysicalRegion {
    start: u64,
    end: u64,
}

impl PhysicalRegion {
    pub const fn new(start: u64, end: u64) -> Option<Self> {
        if start < end {
            Some(Self { start, end })
        } else {
            None
        }
    }

    pub const fn start(self) -> u64 { self.start }
    pub const fn end(self) -> u64 { self.end }
    pub const fn len(self) -> u64 { self.end - self.start }
    pub const fn is_empty(self) -> bool { false }
}

#[cfg(test)]
extern crate std;

#[cfg(test)]
mod tests {
    use super::PhysicalRegion;

    #[test]
    fn accepts_non_empty_region() {
        let region = PhysicalRegion::new(0x1000, 0x3000).unwrap();
        assert_eq!(region.start(), 0x1000);
        assert_eq!(region.end(), 0x3000);
        assert_eq!(region.len(), 0x2000);
        assert!(!region.is_empty());
    }

    #[test]
    fn rejects_empty_or_reversed_region() {
        assert_eq!(PhysicalRegion::new(7, 7), None);
        assert_eq!(PhysicalRegion::new(9, 7), None);
    }
}
