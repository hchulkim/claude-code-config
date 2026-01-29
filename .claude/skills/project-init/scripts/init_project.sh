#!/bin/bash
# Initialize a new economics research project

set -e

# Arguments
PROJECT_NAME="${1:-new-project}"
BASE_PATH="${2:-$(pwd)}"

PROJECT_PATH="$BASE_PATH/$PROJECT_NAME"

echo "Creating project: $PROJECT_NAME"
echo "Location: $PROJECT_PATH"

# Create directory structure
mkdir -p "$PROJECT_PATH"/{code/{build,analysis},data/{raw,build,proc},output/{figures,tables,paper}}

# Create .gitkeep files
for dir in code/build code/analysis data/raw data/build data/proc output/figures output/tables output/paper; do
    touch "$PROJECT_PATH/$dir/.gitkeep"
done

# Create .here file
touch "$PROJECT_PATH/.here"

# Create .gitignore
cat > "$PROJECT_PATH/.gitignore" << 'EOF'
# Data
data/raw/*
data/build/*
data/proc/*
!data/*/.gitkeep

# Outputs
output/tables/*.tex
output/tables/*.html
output/figures/*.pdf
output/figures/*.png
!output/*/.gitkeep

# Nix
result
result-*
.direnv/

# R
.Rhistory
.RData
.Rproj.user/
*.Rproj

# Python
__pycache__/
*.pyc
.ipynb_checkpoints/

# Julia
*.jl.cov
*.jl.mem

# LaTeX
*.aux
*.log
*.out
*.bbl
*.blg
*.fls
*.fdb_latexmk
*.synctex.gz

# OS
.DS_Store
Thumbs.db

# Editor
*.swp
*.swo
*~
.vscode/
.idea/
EOF

# Create generate_env.R
cat > "$PROJECT_PATH/generate_env.R" << 'EOF'
library(rix)

rix(
  r_ver = "4.3.2",
  r_pkgs = c(
    # Core
    "data.table",
    "here",
    
    # Econometrics
    "fixest",
    
    # Output
    "modelsummary",
    "ggplot2"
  ),
  system_pkgs = NULL,
  ide = "none",
  project_path = ".",
  overwrite = TRUE
)
EOF

# Create Makefile
cat > "$PROJECT_PATH/Makefile" << 'EOF'
.PHONY: all clean data analysis paper

all: analysis

# ============== DATA ==============
data/proc/analysis.rds: code/build/01-build-data.R
	nix-shell --run "Rscript $<"

data: data/proc/analysis.rds

# ============== ANALYSIS ==============
output/tables/main.tex output/figures/main.pdf: code/analysis/01-main.R data/proc/analysis.rds
	nix-shell --run "Rscript $<"

analysis: output/tables/main.tex

# ============== PAPER ==============
paper: output/paper/paper.pdf

output/paper/paper.pdf: output/paper/paper.qmd analysis
	nix-shell --run "quarto render $<"

# ============== CLEAN ==============
clean:
	rm -f data/build/* data/proc/*
	rm -f output/tables/* output/figures/*
EOF

# Create README.md
cat > "$PROJECT_PATH/README.md" << EOF
# $PROJECT_NAME

## Overview

[Brief description of the project]

## Requirements

- nix package manager
- R 4.3.2 (managed via rix)

## Setup

\`\`\`bash
# Build environment
nix-build

# Enter environment
nix-shell
\`\`\`

## Replication

\`\`\`bash
make all
\`\`\`

## Structure

\`\`\`
$PROJECT_NAME/
├── code/
│   ├── build/      # Data construction
│   └── analysis/   # Analysis scripts
├── data/
│   ├── raw/        # Original data
│   ├── build/      # Intermediate
│   └── proc/       # Analysis-ready
└── output/
    ├── figures/
    ├── tables/
    └── paper/
\`\`\`
EOF

# Create minimal CLAUDE.md
cat > "$PROJECT_PATH/CLAUDE.md" << 'EOF'
# Project-Specific Claude Instructions

## This Project
[Add project-specific instructions here]

## Data Sources
[Document data sources and how to access them]

## Key Variables
[Document key variable definitions]
EOF

echo ""
echo "Project created successfully!"
echo ""
echo "Next steps:"
echo "  cd $PROJECT_PATH"
echo "  git init"
echo "  # Edit generate_env.R to add required packages"
echo "  Rscript generate_env.R"
echo "  nix-build"
echo ""
