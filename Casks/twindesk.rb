cask "twindesk" do
  arch arm: "arm64", intel: "x64_Intel"

  version "2.5.2"
  sha256 arm:   "4be92b4380acf96be1973517ce0204994b17a18763c49aaa6057ce67a5a5c36b",
         intel: "9e94453ded650a7082a2def1773ea7bb6d5363043a8cb96c17d74029893b8d25"

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
  # The release is signed with TwinDesk's own certificate (permissions carry across updates); if that
  # signature doesn't hold on this Mac, it's signed here (ad-hoc), as Apple Silicon runs only signed code.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/TwinDesk.app"], must_succeed: false
    run "/bin/sh",
        args:         ["-c", "/usr/bin/codesign --verify --deep --strict \"$0\" 2>/dev/null || " \
                             "/usr/bin/codesign --force --deep --sign - \"$0\"", "{{appdir}}/TwinDesk.app"],
        must_succeed: false
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
