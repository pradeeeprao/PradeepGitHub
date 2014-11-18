#Add LRECL based on format files
cls
$files = Get-ChildItem *.fmt
foreach ($file in $files)
{
    $recl = 0
    foreach ($line in gc $file) 
    {         
        if ($line.length -gt 10)
        {
            $linenew = $line.substring(($line.IndexOf('SQLCHAR')+7),30)
            $recl = $recl + $linenew.substring(($linenew.IndexOf('0')+8),3)
        }
    }
    write-host $file.name `t $recl
}


#Snapshot Automation

ls "C:\Pradeep\Mainframe\SLO\New folder" | select Name,Length | export-csv "SnapshotFiles.csv" -notypeinformation

ls  -r –Fi *.CLUTL01.PROCRES1.txt | select-string -Pattern "RECORDS WRITTEN" | 
Select-Object -prop @{n='TableName';e={$_.FileName -replace ".CLUTL01.PROCRES1.txt"}}, @{n='Count';e={$_.Line -replace "RECORDS WRITTEN"}} | 
Export-CSV DMIGCounts.csv  -notypeinformation

select distinct convert(varchar(30),object_name(a.id)) [Table Name], a.rows
from sysindexes a inner join sysobjects b on a.id = b.id 
where xtype = 'U'

bcp "select col1, col2, col3 from database.schema.SomeTable" queryout  "c:\MyData.txt"  -c -t"," -r"\n" -S ServerName -T

#Table count options

SELECT o.name,
  ddps.row_count 
FROM sys.indexes AS i
  INNER JOIN sys.objects AS o ON i.OBJECT_ID = o.OBJECT_ID
  INNER JOIN sys.dm_db_partition_stats AS ddps ON i.OBJECT_ID = ddps.OBJECT_ID
  AND i.index_id = ddps.index_id 
WHERE i.index_id < 2  AND o.is_ms_shipped = 0 ORDER BY o.NAME

SELECT
          SUM(sdmvPTNS.row_count) AS [DBRows]
    FROM
          sys.objects AS sOBJ
          INNER JOIN sys.dm_db_partition_stats AS sdmvPTNS
                ON sOBJ.object_id = sdmvPTNS.object_id
    WHERE 
          sOBJ.type = 'U'
          AND sOBJ.is_ms_shipped = 0
          AND sdmvPTNS.index_id < 2

#get file names
cls
cd "E:\EMC\DMIG\Client\SLO\Data\Datasets\Reports"
Get-ChildItem -recurse –Filter *.CLUTL01.PROCRES1.txt | Select-String -pattern "RECORDS WRITTEN" | ft @{n='TableName';e={$_.FileName -replace ".CLUTL01.PROCRES1.txt" };align='left'}, @{n='Count';e={$_.Line -replace "RECORDS WRITTEN" };align='left'} 

#split csv to fixed length
answer.txt powershell "Get-Content comma3.txt | %{'{0,-10}{1,-14}{2,-19}{3,-11}{4,-4}{5}' -f $_.split(',')}"

#converting to hex
(get-content -encoding byte -totalcount 1000 TCCT021.txt | % { "\x{0:X2}" -f $_ }) -join 

#Replacing text in large files
foreach ($line in gc "C:\Pradeep\PowerShell\Data\TCCT021\TCCT021.txt") 
{   
    $line = $line -replace '\x00', ''    
    $line | Out-File "C:\Pradeep\PowerShell\Data\TCCT021\Pradeep.txt" -encoding "UTF8" -Append    
}

#Rename All Files
ls "C:\Pradeep\Personal\Room Windows\*.jpg" | Foreach -Begin {$i=1} -Process {Rename-Item $_ -NewName ("A{0:0000}.jpg" -f $i++) -whatif}
ls *.jpg | Foreach -Begin {$i=1} -Process { $_.LastWriteTime.ToString("yyyyMMM") }
ls *.jpg | Foreach -Begin {$i=1} -Process { Rename-Item $_ -NewName ("A{0:0000}_$($_.LastWriteTime.ToString("yyyyMMM")).jpg" -f $i++) -whatif}

#pipeline program
dir | Get-File
dir *.txt | foreach {$_.fullname} | Get-File

# if pipleine does not work as in row below use foreach-object alias %
# Get-Process | Write-Host $_.name -foregroundcolor cyan
Get-Process | ForEach-Object {Write-Host $_.name -foregroundcolor cyan}

#show lines if it does not contain idle or svchost
select-string -path process.txt -pattern idle, svchost -notmatch

#If string contains Optimized then get substring as a match group
Select-String "25-11-2013-23-16-13_PasadenaCasualty.log" -pattern "Optimized.*?(Code of.*)" | Foreach {$_.Matches} | Foreach {$_.Groups[1].Value} | select -unique

#extract string which do not contain setting using regex
get-content 25-11-2013-23-16-13_PasadenaCasualty.log | select-string "^(?!.*setting)" > "PasadenaInvalid.txt"
get-content PasadenaInvalid.txt | select-string "^(?!.*Invalid)"

#passing parameters from another file.
gc ExtractedValues.txt | % {
echo "" 
echo "-------- start file $($_.split('~')[1]) --------"
.\SortFieldCreator.ps1 -sortfield $_.split('~')[0] -totallength 1000
echo "-------- end file $($_.split('~')[1]) --------" 
echo ""
}

#passing parameters from another file another way
foreach ($line in gc ExtractedValues.txt) 
{    
    $value = $line.split('~')
    echo ""
    echo "-------- start file $($value[1]) --------" >> Result.txt
    .\SortFieldCreator.ps1 -sortfield $value[0] -totallength 1000 >> Result.txt
    echo "-------- end file $($value[1]) --------" >> Result.txt
}

#example of grouping based on search pattern
Select-String *.log -pattern "Setting" | group pattern

#loop through all files in directory group by filename (obtains occurances per file)
Get-ChildItem -path "\\INCSMISHRR9L2C\slo\Chad accept date work\VSD_TO_DO_DATE\Source_To_Edit" -recurse –Filter *.cbl | Select-String -pattern "EMC-DATE" | group -property FileName
Get-ChildItem -path "\\INCSMISHRR9L2C\slo\Chad accept date work\VSD_TO_DO_DATE\Source_To_Edit" -recurse –Filter *.cbl | Select-String -pattern "FROM DATE" | Group-Object pattern | Select-Object Count

#loop through all files in directory search and export to csv
Get-ChildItem -path "\\INCSMISHRR9L2C\slo\Chad accept date work\VSD_TO_DO_DATE\Source_To_Edit" -recurse –Filter *.cbl | Select-String -pattern "INCLUDE" | select Line,FileName,LineNumber | export-csv "Verify3.csv"

#can pipe to getcontent
Get-ChildItem -path "\\INCSMISHRR9L2C\slo\Chad accept date work\VSD_TO_DO_DATE\Source_To_Edit" -recurse –Filter *.cbl | gc | foreach {Write-Host $_.length}

#To import modules
Import-Module VerifyPSScripts
Get-ChildItem -recurse –Filter *.ps1 | VerifyPSScripts -IncludeSummaryReport

#get 5 lines after search parameter
Select-String *.log -pattern "Warning|Critical" -context 0,5 > "Result.txt"

#get content between tags
Select-String "Result.txt" -pattern "<message>(.*?)</message>" | Foreach {$_.Matches} | Foreach {$_.Value}

#find string in all files
Get-ChildItem -filter *.ps1 -recurse | Select-String -pattern "SetDMIGDTAFile"

#get content of all files in a directory
Get-ChildItem -Recurse -Filter "*CLUTL01.DFCONV*.txt" | Get-Content

#get first 10 rows of a file 
Get-ChildItem -Recurse | Sort-Object -Descending Length | Select -First 10
Get-ChildItem -recurse | Get-Content | Select-String -pattern "dummy" | select -unique path

#extract certain words
Select-String -Path "Extraction of CAG#LFRD.cpy" -pattern "CALF-[\w'-]*" | % {$_.Matches} | % {$_.Value} > "Extraction of CAG#LFRD2.cpy"

#extract multiple words
Select-String -Path "CACLGCPY.cpy" -pattern "(X*\(0?1\)\.)|PIC X\.|bit" | ft line > "Extraction of CACLGCPY.cpy"


#http://ss64.com/ps/syntax-regex.html - Regex commands

#extract after word term
Select-String -Path *.log -pattern "term (\'.*?\')" | % {$_.Matches} | % {$_.Value} > test.txt

#get count
(Select-String -Path *.log -pattern "(\'0.*?\')" -AllMatches | % {$_.Matches} | % {$_.Value}).count

#get unique
Select-String -Path *.log -pattern "term (\'.*?\')" -AllMatches | % {$_.Matches} | % {$_.Value} | sort | Get-Unique > MissingClientCodes.txt

#IP address:
$input_path = ‘c:\ps\ip_addresses.txt’
$output_file = ‘c:\ps\extracted_ip_addresses.txt’
$regex = ‘\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b’
select-string -Path $input_path -Pattern $regex -AllMatches | % { $_.Matches } | % { $_.Value } > $output_file

#URL:
$input_path = ‘c:\ps\URL_addresses.txt’
$output_file = ‘c:\ps\extracted_URL_addresses.txt’
$regex = ‘([a-zA-Z]{3,})://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?’
select-string -Path $input_path -Pattern $regex -AllMatches | % { $_.Matches } | % { $_.Value } > $output_file

#Remove all files with a specific suffix from a directory tree
get-childitem -filter '*.xyz' -recurse | remove-item

#get first two lines
type my.txt -t 2

#last 5 lines
Get-Content c:\scripts\test.txt | Select-Object -last 5

Get-Content FILE_NAME | Select-String “Movie Name”

$a = $text.ToCharArray()

$text.PadLeft(200)

$text.Contains(“brown”)

$text.Remove(4,7)

$text.Replace("@emc.com"," ")


#service
Get-Service | Where-Object {$_.status -eq "stopped"}

get-wmiobject win32_service | where-object {$_.state -eq "Running"} | ft Name, Description

get-wmiobject win32_service | where-object {$_.state -eq "Running" -and $_.Description -like "*stop*"} | fl Name, Description

gsv -exclude "KeyServices.txt" | ?{$_.Status -eq "Running"} > "CheckServices.txt"

#Merge csv
ls *.csv | Import-Csv | Export-Csv "ConsolidatedClientCodes.csv"

#top 5 lines
gc ".\ConsolidatedClientCodes.csv" | select -first 5

#top 5 lines
Import-Csv .\ConsolidatedClientCodes.csv | select term -first 5

#CSV comparision
$file1 = import-csv -Path "allclientcodes201305060150449.csv" 
$file2 = import-csv -Path "Testallclientcodes201305060150449.csv" 
Compare-Object $file1 $file2 -property Term, Practice > Compare.txt

#The command above will search each line of "somefile.txt" for the regular expression "expression" and replace it with the string "replace"
cat somefile.txt | %{$_ -replace "expression","replace"}

#example
cat DATA.TXT | where { $_ -match "Mary"}

#copy to new file
cat DATA.TXT | % { $_ -replace "Mary","Susan" } > newfile.txt

#This also works
cat data.txt | select-string -pattern "Mary"
dir -recurse | select-string -pattern "Mary"

#Below will give you a list of sorted process names, changing any names that end with 90 to ninety, such as SQLAGENT90 to SQLAGENTninety
Get-Process | Select Name | sort -property Name | foreach { $_.Name -replace '^(.*)90$', '$1ninety' } 

#get statistics - line count
Get-Content "Extraction of CACLGCPY_NAR.txt" | Measure-Object –Line
