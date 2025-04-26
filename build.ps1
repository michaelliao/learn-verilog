# This script is used to build the project using PowerShell:

function Get-ProjectName {
    $currentPath = $pwd.Path
    $lastDirName = $currentPath.Split('\')[-1]
    return $lastDirName
}

function Is-FileExist {
    param (
        [string]$fileName
    )
    $filePath = Join-Path $pwd.Path $fileName
    return Test-Path $filePath
}

# 返回当前工程的top文件,依次查找:
# 1. 传入的参数
# 2. 与当前目录名同名的.v文件
# 3. top.v文件
function Get-ProjectTopName {
    param(
        [string] $name
    )
    if ($name.Length -gt 0) {
        $top = $name
        if ($top.EndsWith(".v")) {
            $top = $top.Substring(0, $top.Length - 2)
        }
        if (Is-FileExist "$top.v") {
            return $top
        }
        Write-Error "Cannot find file: $top.v"
        exit 1
    }
    $top = Get-ProjectName
    if (Is-FileExist "$top.v") {
        return $top
    }
    $top = "top"
    if (Is-FileExist "$top.v") {
        return $top
    }
    Write-Error "Cannot determin the .v file."
    exit 1
}

function Get-Testbench {
    param (
        [string]$name
    )
    $module_tb = "${name}_tb"
    if (Is-FileExist "$module_tb.v") {
        return $module_tb
    }
    return ""
}

# 允许一个参数指定module:
if ($args.Count -gt 1) {
    Write-Error "Too many arguments. Only one argument is allowed."
    exit 1
}
$arg0 = ""
if ($args.Count -gt 0) {
    $arg0 = $args[0]
}

$workingDir = $pwd.Path
echo "set pwd = $workingDir"

$module = Get-ProjectTopName($arg0)
echo "set top module = $module"

echo "compile $module.v..."
iverilog -g2005 -y . -s $module -o "$module.out" "$module.v"
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

# 自动检测testbench模块,如果存在则编译并运行:
$module_tb = Get-Testbench($module)
if ($module_tb.Length -eq 0) {
    echo "no test bench found. skip test."
} else {
    echo "compile test bench module: ${module_tb}.v..."
    iverilog -g2005 -y . -s ${module_tb} -o "${module_tb}.out" "${module_tb}.v"
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
    echo "simulate ${module_tb}.out..."
    if (Is-FileExist "test.vcd") {
        rm test.vcd
    }
    vvp "${module_tb}.out"
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
    echo "open gtkwave for ${module_tb}..."
    start gtkwave test.vcd
}
