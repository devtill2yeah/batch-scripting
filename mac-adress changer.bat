
private const string baseReg =
    @"SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\";

public static bool SetMAC(string nicid, string newmac)
{
    bool ret = false;
    using (RegistryKey bkey = GetBaseKey())
    using (RegistryKey key = bkey.OpenSubKey(baseReg + nicid))
    {
        if (key != null)
        {
            key.SetValue("NetworkAddress", newmac, RegistryValueKind.String);

            ManagementObjectSearcher mos = new ManagementObjectSearcher(
                new SelectQuery("SELECT * FROM Win32_NetworkAdapter WHERE Index = " + nicid));

            foreach (ManagementObject o in mos.Get().OfType<ManagementObject>())
            {
                o.InvokeMethod("Disable", null);
                o.InvokeMethod("Enable", null);
                ret = true;
            }
        }
    }

    return ret;
}

public static IEnumerable<string> GetNicIds()
{
    using (RegistryKey bkey = GetBaseKey())
    using (RegistryKey key = bkey.OpenSubKey(baseReg))
    {
        if (key != null)
        {
            foreach (string name in key.GetSubKeyNames().Where(n => n != "Properties"))
            {
                using (RegistryKey sub = key.OpenSubKey(name))
                {
                    if (sub != null)
                    {
                        object busType = sub.GetValue("BusType");
                        string busStr = busType != null ? busType.ToString() : string.Empty;
                        if (busStr != string.Empty)
                        {
                            yield return name;
                        }
                    }
                }
            }
        }
    }
}

public static RegistryKey GetBaseKey()
{
    return RegistryKey.OpenBaseKey(
        RegistryHive.LocalMachine,
        InternalCheckIsWow64() ? RegistryView.Registry64 : RegistryView.Registry32);
}

static bool is64BitProcess = (IntPtr.Size == 8);
static bool is64BitOperatingSystem = is64BitProcess || InternalCheckIsWow64();

[DllImport("kernel32.dll", SetLastError = true, CallingConvention = CallingConvention.Winapi)]
[return: MarshalAs(UnmanagedType.Bool)]
private static extern bool IsWow64Process(
    [In] IntPtr hProcess,
    [Out] out bool wow64Process
);

public static bool InternalCheckIsWow64()
{
    if ((Environment.OSVersion.Version.Major == 5 && Environment.OSVersion.Version.Minor >= 1) ||
        Environment.OSVersion.Version.Major >= 6)
    {
        using (Process p = Process.GetCurrentProcess())
        {
            bool retVal;
            if (!IsWow64Process(p.Handle, out retVal))
            {
                return false;
            }
            return retVal;
        }
    }
    else
    {
        return false;
    }
}

