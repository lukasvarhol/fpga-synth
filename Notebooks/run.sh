#!/usr/bin/env bash
set -e

VENV_DIR=".venv"

echo "Setting up Python virtual environment..."

# Check python
if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 not found. Please install Python 3."
  exit 1
fi

# Activate venv
echo "Activating virtual environment"
source "$VENV_DIR/bin/activate"

echo "Upgrading pip"
pip install --upgrade pip

# Install dependencies
if [ -f requirements.txt ]; then
  echo "Installing dependencies"
  pip install -r requirements.txt
else
  echo "requirements.txt not found, skipping dependency install"
fi

# Register kernel for Jupyter (optional but recommended)
echo "Registering Jupyter kernel"
python -m ipykernel install --user --name fpga-synth --display-name "FPGA Synth"

echo "Done"
