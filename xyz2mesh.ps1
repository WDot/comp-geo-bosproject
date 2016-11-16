$SourceFolder='C:\Users\Miguel Dominguez\Documents\bosphorus\xyz'
$DestFolder='C:\Users\Miguel Dominguez\Documents\bosphorus\meshExpr3'
$Script = "C:\Users\Miguel Dominguez\Documents\GitHub\GCNN\util\pointclouds\pointsToMeshUncut.mlx"


$MESHLAB = 'C:\Program Files\VCG\MeshLab\meshlabserver.exe'
 
Write-Output $SourceFolder
#Check that Source is valid
If (Test-Path -LiteralPath $SourceFolder) 
{ 
    $Dir = get-childitem $SourceFolder -recurse 
    $List = $Dir | where {$_.extension -eq '.xyz'} 
    $List | format-table Name 
} 
else 
{ 
    "Input folder path does not exist." 
}
#Create Destination if it does not exist
If  (-Not (Test-Path -LiteralPath $DestFolder))
{
	New-Item -ItemType Directory -Force -Path $DestFolder
}

ForEach ($File in $List)
{
	if ($File.basename -match "ANGER|DISGUST|FEAR|HAPPY|SADNESS|SURPRISE")
	{
		$outFile = $File.basename + '.ply'
		If (-Not (Test-Path "$DestFolder\$outFile"))
		{
			#Set-PSDebug -Trace 1
			& $MESHLAB -i xyz\$File -o meshExpr3\$outFile -s ..\GitHub\GCNN\util\pointclouds\pointsToHighQualMeshWithCollapse.mlx
		}
		Else
		{
			Write-Output "$outFile already exists!"
		}
	}
}