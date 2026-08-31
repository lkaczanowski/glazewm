use clap::ValueEnum;
use serde::{Deserialize, Serialize};

/// Automated layout policy for a workspace.
#[derive(
  Clone,
  Copy,
  Debug,
  Default,
  Deserialize,
  Eq,
  PartialEq,
  Serialize,
  ValueEnum,
)]
#[clap(rename_all = "snake_case")]
#[serde(rename_all = "snake_case")]
pub enum TilingLayout {
  #[default]
  None,
  Bsp,
}
