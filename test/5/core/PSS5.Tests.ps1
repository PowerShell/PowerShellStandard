Describe 'PowerShell Standard 5' {

    BeforeAll {
        $repoRoot = git rev-parse --show-toplevel
        $libraryPath = "${repoRoot}/src/5/bin/Release/netstandard2.0/System.Management.Automation.dll"
        $assemblyExists = test-path $libraryPath
        if ( $assemblyExists ) {
            $standardAssembly = [System.Reflection.Assembly]::LoadFile($libraryPath)
        }
    }

    Context 'Creating a cmdlet' {
        BeforeAll {
            $cmdletAssembly = 'bin/Release/netstandard2.0/Demo.Cmdlet.dll'
            $assemblyPath = Join-Path "$PSScriptRoot" $cmdletAssembly
            $PSBin = (Get-Process -id $PID).MainModule.FileName
        }
        It 'Can build a reference assembly' {
            try {
                Push-Location $PSScriptRoot
                dotnet restore
                dotnet build --configuration Release
                $assemblyPath | Should -Exist
            }
            finally {
                Pop-Location
            }
        }
        It 'Can execute the compiled cmdlet' {
            $result = & $PSBin -c "import-module $assemblyPath; Get-Thing"
            $result | Should -Be 'success!'
        }
    }

    Context 'Reflection tests' {

        $testCases = @{
            Name = "Issue 52: ValidateArgumentsAttribute.Validate method is not abstract"
            ScriptBlock  = {
                $t = $standardAssembly.GetType('System.Management.Automation.ValidateArgumentsAttribute')
                $m = $t.GetMember('Validate','Public,NonPublic,Instance,Static,DeclaredOnly')
                $m.IsAbstract |Should -Be $true
                }
        },
        @{
            Name = "Issue 50: PSEventUnsubscribedEventHander argument type should be PSEventUnsubscribedEventArgs"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.PSEventUnsubscribedEventHandler')
                $m = $t.GetMethod('Invoke')
                $parameters = $m.GetParameters()
                $parameters[1].ParameterType.FullName | Should -Be 'System.Management.Automation.PSEventUnsubscribedEventArgs'
            }
        },
        @{
            Name = "Issue 44: FunctionMemberAst.Parameters should be accessible"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.Language.FunctionMemberAst')
                $p = $t.GetProperty('Parameters')
                $p.GetMethod.IsPublic | Should -Be $true
            }
        },
        @{
            Name = "Issue 42: Runspace.Default should not contain public CreateNestedPipeline"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.Runspaces.Runspace')
                $t.GetMembers('Public,NonPublic,Instance,Static')|?{$_.Name -match 'CreatedNestedPipeline'}|Should -BeNullOrEmpty
            }
        },
        @{
            Name = "Issue 36: PSMemberInfo.Copy is marked 'virtual' but should be 'abstract'"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.PSMemberInfo')
                $m = $t.GetMethod('Copy')
                $m.IsAbstract | Should -Be $true
            }
        },
        @{
            Name = "Issue 26: Several properties missing from CmdletProvider (also issue 14)"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.Provider.CmdletProvider')
                $t.GetProperty('CurrentPSTransaction') | Should -Not -BeNullOrEmpty
                $t.GetProperty('DynamicParameters',[Reflection.BindingFlags]'NonPublic,Instance') | Should -Not -BeNullOrEmpty
                $t.GetProperty('PSDriveInfo',[Reflection.BindingFlags]'NonPublic,Instance') | Should -Not -BeNullOrEmpty
                $t.GetProperty('ProviderInfo',[Reflection.BindingFlags]'NonPublic,Instance') | Should -Not -BeNullOrEmpty
            }
        },
        @{
            Name = "Issue 19: SetJobState missing from Job class"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.Job')
                $t.GetMethod('SetJobState',[System.Reflection.BindingFlags]'NonPublic,Instance') | Should -Not -BeNullOrEmpty
            }
        },
        @{
            Name = "Issue 18: Debugger does not contain protected parameterless constructor"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.Debugger')
                # no public constructors
                $t.GetConstructors().Count | Should -Be 0
                # one protected, parameterless constructor
                $constructor = $t.GetConstructors('NonPublic,Instance')
                @($constructor).Count | Should -Be 1
                $constructor.IsFamily | Should -Be $true
                $constructor.GetParameters().Count | Should -Be 0
            }
        },
        @{
            Name = "Issue 17: ScriptExtent does not inherit IScriptExtent"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.Language.ScriptExtent')
                $t.GetInterface('System.Management.Automation.Language.IScriptExtent')|Should -Not -BeNullOrEmpty
            }
        },
        @{
            Name = "Issue 16: ICustomAstVistor2 does not inherit ICustomAstVistor"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.Language.ICustomAstVisitor2')
                $t.GetInterface('System.Management.Automation.Language.ICustomAstVisitor')|Should -Not -BeNullOrEmpty
            }
        },
        @{
            Name = "Issue 11: Missing cmdletization types"
            ScriptBlock = {
                $typeList = 'Microsoft.PowerShell.Cmdletization.BehaviorOnNoMatch',
                    'Microsoft.PowerShell.Cmdletization.CmdletAdapter`1',
                    'Microsoft.PowerShell.Cmdletization.MethodInvocationInfo', 'Microsoft.PowerShell.Cmdletization.MethodParameter',
                    'Microsoft.PowerShell.Cmdletization.MethodParameterBindings',
                    'Microsoft.PowerShell.Cmdletization.QueryBuilder',
                    'Microsoft.PowerShell.Cmdletization.Xml.ConfirmImpact', 'Microsoft.PowerShell.Cmdletization.Xml.ItemsChoiceType'
                foreach ( $t in $typeList ) {
                    $standardAssembly.GetType($t) | Should -Not -BeNullOrEmpty
                }
            }
        },
        @{
            Name = "Issue  8: DefaultRunspace should be a static property"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.Runspaces.Runspace')
                $p = $t.GetProperty('DefaultRunspace',[System.Reflection.BindingFlags]'Public,Static')
                $p | Should -Not -BeNullOrEmpty
            }
        },
        @{
            Name = "Issue  7: params keyword is left out for array type parameters"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.OutputTypeAttribute')
                foreach ($c in $t.GetConstructors()) {
                    $c.GetParameters()[-1].CustomAttributes.AttributeType.FullName | Should -Be System.ParamArrayAttribute
                }
            }
        },
        @{
            Name = "Issue  6: PSObject.Properties is using int instead of string"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.PSObject')
                $p = $t.GetProperty('Properties')
                $p.PropertyType.GetMember('Item').GetIndexParameters().ParameterType.FullName | Should -Be 'System.String'
            }
        },
        @{
            Name = "Issue  4: CreatePipeline should not be available"
            ScriptBlock = {
                $t = $standardAssembly.GetType('System.Management.Automation.Runspaces.Runspace')
                $t.GetMembers('Public,NonPublic,Instance,Static')|?{$_.Name -match 'CreatePipeline'} | Should -BeNullOrEmpty
            }
        }

        It '<Name>' -testcases $testCases -skip:(! $assemblyExists) {
            param ( [string]$name, [scriptblock]$ScriptBlock )
            & ${ScriptBlock}
        }
    }

    Context 'The type list is expected' {
        BeforeAll {
            $smaT = [psobject].assembly.GetTypes()|?{$_.IsPublic}|Sort-Object FullName
            $asmT = $standardAssembly.GetTypes()|?{$_.IsPublic}|Sort-Object FullName
            # These are the types which we expect to not be in the standard library
            $expectedMissingTypes = @{ Name = 'Microsoft.PowerShell.ProcessCodeMethods' },
                @{ Name = 'Microsoft.PowerShell.DesiredStateConfiguration.ArgumentToConfigurationDataTransformationAttribute' },
                @{ Name = 'Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscRemoteOperationsClass' },
                @{ Name = 'Microsoft.PowerShell.DesiredStateConfiguration.Internal.DscClassCache' },
                @{ Name = 'Microsoft.PowerShell.Commands.GetExperimentalFeatureCommand' },
                @{ Name = 'Microsoft.PowerShell.Commands.PSPropertyExpressionResult' },
                @{ Name = 'Microsoft.PowerShell.Commands.PSPropertyExpression' },
                @{ Name = 'Microsoft.PowerShell.Commands.UpdateHelpScope' },
                @{ Name = 'Microsoft.PowerShell.CoreClr.Stubs.AuthenticationLevel' },
                @{ Name = 'Microsoft.PowerShell.CoreClr.Stubs.ImpersonationLevel' },
                @{ Name = 'System.Management.Automation.PowerShellAssemblyLoadContextInitializer' },
                @{ Name = 'System.Management.Automation.Platform' },
                @{ Name = 'System.Management.Automation.ValidateRangeKind' },
                @{ Name = 'System.Management.Automation.CachedValidValuesGeneratorBase' },
                @{ Name = 'System.Management.Automation.IValidateSetValuesGenerator' },
                @{ Name = 'System.Management.Automation.ArgumentCompletionsAttribute' },
                @{ Name = 'System.Management.Automation.GetSymmetricEncryptionKey' },
                @{ Name = 'System.Management.Automation.StartRunspaceDebugProcessingEventArgs' },
                @{ Name = 'System.Management.Automation.ProcessRunspaceDebugEndEventArgs' },
                @{ Name = 'System.Management.Automation.ExperimentalFeature' },
                @{ Name = 'System.Management.Automation.ExperimentAction' },
                @{ Name = 'System.Management.Automation.ExperimentalAttribute' },
                @{ Name = 'System.Management.Automation.PSSnapInSpecification' },
                @{ Name = 'System.Management.Automation.PSParseError' },
                @{ Name = 'System.Management.Automation.PSParser' },
                @{ Name = 'System.Management.Automation.PSToken' },
                @{ Name = 'System.Management.Automation.PSTokenType' },
                @{ Name = 'System.Management.Automation.TypeInferenceRuntimePermissions' },
                @{ Name = 'System.Management.Automation.PSVersionHashTable' },
                @{ Name = 'System.Management.Automation.SemanticVersion' },
                @{ Name = 'System.Management.Automation.LocationChangedEventArgs' },
                @{ Name = 'System.Management.Automation.WorkflowInfo' },
                @{ Name = 'System.Management.Automation.PSSnapInInfo' },
                @{ Name = 'System.Management.Automation.VerbInfo' },
                @{ Name = 'System.Management.Automation.Remoting.WSMan.WSManServerChannelEvents' },
                @{ Name = 'System.Management.Automation.Remoting.WSMan.ActiveSessionsChangedEventArgs' },
                @{ Name = 'System.Management.Automation.Runspaces.PipelineStateInfo' },
                @{ Name = 'System.Management.Automation.Runspaces.PipelineStateEventArgs' },
                @{ Name = 'System.Management.Automation.Runspaces.Pipeline' },
                @{ Name = 'System.Management.Automation.Runspaces.PowerShellProcessInstance' },
                @{ Name = 'System.Management.Automation.Runspaces.SSHConnectionInfo' },
                @{ Name = 'System.Management.Automation.Runspaces.VMConnectionInfo' },
                @{ Name = 'System.Management.Automation.Runspaces.PSSnapInException' },
                @{ Name = 'System.Management.Automation.Runspaces.PipelineReader`1' },
                @{ Name = 'System.Management.Automation.Runspaces.PipelineWriter' },
                @{ Name = 'System.Management.Automation.Tracing.EtwActivity' },
                @{ Name = 'System.Management.Automation.Tracing.PowerShellTraceTask' },
                @{ Name = 'System.Management.Automation.Tracing.PowerShellTraceKeywords' },
                @{ Name = 'System.Management.Automation.Tracing.Tracer' },
                @{ Name = 'System.Management.Automation.Tracing.PowerShellTraceSource' },
                @{ Name = 'System.Management.Automation.Tracing.PowerShellTraceSourceFactory' },
                @{ Name = 'System.Management.Automation.Internal.TransactionParameters' },
                # Removed in 7
                @{ Name = 'System.Management.Automation.JobDataAddedEventArgs' },
                @{ Name = 'System.Management.Automation.PSChildJobProxy' },
                @{ Name = 'System.Management.Automation.PSJobProxy' },
                @{ Name = 'System.Management.Automation.Runspaces.PSSessionType' }
            }

        It "There should be no types in standard which are not in the product" -skip:(! $assemblyExists) {
            Compare-Object -reference $smaT -difference $asmT | ?{$_.SideIndicator -eq '=>' } | Should -BeNullOrEmpty
        }

        It "<Name> should not be in the standard library" -skip:(! $assemblyExists) -testcase $expectedMissingTypes {
            param ( $Name )
            $Name | Should -BeIn @($expectedMissingTypes.Values)
        }
    }
}
