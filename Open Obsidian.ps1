Add-Type @"
using System;
using System.Runtime.InteropServices;
public class WinAPI {
    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
}
"@

# Get the first Obsidian process that has a window
$proc = Get-Process obsidian -ErrorAction SilentlyContinue | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1

if ($proc) {
    $hwnd = $proc.MainWindowHandle
    if ($hwnd -ne 0) {
        # 9 = SW_RESTORE
        [WinAPI]::ShowWindowAsync([IntPtr]$hwnd, 9) | Out-Null
        [WinAPI]::SetForegroundWindow([IntPtr]$hwnd) | Out-Null
    }
    else {
        Write-Output "Obsidian is running but has no main window."
    }
}
else {
    # Launch if not running
    Start-Process "C:\Users\coreb\Desktop\Folders\Applications\Obsidian.lnk"

}
