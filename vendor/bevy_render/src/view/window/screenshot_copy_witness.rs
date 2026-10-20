//! Opt-in screenshot copy identity, not a DrawMaterial, uniform or exposure proof.
//! This source is not installed or compiled. Legacy screenshot event/channel ABI is kept.
use super::*;

/// Attach only to a one-shot Screenshot entity. Zero is invalid; retries need a new entity/id.
#[derive(Component, Clone, Copy, Debug)]
pub struct ScreenshotCopyRequest { pub request_id: u64 }

/// Set from the application's actual collected/extracted frame serial, not a wall clock.
/// Absent/zero means the opt-in request is explicitly skipped.
#[derive(Resource, Clone, Copy, Debug, Default)]
pub struct ScreenshotCopyFrameSerial(pub u64);

#[derive(Component, Clone, Debug, PartialEq)]
pub struct ScreenshotCopySelection {
    pub entity: Entity,
    pub request_id: u64,
    pub frame_serial: u64,
    pub target: NormalizedRenderTarget,
}

/// Render-world selections of this extraction only. This is not a copy receipt.
#[derive(Resource, Default)]
pub struct ScreenshotCopySelections(pub(super) EntityHashMap<ScreenshotCopySelection>);
impl ScreenshotCopySelections {
    pub fn iter(&self) -> impl Iterator<Item = (&Entity, &ScreenshotCopySelection)> { self.0.iter() }
    pub fn get(&self, entity: Entity) -> Option<&ScreenshotCopySelection> { self.0.get(&entity) }
}

/// Fired in MainWorld by extraction, after selection has been attached to its exact entity.
/// The consumer may freeze owner/phase/camera/CPU facts; this event proves no copy.
#[derive(EntityEvent, Clone, Debug)]
pub struct ScreenshotCopySelected { pub entity: Entity, pub selection: ScreenshotCopySelection }

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ScreenshotCopySkipReason {
    MissingOrZeroFrameSerial,
    ZeroRequestId,
    UnknownTarget,
    DuplicateTarget,
    MissingExtractedWindow,
    MissingSwapChainFormat,
    MissingSwapChainView,
    MissingGpuImage,
    MissingManualTextureView,
    EmptyTarget,
    MissingPreparedState,
    PreparedExtentOrFormatChanged,
    DuplicateCopyAttempt,
    CopyNotEncoded,
    UnsupportedPixelFormat,
    ReadbackMapFailed,
}

#[derive(EntityEvent, Clone, Debug)]
pub struct ScreenshotCopySkipped {
    pub entity: Entity,
    pub request_id: u64,
    pub frame_serial: Option<u64>,
    pub target: Option<NormalizedRenderTarget>,
    pub reason: ScreenshotCopySkipReason,
}

/// Inserted on the same entity immediately before its stock ScreenshotCaptured callback.
/// The exact copy call returned and its buffer mapped into that same Image. No claim of
/// a successful material draw, actual display exposure, uniform bytes or native pixels.
#[derive(Component, Clone, Debug)]
pub struct ScreenshotCopyReceipt {
    pub selection: ScreenshotCopySelection,
    pub extent: Extent3d,
    pub texture_format: TextureFormat,
}

#[derive(Clone)]
pub(super) enum Outcome { Encoded(ScreenshotCopyReceipt), Skipped(ScreenshotCopySkipReason) }
#[derive(Resource, Default)]
pub(super) struct RenderOutcomes(pub Mutex<EntityHashMap<Outcome>>);
pub(super) type Context<'a> = Option<(&'a ScreenshotCopySelection, &'a RenderOutcomes)>;

pub(super) fn record(context: Context<'_>, outcome: Outcome) {
    if let Some((selection, outcomes)) = context {
        let mut rows = outcomes.0.lock().unwrap();
        let outcome = if rows.contains_key(&selection.entity) {
            Outcome::Skipped(ScreenshotCopySkipReason::DuplicateCopyAttempt)
        } else { outcome };
        rows.insert(selection.entity, outcome);
    }
}
pub(super) fn skip(context: Context<'_>, reason: ScreenshotCopySkipReason) {
    record(context, Outcome::Skipped(reason));
}
pub(super) fn skipped(selection: &ScreenshotCopySelection, reason: ScreenshotCopySkipReason) -> ScreenshotCopySkipped {
    ScreenshotCopySkipped { entity: selection.entity, request_id: selection.request_id,
        frame_serial: Some(selection.frame_serial), target: Some(selection.target.clone()), reason }
}

#[derive(Debug)]
pub(super) enum Delivery {
    Copied { receipt: ScreenshotCopyReceipt, image: Image },
    Skipped(ScreenshotCopySkipped),
}
#[derive(Resource)]
pub(super) struct AuditedSender(pub Sender<Delivery>);
#[derive(Resource)]
pub(super) struct AuditedCaptured(pub Mutex<Receiver<Delivery>>);
pub(super) fn send_skip(sender: &AuditedSender, event: ScreenshotCopySkipped) {
    if let Err(error) = sender.0.send(Delivery::Skipped(event)) { error!("Screenshot copy witness delivery failed: {error}"); }
}

/// Existing public trigger_screenshots and CapturedScreenshots<(Entity,Image)> stay intact.
pub(super) fn trigger(mut commands: Commands, captured: Res<AuditedCaptured>) {
    while let Ok(delivery) = captured.0.lock().unwrap().try_recv() {
        match delivery {
            Delivery::Copied { receipt, image } => {
                let entity = receipt.selection.entity;
                // Deferred command order guarantees receipt insertion before the stock event.
                commands.entity(entity).insert((Captured, receipt));
                commands.trigger(ScreenshotCaptured { entity, image });
            }
            Delivery::Skipped(event) => {
                commands.entity(event.entity).insert(Captured);
                commands.trigger(event);
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn selection() -> ScreenshotCopySelection {
        let mut world = World::new(); let entity = world.spawn_empty().id();
        ScreenshotCopySelection { entity, request_id: 7, frame_serial: 19,
            target: Screenshot::window(entity).0.normalize(Some(entity)).unwrap() }
    }
    #[test]
    fn screenshot_copy_record_is_one_shot_and_duplicate_never_becomes_encoded() {
        let key = selection(); let rows = RenderOutcomes::default();
        record(Some((&key, &rows)), Outcome::Encoded(ScreenshotCopyReceipt { selection: key.clone(),
            extent: Extent3d { width: 1280, height: 800, depth_or_array_layers: 1 }, texture_format: TextureFormat::Rgba8Unorm }));
        assert!(matches!(rows.0.lock().unwrap().get(&key.entity), Some(Outcome::Encoded(_))));
        skip(Some((&key, &rows)), ScreenshotCopySkipReason::MissingPreparedState);
        assert!(matches!(rows.0.lock().unwrap().get(&key.entity), Some(Outcome::Skipped(ScreenshotCopySkipReason::DuplicateCopyAttempt))));
    }
    #[test]
    fn screenshot_copy_disabled_context_creates_no_outcome() {
        let rows = RenderOutcomes::default(); skip(None, ScreenshotCopySkipReason::CopyNotEncoded);
        assert!(rows.0.lock().unwrap().is_empty());
    }
    #[test]
    fn screenshot_copy_skip_preserves_request_entity_serial_and_normalized_target() {
        let key = selection(); let event = skipped(&key, ScreenshotCopySkipReason::MissingSwapChainView);
        assert_eq!(event.entity, key.entity); assert_eq!(event.request_id, 7);
        assert_eq!(event.frame_serial, Some(19)); assert_eq!(event.target.as_ref(), Some(&key.target));
        assert_eq!(event.reason, ScreenshotCopySkipReason::MissingSwapChainView);
    }
    #[test]
    fn screenshot_copy_private_delivery_carries_same_owned_image_and_receipt() {
        let key = selection(); let receipt = ScreenshotCopyReceipt { selection: key.clone(),
            extent: Extent3d { width: 1, height: 1, depth_or_array_layers: 1 }, texture_format: TextureFormat::Rgba8Unorm };
        let mut image = Image::default(); image.data = Some(vec![1, 2, 3, 4]);
        let (tx, rx) = std::sync::mpsc::channel(); tx.send(Delivery::Copied { receipt, image }).unwrap();
        match rx.recv().unwrap() {
            Delivery::Copied { receipt, image } => { assert_eq!(receipt.selection, key); assert_eq!(image.data, Some(vec![1, 2, 3, 4])); }
            Delivery::Skipped(_) => panic!("copied fixture became skipped"),
        }
    }
}
