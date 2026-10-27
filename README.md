# EndsMeet

EndsMeet is a **B4X library for use in B4J applications**, built on `jServer`. It provides helpers for HTTP route registration, configuration loading, static-file settings, and optional SSL/HTTPS and CORS filters. Your B4J project remains the application: you write its handlers, business logic, and user interface, and use EndsMeet as a library within it. EndsMeet is not a full-stack web framework or a ready-to-run server product.

## Requirements

- [B4J](https://www.b4x.com/b4j.html)
- The `EndsMeet.b4xlib` library in your B4J `Additional Libraries` folder
- The B4J libraries referenced by the project/library manifest: `JavaObject` and `jServer`

## Install

Download `release/EndsMeet.b4xlib` from this repository and copy it into your B4J Additional Libraries folder. In the IDE, enable the **EndsMeet** library for your project. The library includes custom server-filter templates for CORS and HTTPS; use those templates when adding the filters to a project.

## Quick start

In your B4J application, create an `EndsMeet` instance, load configuration, register your handler classes, then start the server:

```basic
Sub Process_Globals
    Public App As EndsMeet
End Sub

Sub AppStart (Args() As String)
    App.Initialize
    App.LoadConfig
    App.LoadDotEnv

    App.Get("", "HomeHandler")
    App.Post("/api/items", "ItemsHandler")
    App.Rest("/api/items/*", "ItemsHandler")

    App.Start
    Log(App.StartupMessage)
    Log("Server URL: " & App.ServerUrl)
    StartMessageLoop
End Sub
```

Replace `HomeHandler` and `ItemsHandler` with your B4J handler class names. A handler class implements a `Handle` sub that receives the servlet request and response:

```basic
Sub Class_Globals
End Sub

Public Sub Initialize
End Sub

Sub Handle (req As ServletRequest, resp As ServletResponse)
    resp.ContentType = "text/plain"
    resp.Write("Hello from EndsMeet")
End Sub
```

`Get`, `Post`, `Put`, `Patch`, and `Delete` register one HTTP method. `Rest` registers GET, POST, PUT, PATCH, and DELETE for the path. `Route(Path, Class, Methods)` registers the methods in the supplied list. EndsMeet adds the handler to the server once and tracks registered methods in `App.routes`.

## Configuration

### `config.ini`

`App.LoadConfig` reads `config.ini` from `File.DirApp`. If it does not exist, EndsMeet copies `config.example` from the project Files directory to that location. The example file includes these settings:

| Key | Purpose |
| --- | --- |
| `PORT` | HTTP server port (default example: `8080`) |
| `ROOT_URL` | Public root URL used to build `App.ServerUrl` |
| `ROOT_PATH` | Optional path prefix appended to the server URL |
| `HIDE_PORT` | Set to `True` to omit a nonstandard port from `App.ServerUrl` |
| `API_NAME` | API name setting |
| `API_VERSIONING` | API versioning setting |
| `API_VERBOSE_MODE` | API verbose-mode setting |

You can also set server/API options directly in code, for example `App.Port = 8080`, `App.RootUrl = "https://example.com"`, or `App.api.Name = "api"`.

### `.env`

`App.LoadDotEnv` reads `.env` from the B4J Files/assets directory (`File.DirAssets`). Add the file to your project Files so it is available to the application. SSL and SMTP options supported by the loader are:

```dotenv
SSL_ENABLED=False
SSL_PORT=443
SSL_KEYSTORE_DIR=
SSL_KEYSTORE_FILE=
SSL_KEYSTORE_PASSWORD=

SMTP_ENABLED=False
SMTP_USESSL=True
SMTP_PORT=465
SMTP_SERVER=smtp.example.com
SMTP_USERNAME=
SMTP_PASSWORD=
```

Keep real credentials out of source control. When configuring SSL, provide a valid keystore file and password. SSL is disabled unless `SSL_ENABLED=True` and the keystore is found. Configuration can also be assigned directly through `App.ssl` and `App.smtp`.

## HTTPS / SSL

HTTPS is optional. Configure SSL before `App.Start`:

```basic
App.ssl.Enabled = True
App.ssl.Port = "443"
App.ssl.KeystoreDir = File.DirApp
App.ssl.KeystoreFile = "server.keystore"
App.ssl.KeystorePassword = "your-keystore-password"
App.ssl.ShowLog = True
```

When SSL is enabled and the keystore is valid, EndsMeet configures the HTTPS connector and adds the `HttpsFilter` to redirect HTTP requests to HTTPS. To change filter threading, set `App.ssl.SingleThread`. The server URL uses HTTPS and includes the SSL port unless it is 443 or `App.HidePort` is enabled.

## CORS

Enable the CORS filter and provide the response header values your client needs:

```basic
App.cors.Enabled = True
App.cors.AllowedOrigin = "https://client.example.com"
App.cors.AllowedMethods = "GET, POST, PUT, PATCH, DELETE, OPTIONS"
App.cors.AllowedHeaders = "Content-Type, Authorization"
```

The filter applies these values to responses and answers `OPTIONS` preflight requests with status 200. Set `App.cors.SingleThread` if the filter should run as a single-thread filter. CORS is disabled by default.

## Static files

Set the directory to serve as static assets before starting the server:

```basic
App.AssetsFolder = File.Combine(File.DirApp, "www")
App.AssetsFolderBrowsable = False
```

Directory browsing is off by default. `App.staticfiles.Options` can also be assigned a map of `jServer` static-file options.

## Useful APIs

- `App.ServerUrl`, `App.RootUrl`, `App.RootPath`, and `App.Port` expose server address settings.
- `App.MethodAvailable(Method, Path, Class)` checks whether a method/path/handler combination was registered. `MethodAvailable2` accepts a handler object instead of its class name.
- `App.WriteHtml(Response, Content)` writes an HTML response. `WriteHtml2(Response, Content, Context)` also substitutes `$KEY$` placeholders from a map; `$H_KEY$` values are HTML-escaped.
- `App.ctx` is the configuration/context map. At startup, EndsMeet stores `ROOT_URL`, `ROOT_PATH`, and `SERVER_URL` in it. Set `App.RemoveUnusedConfig = False` if you want loaded port/API keys retained in the map.
- `App.api` holds API options (`Name`, `Versioning`, `PayloadType`, `ContentType`, `EnableHelp`, and `VerboseMode`).
- `App.smtp` holds SMTP settings. It exposes configuration values; use an email library/service to send mail.

For changes between releases, see [CHANGELOG.md](CHANGELOG.md). The source project is under [`source/`](source/), and the packaged library is under [`release/`](release/).

## License

EndsMeet is released under the [MIT License](LICENSE).
