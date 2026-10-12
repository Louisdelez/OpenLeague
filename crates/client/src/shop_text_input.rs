//! Local shop text editing policy. No native Riot input-loop claim.
//! Clipboard content is read only on a fresh, focused Ctrl+V, never logged.
use bevy::{prelude::*, input::{ButtonState, keyboard::KeyboardInput}};
use std::collections::HashSet;

const QUERY_CHARS: usize = 64;
const CLIPBOARD_BYTES: usize = 64 * 1024;

#[derive(Default)]
pub(crate) struct Input {
    held: HashSet<KeyCode>,
    window: Option<Entity>,
    identity: Option<(u64, u32)>,
    active: bool,
    pub(super) error: Option<&'static str>,
}
impl Input {
    pub(super) fn reset(&mut self) { *self = Self::default(); }

    pub(super) fn update<'a>(&mut self, query: &mut String, focused: &mut bool,
        open: bool, window: Option<(Entity, bool)>, identity: Option<(u64, u32)>,
        lost: bool, events: impl Iterator<Item = &'a KeyboardInput>,
        mut paste: impl FnMut() -> Result<String, &'static str>,
    ) {
        let Some((window, true)) = window else { self.reset(); *focused = false; return; };
        if lost { self.reset(); *focused = false; return; }
        if self.window != Some(window) || self.identity != identity {
            self.reset(); self.window = Some(window); self.identity = identity;
        }
        if !open { *focused = false; }
        let active = open && *focused;
        // Click/keyboard streams have no joint chronology. Discard text on the
        // activation frame, but retain that window's ordered modifier state.
        let accept = active && self.active;
        if !active { self.error = None; }
        self.active = active;
        for event in events.filter(|event| event.window == window) {
            if event.state == ButtonState::Released { self.held.remove(&event.key_code); continue; }
            let fresh = self.held.insert(event.key_code);
            if !accept || !*focused || (event.repeat && fresh) || (!event.repeat && !fresh) { continue; }
            self.key(query, focused, event, fresh, &mut paste);
        }
        self.active = open && *focused;
    }

    fn key(&mut self, query: &mut String, focused: &mut bool, event: &KeyboardInput,
        fresh: bool, paste: &mut impl FnMut() -> Result<String, &'static str>,
    ) {
        let ctrl = self.held.contains(&KeyCode::ControlLeft) || self.held.contains(&KeyCode::ControlRight);
        let right_alt = self.held.contains(&KeyCode::AltRight);
        let alt = self.held.contains(&KeyCode::AltLeft) || right_alt;
        let meta = self.held.contains(&KeyCode::SuperLeft) || self.held.contains(&KeyCode::SuperRight);
        if ctrl && !alt && !meta && event.key_code == KeyCode::KeyV {
            // Never insert event.text (often "v") or repeat a held paste.
            if fresh && !event.repeat {
                match paste() {
                    Ok(value) => { append(query, &value); self.error = None; }
                    Err(error) => self.error = Some(error),
                }
            }
            return;
        }
        // Right Alt may produce AltGr text with a synthetic Control on Windows.
        // Other shortcut chords are not literal search text.
        if meta || (ctrl && !right_alt) || (alt && !right_alt) { return; }
        match event.key_code {
            KeyCode::Backspace => { query.pop(); self.error = None; }
            KeyCode::Enter | KeyCode::Escape => { *focused = false; self.error = None; }
            _ => if let Some(text) = &event.text { append(query, text); self.error = None; },
        }
    }
}

fn append(query: &mut String, text: &str) {
    let remaining = QUERY_CHARS.saturating_sub(query.chars().count());
    query.extend(text.chars().filter(|c| !c.is_control()).take(remaining));
}

fn decode(units: &[u16]) -> Result<String, &'static str> {
    if units.len() > CLIPBOARD_BYTES / 2 { return Err("Collage refusé : texte trop long."); }
    let end = units.iter().position(|unit| *unit == 0).ok_or("Collage refusé : texte non terminé.")?;
    String::from_utf16(&units[..end]).map_err(|_| "Collage refusé : texte Unicode invalide.")
}

#[cfg(not(windows))]
pub(super) fn clipboard_text() -> Result<String, &'static str> {
    Err("Collage système indisponible sur cette plateforme.")
}

#[cfg(windows)]
pub(super) fn clipboard_text() -> Result<String, &'static str> { windows::read() }

#[cfg(windows)]
mod windows {
    use std::ffi::c_void;
    type Handle = *mut c_void;
    #[link(name = "user32")]
    unsafe extern "system" {
        fn OpenClipboard(window: Handle) -> i32;
        fn CloseClipboard() -> i32;
        fn GetClipboardData(format: u32) -> Handle;
    }
    #[link(name = "kernel32")]
    unsafe extern "system" {
        fn GlobalSize(handle: Handle) -> usize;
        fn GlobalLock(handle: Handle) -> *mut c_void;
        fn GlobalUnlock(handle: Handle) -> i32;
        fn SetLastError(code: u32);
        fn GetLastError() -> u32;
    }
    struct Open(bool);
    impl Open {
        fn close(&mut self) -> Result<(), &'static str> {
            if !self.0 { return Ok(()); }
            if unsafe { CloseClipboard() } == 0 { return Err("Collage refusé : fermeture du presse-papiers impossible."); }
            self.0 = false; Ok(())
        }
    }
    impl Drop for Open { fn drop(&mut self) { let _ = self.close(); } }
    struct Locked { handle: Handle, active: bool }
    impl Locked {
        fn unlock(&mut self) -> Result<(), &'static str> {
            if !self.active { return Ok(()); }
            unsafe {
                SetLastError(0);
                let result = GlobalUnlock(self.handle);
                let error = GetLastError();
                if result == 0 && error != 0 { return Err("Collage refusé : déverrouillage impossible."); }
            }
            self.active = false; Ok(())
        }
    }
    impl Drop for Locked { fn drop(&mut self) { let _ = self.unlock(); } }

    pub(super) fn read() -> Result<String, &'static str> {
        // Read-only OpenClipboard(NULL) associates this call with its thread.
        // Never EmptyClipboard, SetClipboardData, or free the borrowed handle.
        if unsafe { OpenClipboard(std::ptr::null_mut()) } == 0 {
            return Err("Presse-papiers indisponible ; réessayez le collage.");
        }
        let mut open = Open(true);
        let result = (|| {
            let handle = unsafe { GetClipboardData(13) }; // CF_UNICODETEXT
            if handle.is_null() { return Err("Le presse-papiers ne contient pas de texte Unicode."); }
            let bytes = unsafe { GlobalSize(handle) };
            if bytes < 2 || bytes > super::CLIPBOARD_BYTES || bytes % 2 != 0 {
                return Err("Collage refusé : taille du texte invalide.");
            }
            let pointer = unsafe { GlobalLock(handle) };
            if pointer.is_null() { return Err("Collage refusé : lecture du presse-papiers impossible."); }
            let mut locked = Locked { handle, active: true };
            let copied = if (pointer as usize) % std::mem::align_of::<u16>() == 0 {
                // Size checked against the OS allocation. The clipboard remains
                // open and the global block locked until the UTF-16 copy ends.
                super::decode(unsafe { std::slice::from_raw_parts(pointer.cast::<u16>(), bytes / 2) })
            } else { Err("Collage refusé : texte non aligné.") };
            locked.unlock()?;
            copied
        })(); // Locked is retired before Open on success, error, and unwinding.
        let closed = open.close();
        closed?;
        result
    }
}

#[cfg(test)]
#[path = "shop_text_input_tests.rs"]
mod tests;
