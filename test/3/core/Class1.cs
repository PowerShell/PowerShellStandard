// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System;
using System.Management.Automation;

namespace PSStandard
{
    [Cmdlet("get","thing")]
    public class Class1 : PSCmdlet
    {
        [Parameter()]
        [Credential()]
        public PSCredential Credential { get; set; }

        protected override void EndProcessing() {
            WriteObject("Success!");
        }
    }
}
