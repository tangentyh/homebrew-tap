cask "clashx-meta" do
  version "1.4.48"
  sha256 "53b8384423507aa305d9411dc2643c0e5ef02da442ff97d307602341301eca12"

  url "https://github.com/MetaCubeX/ClashX.Meta/releases/download/v#{version}/ClashX.Meta.zip"
  name "ClashX Meta"
  desc "Rule-based proxy client with a menu bar interface"
  homepage "https://github.com/MetaCubeX/ClashX.Meta"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "ClashX Meta.app"

  uninstall launchctl: "com.metacubex.ClashX.ProxyConfigHelper.meta",
            quit:      "com.metacubex.ClashX.meta",
            delete:    [
              "/Library/LaunchDaemons/com.metacubex.ClashX.ProxyConfigHelper.meta.plist",
              "/Library/PrivilegedHelperTools/com.metacubex.ClashX.ProxyConfigHelper.meta",
            ]

  zap trash: [
    "~/.config/clash.meta",
    "~/Library/Application Support/com.metacubex.ClashX.meta",
    "~/Library/Caches/com.MetaCubeX.ClashX.meta",
    "~/Library/Preferences/com.metacubex.ClashX.meta.plist",
    "~/Library/Saved Application State/com.metacubex.ClashX.meta.savedState",
  ]

  caveats <<~EOS
    ClashX Meta is ad-hoc signed and not notarized by Apple, so Gatekeeper will
    block it on first launch. Allow it under
    System Settings > Privacy & Security > "Open Anyway",
    or run: xattr -dr com.apple.quarantine "#{appdir}/ClashX Meta.app"

    On first launch the app asks for an administrator password to install its
    privileged helper (com.metacubex.ClashX.ProxyConfigHelper.meta), which is
    required for the TUN mode and system proxy settings.
  EOS
end
