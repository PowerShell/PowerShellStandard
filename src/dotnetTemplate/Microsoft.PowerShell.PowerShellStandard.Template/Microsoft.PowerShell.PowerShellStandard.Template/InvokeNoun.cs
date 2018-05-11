using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;

namespace Microsoft.PowerShell.PowerShellStandard.Template
{
    [Cmdlet("Invoke","Noun")]
    public class InvokeNoun : PSCmdlet
    {
        [Parameter(
            Mandatory=true,
            Position = 0,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        public string Value { get; set; }

        [Parameter()]
        [ValidateSet("Output", "Verbose", "Debug")]
        [Alias(("To"))]
        public string WriteTo { get; set; } = "Output";

        protected override void BeginProcessing()
        {
            WriteObject("Begin!");
        }

        protected override void ProcessRecord()
        {
            switch (WriteTo)
            {
                case "Output":
                    WriteObject(Value);
                    break;
                case "Verbose":
                    WriteVerbose(Value);
                    break;
                case "Error":
                    WriteDebug(Value);
                    break;
                default:
                    break;
            }
        }

        protected override void EndProcessing()
        {
            WriteObject("End!");
        }
    }
}