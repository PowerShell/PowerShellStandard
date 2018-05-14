using System;
using System.Management.Automation;
using System.Management.Automation.Runspaces;

namespace Microsoft.PowerShell.Standard.Module.Template
{
    [Cmdlet("Test","SampleCmdlet")]
    [OutputType("TestObject")]
    public class TestSampleCmdletCommand : PSCmdlet
    {
        [Parameter(
            Mandatory=true,
            Position = 0,
            ValueFromPipeline = true,
            ValueFromPipelineByPropertyName = true)]
        public int FavoriteNumber { get; set; }

        [Parameter(
            Position = 1,
            ValueFromPipelineByPropertyName = true)]
        [ValidateSet("Cat", "Dog", "Horse")]
        public string FavoritePet { get; set; } = "Dog";

        protected override void BeginProcessing()
        {
            WriteVerbose("Begin!");
        }

        protected override void ProcessRecord()
        {
            WriteObject(new TestObject { 
                FavoriteNumber = FavoriteNumber,
                FavoritePet = FavoritePet
            });
        }

        protected override void EndProcessing()
        {
            WriteVerbose("End!");
        }
    }

    public class TestObject
    {
        public int FavoriteNumber { get; set; }
        public string FavoritePet { get; set; }
    }
}
