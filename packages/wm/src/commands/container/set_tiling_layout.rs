use anyhow::Context;
use wm_common::TilingLayout;

use crate::{models::Container, traits::CommonGetters};

/// Sets the automated layout policy for the subject container's workspace.
///
/// Activating BSP affects future tiling-window insertions. Existing
/// windows retain their current arrangement.
pub fn set_tiling_layout(
  container: Container,
  layout: TilingLayout,
) -> anyhow::Result<()> {
  let workspace = container.workspace().context("No workspace.")?;
  workspace.set_tiling_layout(layout);

  Ok(())
}
