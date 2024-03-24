$blockCode = @"
    [DllImport("user32.dll")]
    public static extern bool BlockInput(bool fBlockIt);
"@

$offCode = @"
    [DllImport("user32.dll")]
    public static extern int PostMessage(int hWnd, int hMsg, int wParam, int lParam);
"@

$userInput_blockInput = Add-Type -MemberDefinition $blockCode -Name UserInput -Namespace UserInput -PassThru
$userInput_turnOfScreen = Add-Type -MemberDefinition $offCode -Name a -Pas

function Disable-UserInput-thenOffScreen($seconds) {
    $userInput_blockInput::BlockInput($true)
    for ($i = 1; $i -le 100; $i++ ) {
        Write-Progress -Activity "Starting Proceedure" -Status "$i% Complete:" -PercentComplete $i
        Start-Sleep -Milliseconds 15
    }
    $userInput_turnOfScreen::PostMessage(-1,0x0112,0xF170,2)
    Start-Sleep $seconds
    $userInput_blockInput::BlockInput($false)
}

Disable-UserInput-thenOffScreen -seconds 2.5 | Out-Null