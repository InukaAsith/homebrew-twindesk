# Homebrew tap for TwinDesk

[TwinDesk](https://github.com/InukaAsith/TwinDesk) shares the mouse, keyboard, clipboard, files,
sound and screens of a Mac with a Windows PC, a Linux computer, another Mac or an Android phone.

```sh
brew install --cask inukaasith/twindesk/twindesk
```

Update with `brew upgrade --cask twindesk`. If TwinDesk is running, it is quit for the upgrade and
opened again afterwards, so a Mac you drive only through TwinDesk gets its mouse and keyboard back.
`brew uninstall --cask twindesk` removes the app; add `--zap` to remove its settings too.

The app isn't notarized by Apple: the cask removes the download's quarantine flag, so macOS opens it
instead of calling it damaged. macOS 13 Ventura or later, Apple Silicon or Intel.

The cask follows TwinDesk's releases on its own ([update.yml](.github/workflows/update.yml)).
Problems with the app go to [TwinDesk's issues](https://github.com/InukaAsith/TwinDesk/issues).
