cask "twindesk" do
  arch arm: "arm64", intel: "x64_Intel"

  version "2.4.0"
  sha256 arm:   "093376687935351306df27de10e77c7ec7a517c2a3394e23178e90cf5c12a9ed",
         intel: "2c0f8719bc2b1ee7c2a27578f67c5cd7a151437352f908223113fffe96f1e783"

  url "https://github.com/InukaAsith/TwinDesk/releases/download/v#{version}/TwinDesk-#{version}-#{arch}.dmg"
  name "TwinDesk"
  desc "Share mouse, keyboard, clipboard, files and screens with computers and phones"
  homepage "https://github.com/InukaAsith/TwinDesk"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "TwinDesk.app"

  # The app isn't notarized: without the quarantine flag macOS opens it instead of calling it damaged.
  # A Mac driven only through TwinDesk loses its mouse and keyboard while the app is quit for an
  # upgrade: the installed version notes that it was running, and the new one is opened once in place.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/TwinDesk.app"], must_succeed: false
    if_path_exists "twindesk-relaunch", base: :temp do
      run "/usr/bin/open", args: ["{{appdir}}/TwinDesk.app"], must_succeed: false
      remove "twindesk-relaunch", base: :temp
    end
  end

  uninstall_preflight_steps do
    run "/bin/sh",
        args:         ["-c", "/usr/bin/pgrep -qx TwinDesk && /usr/bin/touch {{temp}}/twindesk-relaunch"],
        must_succeed: false
  end

  uninstall quit: "org.macshare.mac"

  zap trash: [
    "~/Applications/MacShare Apps",
    "~/Library/Application Scripts/org.macshare.mac.share",
    "~/Library/Application Support/MacShare",
    "~/Library/Containers/org.macshare.mac.share",
    "~/Library/Logs/TwinDesk",
    "~/Library/Preferences/org.macshare.mac.plist",
    "~/Library/Saved Application State/org.macshare.mac.savedState",
  ]
end
