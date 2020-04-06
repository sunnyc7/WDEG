# WDEG EP

## ASLR
### Description
### Invoked
### Settings
### Validate
### Bypass
### Weaknesses 

## DEP
### Description
### Invoked
### Settings
### Validate
### Bypass
### Weaknesses 


## SEHOP
### Description
### Invoked
### Settings
### Validate
### Bypass
### Weaknesses 

## ACG
### Description
### Invoked
### Settings
### Validate
### Bypass
### Weaknesses 

## CFG

### Description
- MSFT - Intro - https://docs.microsoft.com/en-us/windows/win32/secbp/control-flow-guard
- [2/5/2017] A very thorough overview of CFG by LucasG - https://lucasg.github.io/2017/02/05/Control-Flow-Guard/
- CFG Property Pages by LucasG - https://github.com/processhacker/processhacker/pull/101
- [2/7/2015] Trendmicro. Jack Tang - CFG - https://assets/wp/exploring-control-flow-guard-in-windows10.pdf

### Invoked
- (Trend) During OS Boot Phase, first called CFG-related function is MiInitializeCfg. The primary job of the function MiInitializeCfg is to create shared memory to contain CFG Bitmap.

### Settings
- HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\kernel: MitigationOptions

### Validate
- 

### Bypass
- Leaking Stack With SEH - https://improsec.com/tech-blog/back-to-basics-or-bypassing-control-flow-guard-with-structured-exception-handler #BBFail

### Weaknesses (JT/Trend), LucasG, 
- LG - Firstly it only check the call target, not the call arguments. 
- Needs to be >= VS2015 `msvc /cfguard `
- The CFGBitmap space’s base address is stored in a fixed addres,s which can be retrieved from user mode code. This was described in the implementation of CFG. This is important, security data but however, it can be easily gotten.
- If the main executable is not enabled for CFG, the process is not protected by CFG even if it loaded a CFG-enabled module.
- Based on Figure 20, if a process’s main executable has disabled DEP (the process’s ExecuteEnable is enabled by compiled with /NXCOMPAT:NO), it will bypass the CFG violation handle, even if the indirect call target address is invalid.
- Every bit in the CFGBitmap represents eight bytes in the process space. So if an invalid target call address has less than eight bytes from the valid function address, the CFG will think the target call address is “valid.”
- If the target function generated is dynamic (similar to JIT technology), the CFG implement doesn’t protect it. This is because NtAllocVirtualMemory will set all “1” in CFGBitmap for allocated executable virtual memory space (described in 4.c.i). It’s possible that customizing the CFGBitmap via MiCfgMarkValidEntries can address this issue.
