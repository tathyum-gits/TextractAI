# TextractAI

A powerful cloud-based Optical Character Recognition (OCR) service by Tathyum.

## About

TextractAI is developed by Tathyum to provide enterprise-grade OCR capabilities through a simple and efficient API. Built with modern technology stack and deployed on AWS infrastructure.

## Setup

1. Create and activate virtual environment:
\\\ash
python -m venv venv
# On Windows:
.\venv\Scripts\activate
# On Unix/MacOS:
source venv/bin/activate
\\\

2. Install dependencies:
\\\ash
pip install -r requirements.txt
pip install -r requirements-dev.txt  # For development
\\\

3. Install pre-commit hooks:
\\\ash
pre-commit install
pre-commit install --hook-type commit-msg
\\\

## Development

1. Create new feature branch:
\\\ash
git checkout develop
git checkout -b feature/your-feature-name
\\\

2. Make changes and commit:
\\\ash
git add .
git commit -m "feat(scope): description"
\\\

3. Push changes and create pull request to develop branch

## License

Copyright (c) 2024 Tathyum. All rights reserved.
