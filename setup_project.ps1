# setup_project.ps1

# Function to write content to a file with UTF8 encoding
function Write-FileWithContent {
    param (
        [string]$path,
        [string]$content
    )
    $content | Out-File -FilePath $path -Encoding utf8 -NoNewline
    Write-Host "Created $path"
}

# Function to check if Python is installed
function Test-PythonInstallation {
    try {
        python --version
        return $true
    }
    catch {
        return $false
    }
}

# Check if running from project root
if (-not (Test-Path "src/textractai")) {
    Write-Host "Error: Please run this script from the project root directory (TextractAI)" -ForegroundColor Red
    exit 1
}

# Check Python installation
if (-not (Test-PythonInstallation)) {
    Write-Host "Error: Python is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Python 3.9 or later from https://www.python.org/downloads/" -ForegroundColor Yellow
    exit 1
}

# Create virtual environment
Write-Host "Creating Python virtual environment..." -ForegroundColor Green
python -m venv venv
Write-Host "Virtual environment created" -ForegroundColor Green

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Green
.\venv\Scripts\Activate
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to activate virtual environment" -ForegroundColor Red
    exit 1
}

# Create .gitignore
$gitignore = @"
*.py[cod]
__pycache__
*.so
*.egg
*.egg-info
dist
build
eggs
parts
bin
var
sdist
develop-eggs
.installed.cfg
lib
lib64
venv
.env
.venv
env/
ENV/
.idea
.vscode
*.swp
*.swo
.DS_Store
.coverage
htmlcov/
.pytest_cache/
.mypy_cache/
"@

Write-FileWithContent ".gitignore" $gitignore

# Create requirements.txt
$requirements = @"
fastapi>=0.109.2
uvicorn>=0.27.1
python-multipart>=0.0.9
boto3>=1.34.34
python-dotenv>=1.0.1
"@

Write-FileWithContent "requirements.txt" $requirements

# Create requirements-dev.txt
$requirements_dev = @"
pytest>=8.0.0
pytest-cov>=4.1.0
black>=24.1.1
flake8>=7.0.0
pre-commit>=3.6.0
mypy>=1.8.0
"@

Write-FileWithContent "requirements-dev.txt" $requirements_dev

# Create .pre-commit-config.yaml
$pre_commit_config = @"
repos:
-   repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.5.0
    hooks:
    -   id: trailing-whitespace
    -   id: end-of-file-fixer
    -   id: check-yaml
    -   id: check-added-large-files
-   repo: https://github.com/psf/black
    rev: 24.1.1
    hooks:
    -   id: black
-   repo: https://github.com/PyCQA/flake8
    rev: 7.0.0
    hooks:
    -   id: flake8
-   repo: local
    hooks:
    -   id: verify-commit-message
        name: Verify Commit Message Format
        entry: python scripts/verify_commit_msg.py
        language: python
        stages: [commit-msg]
"@

Write-FileWithContent ".pre-commit-config.yaml" $pre_commit_config

# Create pyproject.toml
$pyproject = @"
[tool.black]
line-length = 88
target-version = ['py39']
include = '\.pyi?$'

[tool.pytest.ini_options]
minversion = "6.0"
addopts = "-ra -q"
testpaths = [
    "tests",
]

[project]
name = "textractai"
version = "0.1.0"
description = "A cloud-based Optical Character Recognition (OCR) service"
authors = [
    {name = "Pooja @ Tathyum", email = "pooja@tathyum.com"},
]
"@

Write-FileWithContent "pyproject.toml" $pyproject

# Create .flake8
$flake8 = @"
[flake8]
max-line-length = 88
extend-ignore = E203
exclude = .git,__pycache__,build,dist,*.egg-info
"@

Write-FileWithContent ".flake8" $flake8

# Create README.md
$readme = @"
# TextractAI

A powerful cloud-based Optical Character Recognition (OCR) service by Tathyum.

## About

TextractAI is developed by Tathyum to provide enterprise-grade OCR capabilities through a simple and efficient API. Built with modern technology stack and deployed on AWS infrastructure.

## Setup

1. Create and activate virtual environment:
\`\`\`bash
python -m venv venv
# On Windows:
.\venv\Scripts\activate
# On Unix/MacOS:
source venv/bin/activate
\`\`\`

2. Install dependencies:
\`\`\`bash
pip install -r requirements.txt
pip install -r requirements-dev.txt  # For development
\`\`\`

3. Install pre-commit hooks:
\`\`\`bash
pre-commit install
pre-commit install --hook-type commit-msg
\`\`\`

## Development

1. Create new feature branch:
\`\`\`bash
git checkout develop
git checkout -b feature/your-feature-name
\`\`\`

2. Make changes and commit:
\`\`\`bash
git add .
git commit -m "feat(scope): description"
\`\`\`

3. Push changes and create pull request to develop branch

## License

Copyright (c) 2024 Tathyum. All rights reserved.
"@

Write-FileWithContent "README.md" $readme

# Create verify_commit_msg.py in scripts directory
$verify_commit_msg = @"
#!/usr/bin/env python3
import sys
import re

def verify_commit_message(commit_msg_file):
    with open(commit_msg_file, 'r') as f:
        commit_msg = f.read().strip()

    pattern = r'^(feat|fix|docs|style|refactor|test|chore)(\([a-z-]+\))?: .+$'

    if not re.match(pattern, commit_msg):
        print('ERROR: Invalid commit message format.')
        print('Format should be: <type>(<scope>): <description>')
        print('Types: feat, fix, docs, style, refactor, test, chore')
        print('Example: feat(auth): add JWT authentication')
        sys.exit(1)

if __name__ == '__main__':
    verify_commit_message(sys.argv[1])
"@

Write-FileWithContent "scripts/verify_commit_msg.py" $verify_commit_msg

# Install requirements
Write-Host "Installing dependencies..." -ForegroundColor Green
pip install -r requirements.txt
pip install -r requirements-dev.txt

# Initialize pre-commit
Write-Host "Setting up pre-commit..." -ForegroundColor Green
pre-commit install
pre-commit install --hook-type commit-msg

Write-Host "`nSetup completed successfully!" -ForegroundColor Green
Write-Host "Your virtual environment is now activated and all dependencies are installed." -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Review the generated files" -ForegroundColor Yellow
Write-Host "2. Make any necessary adjustments to the configurations" -ForegroundColor Yellow
Write-Host "3. Commit the changes using the conventional commit format" -ForegroundColor Yellow
Write-Host "   Example: git commit -m 'chore: initial project setup'" -ForegroundColor Yellow
