"""Create a new uncompiled candidate stage from production; never install it."""
from pathlib import Path
import difflib, hashlib, json

out=Path(__file__).resolve().parent
prod=Path(r'E:\OpenLeague\crates\core\src')
files=['audio_loading_metadata.rs','audio_loading_screen_packet.rs',
       'audio_loading_screen_packet_tests.rs','audio_replay_windows_loading_packets.rs',
       'audio_replay_windows_loading_packets_tests.rs']
base={}
for name in files:
    raw=(prod/name).read_bytes();text=raw.decode('utf-8')
    base[name]={'sha256':hashlib.sha256(raw).hexdigest(),'bytes':len(raw)}
    (out/('base_'+name+'.txt')).write_bytes(raw)
    if name=='audio_loading_metadata.rs':
        old='// Only the non-alias, full-string assignment invoked by728410 is exposed.'
        assert old in text
        text=text.replace(old,'// Full-string non-alias assignment from728410 and standard57D71D.\n// Destination may already own a buffer; capacity and old length are preserved.')
        text=text.replace('fn assign(b: &mut impl Boundary, d: u32, s: u32)',
                          'pub(crate) fn assign_owned_non_alias(b: &mut impl Boundary, d: u32, s: u32)')
        text=text.replace('assign(b, cached, source)?','assign_owned_non_alias(b, cached, source)?')
        text=text.replace('assign(b, out, cached)?','assign_owned_non_alias(b, out, cached)?')
    elif name=='audio_loading_screen_packet.rs':
        text=text.replace('        _recipient: u32,\n        _record: u32,',
                          '        _recipient: u32,\n        _retained_service: u32,\n        _record: u32,')
        text=text.replace('b.initialize_standard_record(recipient, record, payload, scratch)',
                          'b.initialize_standard_record(recipient, service, record, payload, scratch)')
        text=text.replace('    /// including on an error. No success is supplied by default.',
                          '    /// including on an error. retained_service is captured before the name\n    /// provider; it must not be replaced by another read of SERVICE_GLOBAL.\n    /// No success is supplied by default.')
    elif name=='audio_loading_screen_packet_tests.rs':
        text=text.replace('        recipient: u32,\n        record: u32,',
                          '        recipient: u32,\n        retained_service: u32,\n        record: u32,')
        old='''        assert_eq!(
            (recipient, record, payload, scratch),'''
        assert old in text
        text=text.replace(old,'''        assert_eq!(retained_service, SERVICE);
        assert_eq!(
            (recipient, record, payload, scratch),''')
    elif name=='audio_replay_windows_loading_packets.rs':
        text=text.replace('    audio_loading_metadata as names, audio_loading_record_tree::Kind,',
                          '    audio_loading_metadata as names, audio_loading_record_tree::Kind,\n    audio_loading_standard_prefix as standard_prefix,')
        old='''    // A real empty metadata name completes without UI. The nonempty standard
    // UI continuation remains an explicit default error.'''
        assert old in text
        text=text.replace(old,'''    fn initialize_standard_record(
        &mut self,
        recipient: u32,
        retained_service: u32,
        _record: u32,
        payload: u32,
        name24: u32,
    ) -> Result<(), &'static str> {
        self.event_temporary(8, |b, scratch| {
            let stop = standard_prefix::prepare(
                b, recipient, retained_service, payload, name24, scratch,
            ).map_err(|e| b.failure(e, "loading name/skin prefix failed"))?;
            // These consumers remain unported. Returning a selected request
            // must never be counted as completed loading UI.
            Err(b.failure(stop, stop.unavailable()))
        })
    }''')
    elif name=='audio_replay_windows_loading_packets_tests.rs':
        # The one UI test intentionally reaches the newly explicit resource
        # boundary. Its recipient is diagnostic; initialize only real inputs.
        start=text.index('fn audio_replay_windows_loading_keeps_missing_standard_ui')
        end=text.index('\n#[test]',start)
        part=text[start:end]
        old='let recipient = Recipient::create(&mut b, Kind::Standard);'
        assert old in part
        part=part.replace(old,old+'''
    // Diagnostic input String24 and sentinel skin; no UI factory is claimed.
    write(&mut b, recipient.p + 0x1a0, u32::MAX);
    write(&mut b, recipient.p + 0x1b8, 0);
    write(&mut b, recipient.p + 0x1bc, 15);
    b.write_byte(recipient.p + 0x1a8, 0).unwrap();''')
        part=part.replace('UI continuation57D6FE','resource provider90AD00')
        text=text[:start]+part+text[end:]
    (out/name).write_text(text,encoding='utf-8',newline='\n')
(out/'base_manifest.json').write_text(json.dumps(base,indent=2)+'\n')
patch=[]
for name in files:
    patch.extend(difflib.unified_diff((out/('base_'+name+'.txt')).read_text().splitlines(True),
                                    (out/name).read_text().splitlines(True),
                                    fromfile=str(prod/name),tofile=str(out/name)))
(out/'changes.patch').write_text(''.join(patch),encoding='utf-8')
print(json.dumps({'candidate_files':files,'compiled':False}))
