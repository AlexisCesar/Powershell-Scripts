# must be run with a '.' before calling the script so it will
# run the script and also load its functions to be called anytime in the
# host, like this: . ./convert-sha.ps1

function ConvertTo-SHA1() {

    param(
        [Parameter(
            Mandatory = $true,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = "FullName"
        )]
        [string] $filePath
    )

    begin {
        $defaultErrorActionPreference = $ErrorActionPreference
        $ErrorActionPreference = "Stop"

        $sha1Managed = New-Object System.Security.Cryptography.SHA1Managed;
        $sha1HexSB = New-Object System.Text.StringBuilder;
    }
    
    process {
        $fileContent = Get-Content $filePath;

        $fileBytes = [System.Text.Encoding]::UTF8.GetBytes($fileContent);

        $fileSHA1 = $sha1Managed.ComputeHash($fileBytes);
        $fileSHA1 | Foreach-Object { $sha1HexSB.Append($_.ToString("x2")) } > $null # more performatic than Out-Null

        Write-Host "HASH FOR: $filePath >>> $sha1HexSB" -BackgroundColor Red -ForegroundColor White;

        $sha1HexSB.Clear() > $null;
    }

    end {
        $sha1Managed.Dispose();
        $ErrorActionPreference = $defaultErrorActionPreference;
    }
}
