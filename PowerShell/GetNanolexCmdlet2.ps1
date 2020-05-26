<#
 .Synopsis
 Erstellen eines Webservice-Cmdlets - Teil 2 - Rückgabe sind dieses Mal Objekte vom Typ Nanolex (etwas besser;)
#>

$CSCode = @'
using System;
using System.Collections.ObjectModel;
using System.Management.Automation;
using Microsoft.PowerShell.Commands;
using System.Management.Automation.Runspaces;

class Nanolex
{
    public int Id { get; set; }
    public string Topic { get; set; }
    public string Term { get; set; }
    public string Definition { get; set; }
}

[Cmdlet(VerbsCommon.Get, "Nanolex")]
public class NanolexCmdlet : PSCmdlet
{
    private string uriNanolex = "http://nanolex.azurewebsites.net/api/lexikon";

    protected override void ProcessRecord()
    {
        Runspace runspace = RunspaceFactory.CreateRunspace();
        runspace.Open();
        Pipeline pipeline1 = runspace.CreatePipeline();
        Command invokeWebRequest = new Command("Invoke-WebRequest");
        invokeWebRequest.Parameters.Add("Uri", uriNanolex);
        pipeline1.Commands.Add(invokeWebRequest);
        try
        {
            Collection<PSObject> returnObjects = pipeline1.Invoke();
            foreach (PSObject returnObj in returnObjects)
            {
                string jsonContent = (returnObj.BaseObject as HtmlWebResponseObject).Content;
                // WriteObject(((HtmlWebResponseObject)response).Content);
                // Der Json-Text muss leider "aufbereitet" werden - [ und ] sowie das , durch nichts ersetzen
                using (PowerShell powershell1 = PowerShell.Create())
                {
                    string scriptText = "'" + jsonContent + "' -replace '},','}§' -replace '\\]','' -replace '\\[','' -split '§'";
                    powershell1.AddScript(scriptText);
                    Collection<PSObject> returnObjects2 = powershell1.Invoke();
                    foreach (PSObject returnObj2 in returnObjects2)
                    {
                        if (returnObj2 != null)
                        {
                            jsonContent = returnObj2.ToString();
                            // Console.WriteLine(jsonContent);
                            // Konvertierung des Json-Text in ein Objekt über eine weitere Pipeline
                            Pipeline pipeline2 = runspace.CreatePipeline();
                            Command convertJson = new Command("ConvertFrom-Json");
                            convertJson.Parameters.Add("InputObject", jsonContent);
                            pipeline2.Commands.Add(convertJson);
                            try
                            {
                                Collection<PSObject> returnObjects3 = pipeline2.Invoke();
                                foreach (PSObject returnObj3 in returnObjects3)
                                {
                                    // Nanoflex-Objekt anlegen
                                    // WriteObject(returnObj3.Properties);
                                    WriteObject(new Nanolex { Id = (int)returnObj3.Properties["id"].Value,
                                                            Topic = returnObj3.Properties["topic"].Value.ToString(),
                                                            Term = returnObj3.Properties["term"].Value.ToString(),
                                                            Definition = returnObj3.Properties["definition"].Value.ToString()
                                                            });
                                }
                            }
                            catch (SystemException ex)
                            {
                                ErrorRecord er = new ErrorRecord(ex, "Json-Konvertierung nach dem Aufruf von Nanolex", ErrorCategory.InvalidOperation, null);
                                WriteError(er);
                            }
                        }
                    }
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

Add-Type -TypeDefinition $CSCode -ReferencedAssemblies System.Management.Automation,Microsoft.PowerShell.Commands.Utility -OutputAssembly Nanolex.dll -OutputType Library