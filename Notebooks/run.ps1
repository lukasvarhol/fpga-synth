$ErrorActionPreference = "Stop"

$VenvDir = ".venv"

Write-Host "Setting up Python virtual environment..."

# Check python
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Error "Python not found. Install Python 3 and ensure it's on PATH."
    exit 1
}

# Create venv if it doesn't exist
if (-not (Test-Path $VenvDir)) {
    Write-Host "Creating virtual environment..."
    python -m venv $VenvDir
}

# Activate venv
Write-Host "Activating virtual environment"
& "$VenvDir\Scripts\Activate.ps1"

Write-Host "⬆Upgrading pip"
python -m pip install --upgrade pip

# Install dependencies
if (Test-Path "requirements.txt") {
    Write-Host "Installing dependencies"
    pip install -r requirements.txt
} else {
    Write-Host "requirements.txt not found, skipping dependency install"
}

# Register kernel for Jupyter
Write-Host "Registering Jupyter kernel"
python -m ipykernel install --user --name fpga-synth --display-name "FPGA Synth"

Write-Host "Done"

