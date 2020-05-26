<#
 .Synopsis
 Erstellen eines Webservice-Cmdlets - Teil 1 - Rückgabe sind Objects (nicht ganz optimal)
#>

$CSCode = @'
using System;
using System.Collections.ObjectModel;
using System.Management.Automation;
using Microsoft.PowerShell.Commands;
using System.Management.Automation.Runspaces;
using System.Management;

[Cmdlet(VerbsCommon.Get,"Nanolex")]
public class NanolexCmdlet : PSCmdlet
{
    private string uriNanolex = "http://nanolex.azurewebsites.net/api/lexikon";

    protected override void ProcessRecord()
    {
        Runspace runspace = RunspaceFactory.CreateRunspace();
        runspace.Open();
        Pipeline pipeline = runspace.CreatePipeline();
        Command invokeWebRequest = new Command("Invoke-WebRequest");
        invokeWebRequest.Parameters.Add("Uri", uriNanolex);
        pipeline.Commands.Add(invokeWebRequest);
        try
        {
            Collection<PSObject> returnObjects = pipeline.Invoke();
            foreach(PSObject returnObj in returnObjects)
            {
                string jsonContent = (returnObj.ImmediateBaseObject as HtmlWebResponseObject).Content;
                // WriteObject(((HtmlWebResponseObject)response).Content);
                // Konvertierung des Json-Text in ein Objekt über eine weitere Pipeline
                Pipeline pipeline2 = runspace.CreatePipeline();
                Command convertJson = new Command("ConvertFrom-Json");
                convertJson.Parameters.Add("InputObject", jsonContent);
                pipeline2.Commands.Add(convertJson);
                Collection<PSObject> returnObjects2 = pipeline2.Invoke();
                foreach(PSObject returnObj2 in returnObjects2)
                {
                    WriteObject(returnObj2);
                }
            }
        }
        catch (SystemException ex)
        {
            ErrorRecord er = new ErrorRecord(ex, "Aufruf von Nanolex", ErrorCategory.InvalidOperation, null);
            WriteError(er);
        }
    }
}

'@

Add-Type -TypeDefinition $CSCode -ReferencedAssemblies System.Management.Automation,Microsoft.PowerShell.Commands.Utility -OutputAssembly Nanolex8.dll -OutputType Library