cask "displaykeep" do
  version "1.3"
  sha256 "584830ab33b7dcea3b8df86c802eea235673d2ba8ee5478e691913d371dab800"

  url "https://github.com/tangentyh/displaykeep/releases/download/v#{version}/displaykeep-#{version}.zip"
  name "DisplayKeep"
  desc "Keeps the display awake while another process holds a sleep assertion"
  homepage "https://github.com/tangentyh/displaykeep"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "DisplayKeep.app"
  binary "#{appdir}/DisplayKeep.app/Contents/MacOS/displaykeep"

  # The release zip is ad-hoc signed (codesign -s -) and so cannot be notarized:
  # left alone, the app lands quarantined and macOS refuses its first launch (and
  # SIGKILLs the CLI, which lives inside the bundle). Official taps require
  # notarization instead of this; a personal tap has to clear it or ship
  # something nobody can run. The caveats say so rather than leaving it silent.
  # Paths in a steps block are relative to the staged directory.
  preflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "."], chdir: "."
  end

  uninstall quit: "com.tangentyh.displaykeep"

  zap trash: [
    "~/Library/Application Support/displaykeep",
    "~/Library/LaunchAgents/com.tangentyh.displaykeep.plist",
    "~/Library/Logs/displaykeep.log",
    "~/Library/Preferences/com.tangentyh.displaykeep.plist",
    "~/Library/Saved Application State/com.tangentyh.displaykeep.savedState",
  ]

  caveats <<~EOS
    DisplayKeep is menu bar only: no Dock icon, no windows. Turn on "Start at
    login" from its menu to register it as a login item.

    The app is ad-hoc signed and not notarized by Apple, so this tap clears the
    quarantine flag itself instead of leaving you the "Apple could not verify"
    dialog. That skips a Gatekeeper check Homebrew normally relies on: it is fine
    for a personal tap of your own software, not a habit to carry elsewhere.

    The command line interface is in the bundle, linked as `displaykeep`:
      displaykeep status     # exit 0 holding, 1 armed, 2 paused, 3 dead, 4 failed
      displaykeep pause 30
      displaykeep resume
      displaykeep login on

    The launchd agent that `make install` (source installs) sets up is not a cask
    artifact: turn it down with `make uninstall` before switching to this cask, or
    the app's "Start at login" switch shows it as managed and defers to it.
  EOS
end
