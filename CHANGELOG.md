# Changelog

Changes are listed for EndsMeet **4.02** relative to **3.30**. The repository has a `v3.30` tag, but no `v4.02` tag; 4.02 refers to the version declared by the current source and manifest.

## 4.02

### Added
- Reorganized API, CORS, SMTP, SSL, and static-file configuration into dedicated settings classes (`ApiSettings`, `CorsSettings`, `SmtpSettings`, `SslSettings`, and `StaticFilesSettings`).
- Added a CORS filter that sets configurable allowed-origin, allowed-method, and allowed-header response headers and terminates `OPTIONS` preflight requests.
- Added optional single-thread settings for CORS/HTTPS filters and an SSL logging control.
- Added B4J custom class templates for the CORS and HTTPS server filters.
- Expanded `LoadDotEnv` to apply SSL and SMTP settings, including ports, enabled flags, keystore details, and SMTP credentials (dotenv loading itself was already present in 3.30).
- Added `AssetsFolder` and `AssetsFolderBrowsable` properties for static asset configuration.
- Added `HidePort` to control whether nonstandard ports appear in `ServerUrl`.
- Added `StartupMessage` property; startup now builds a default status message and populates `SERVER_URL` in the context.

### Changed
- SSL and HTTP-to-HTTPS redirect behavior is configured through `ssl.Enabled`; HTTPS filtering is registered when SSL is enabled.
- CORS configuration now uses one application-wide filter and explicit allowed-origin/method/header values rather than per-path filter settings.
- Configuration loading is separated: `LoadConfig` reads server/API options from `config.ini`, while `LoadDotEnv` applies SSL/SMTP options from `.env`.
- Static asset folder and browsing options are set through the new static-file settings properties.
- `manifest.txt` now registers the CORS and HTTPS custom class templates.
- The example project and B4X library packaging were updated to include the settings classes and filter templates.

### Compatibility notes
- `App.email` is replaced by `App.smtp` (`SmtpSettings`).
- Static-file properties moved from `App.staticfiles.Folder/Browsable/Options` to `App.AssetsFolder`, `App.AssetsFolderBrowsable`, and `App.staticfiles.Options`.
- The former `AppendPort`, `LogEnabled`, `RedirectToHttps`, `Message`, and `LogStartupMessage` APIs are replaced or removed; use `HidePort`, per-feature `ShowLog`, `ssl.Enabled`, and `StartupMessage` as applicable.
- CORS settings changed from per-path `Path`/`Settings` maps to `Enabled`, `SingleThread`, `AllowedOrigin`, `AllowedMethods`, and `AllowedHeaders`.
- SSL/SMTP settings are no longer loaded from `config.ini`; configure them in `.env` or directly through their settings objects.

### Removed
- Removed the old `EmailSettings` class in favor of `SmtpSettings`.
- Removed `REDIRECT_TO_HTTPS` from the example config; use SSL settings to enable HTTPS redirection.
