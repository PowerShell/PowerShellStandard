using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;

namespace PSStandard
{
    [Cmdlet("get","thing")]
    public class Class1 : PSCmdlet
    {
        [Parameter()]
        [Credential()]
        public PSCredential Credential { get; set; }

        [Parameter()]
        [ValidateSet("a","b","c")]
        public string p1 { get; set; }

        protected override void BeginProcessing() {
            WriteVerbose(Runspace.DefaultRunspace.Name);
            PSObject p = new PSObject(DateTime.Now);
            WriteVerbose(p.Properties["DateTime"].ToString());
        }
        protected override void EndProcessing() {
            WriteObject("Success!");
        }
    }
}
