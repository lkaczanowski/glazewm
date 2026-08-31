use anyhow::Context;
use wm_common::TilingDirection;

use super::wrap_in_split_container;
use crate::{
  models::{Container, SplitContainer, Workspace},
  traits::{CommonGetters, PositionGetters},
  user_config::UserConfig,
};

/// Creates a binary split around the most recently focused tiling window
/// and returns the position where a new window should be inserted.
pub fn bsp_insertion_target(
  workspace: &Workspace,
  config: &UserConfig,
) -> anyhow::Result<(Container, usize)> {
  let Some(target) = workspace
    .descendant_focus_order()
    .find_map(|container| container.as_tiling_window().cloned())
  else {
    return Ok((workspace.clone().into(), workspace.child_count()));
  };

  let target_parent =
    target.parent().context("Tiling window has no parent.")?;
  let target_rect = target.to_rect()?;

  // Split along the longest side so each successive insertion continues
  // partitioning the available space rather than a single row or column.
  let direction = if target_rect.width() >= target_rect.height() {
    TilingDirection::Horizontal
  } else {
    TilingDirection::Vertical
  };

  let split =
    SplitContainer::new_bsp(direction, config.value.gaps.clone());
  wrap_in_split_container(
    &split,
    &target_parent,
    &[target.as_tiling_container()?],
  )?;

  Ok((split.into(), 1))
}
