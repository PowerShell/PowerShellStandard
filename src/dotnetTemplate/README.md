# PowerShell Standard based C# module template

A `dotnet new` template that creates an example PowerShell C# module that uses PowerShellStandard.

```powershell
dotnet new psmodule
```

## Installation

To use the template, you must first install it so that it is recognized in `dotnet new`.

### From nuget.org

```powershell
dotnet new -i Microsoft.PowerShell.Standard.Module.Template
```

Now checkout the [usage](#usage).

### From source

1. Clone the repo.
2. Install the template:

```powershell
dotnet new -i ./src/dotnetTemplate/Microsoft.PowerShell.Standard.Module.Template/Microsoft.PowerShell.Standard.Module.Template
```

Now checkout the [usage](#usage).

## Usage

Once the template is installed, you will see it in your template list:

```text
PS> dotnet new -l

Usage: new [options]

Options:
  -h, --help          Displays help for this command.
  -l, --list          Lists templates containing the specified name. If no name is specified, lists all templates.
  -n, --name          The name for the output being created. If no name is specified, the name of the current directory is used.
  -o, --output        Location to place the generated output.
  -i, --install       Installs a source or a template pack.
  -u, --uninstall     Uninstalls a source or a template pack.
  --type              Filters templates based on available types. Predefined values are "project", "item" or "other".
  --force             Forces content to be generated even if it would change existing files.
  -lang, --language   Specifies the language of the template to create.


Templates                                         Short Name       Language          Tags
---------------------------------------------------------------------------------------------------------------------
Console Application                               console          [C#], F#, VB      Common/Console
PowerShell Standard Module                        psmodule         [C#]              Common/Console/PowerShell/Module
Class library                                     classlib         [C#], F#, VB      Common/Library
Unit Test Project                                 mstest           [C#], F#, VB      Test/MSTest
xUnit Test Project                                xunit            [C#], F#, VB      Test/xUnit
ASP.NET Core Empty                                web              [C#], F#          Web/Empty
ASP.NET Core Web App (Model-View-Controller)      mvc              [C#], F#          Web/MVC
ASP.NET Core Web App                              razor            [C#]              Web/MVC/Razor Pages
ASP.NET Core with Angular                         angular          [C#]              Web/MVC/SPA
ASP.NET Core with React.js                        react            [C#]              Web/MVC/SPA
ASP.NET Core with React.js and Redux              reactredux       [C#]              Web/MVC/SPA
ASP.NET Core Web API                              webapi           [C#], F#          Web/WebAPI
global.json file                                  globaljson                         Config
NuGet Config                                      nugetconfig                        Config
Web Config                                        webconfig                          Config
Solution File                                     sln                                Solution
Razor Page                                        page                               Web/ASP.NET
MVC ViewImports                                   viewimports                        Web/ASP.NET
MVC ViewStart                                     viewstart                          Web/ASP.NET
```

To get more details, add the `-h` flag:

```text
PS > dotnet new psmodule -h
Usage: new [options]

Options:
  -h, --help          Displays help for this command.
  -l, --list          Lists templates containing the specified name. If no name is specified, lists all templates.
  -n, --name          The name for the output being created. If no name is specified, the name of the current directory is used.
  -o, --output        Location to place the generated output.
  -i, --install       Installs a source or a template pack.
  -u, --uninstall     Uninstalls a source or a template pack.
  --type              Filters templates based on available types. Predefined values are "project", "item" or "other".
  --force             Forces content to be generated even if it would change existing files.
  -lang, --language   Specifies the language of the template to create.


PowerShell Standard Module (C#)
Author: Microsoft Corporation
Options:
  -v|--powershell-standard-version
                                        7.0.0-preview.1     - PowerShell Standard 7.0.0-preview.1
                                        3.0.0-preview-02    - PowerShell Standard 3.0
                                    Default: 7.0.0-preview.1

  --no-restore                      If specified, skips the automatic restore of the project on create.
                                    bool - Optional
                                    Default: false
```

To create a template using the defaults:

```text
> dotnet new psmodule
The template "PowerShell Standard Module" was created successfully.

Processing post-creation actions...
Running 'dotnet restore' on /Users/tylerleonhardt/Downloads/MyProject/MyProject.csproj...
  Restoring packages for /Users/tylerleonhardt/Downloads/MyProject/MyProject.csproj...
  Generating MSBuild file /Users/tylerleonhardt/Downloads/MyProject/obj/MyProject.csproj.nuget.g.props.
  Generating MSBuild file /Users/tylerleonhardt/Downloads/MyProject/obj/MyProject.csproj.nuget.g.targets.
  Restore completed in 275.57 ms for /Users/tylerleonhardt/Downloads/MyProject/MyProject.csproj.

Restore succeeded.
```

Notice that it restores automatically.

You can optionally specify PowerShell Standard V3 by running:

```text
dotnet new psmodule --powershell-standard-version 3.0.0-preview-02
```

This template will create:

* `*.csproj` - a project file that uses the same name as the folder it was created in
* `TestSampleCmdletCommand.cs` - an example PowerShell cmdlet class
* `obj` - a folder generated by the restore
