# Claude Code Instructions for Academic Economics Research

## CRITICAL: Read Before Acting
Before making ANY suggestion or diagnosis about code errors:
1. Read current state of relevant file(s) using the Read tool
2. Do NOT assume code is same as what you last saw
3. Do NOT suggest solutions already in the code
4. If user reports an error, read surrounding code context FIRST

## Project Structure Standard
```
project-name/
├── data/
│   ├── raw/          # Original, immutable data
│   ├── build/        # Intermediate data products
│   └── proc/         # Final processed data for analysis
├── code/
│   ├── build/        # Data cleaning and construction
│   └── analysis/     # Estimation and analysis scripts
├── output/
│   ├── figures/      # Publication-ready figures
│   ├── tables/       # Publication-ready tables
│   └── paper/        # Quarto/LaTeX paper files
├── _extensions/      # Quarto extensions (aea template)
├── .here             # Project root marker
├── Makefile          # Build automation
└── generate_env.R    # rix/nix environment setup
```

## Language-Specific Style

### R
- Use `data.table` syntax (`:=`, `.N`, `.SD`, `by=`)
- Use `fixest` for regressions (feols, fepois, etc.)
- Use `modelsummary`, `kableExtra`, or `etable` for tables
- Use `ggplot2` with minimal themes for figures
- Use `here::here()` for paths (requires `.here` file in project root)
- Align assignment operators for legibility:
```r
main_dt      <- fread(here("data", "raw", "main.csv"))  # Main survey data
controls_dt  <- fread(here("data", "raw", "ctrl.csv"))  # Regional controls
```

### Julia  
- Use `DataFrames.jl` with broadcasting and efficient operations
- Use `FixedEffectModels.jl` for panel regressions
- Use `Optim.jl` for structural estimation
- Use `Distributions.jl` for probability distributions
- Optimize computation: prefer matrix operations, avoid unnecessary allocations
- Use `@views` for slicing, preallocate arrays when possible
```julia
# Good: preallocated, in-place operations
result = zeros(n, m)
@views result[:, 1] .= data[:, j] .* weights

# Avoid: creates intermediate arrays
result = data[:, j] .* weights  # Allocates new array
```

### Python (Jupyter Notebooks)
- Start with markdown block: filename, author, email, date, description, inputs/outputs
- All markdown headings ≤ `####`
- First code block: imports + directory setup
- Base directory: `os.path.join(os.path.expanduser("~"), "Dropbox/Projects")`
- Use `os.path.join` for all paths
- For matplotlib figures, use publication-quality settings:
```python
from matplotlib.ticker import FuncFormatter
import matplotlib as mpl
import matplotlib.pyplot as plt
from cycler import cycler

mpl.use("pgf")
mpl.rcParams.update({
    "pgf.texsystem": "pdflatex",
    "pgf.rcfonts": False,
    "font.family": "serif",
    "font.serif": ["Times"],
    "font.size": 12,
    "axes.labelsize": 14,
    "axes.titlesize": 15,
    "xtick.labelsize": 12,
    "ytick.labelsize": 12,
    "legend.fontsize": 12,
    "axes.facecolor": "white",
    "figure.facecolor": "white",
    "axes.edgecolor": "#404040",
    "axes.prop_cycle": cycler(color=["#4A4A4A"]),
    "pgf.preamble": r"\usepackage[T1]{fontenc}\usepackage{mathptmx}",
})
```

## Editing Rules
- Do NOT overwrite existing work unless explicitly asked
- Add new code as separate blocks, preserving original
- When adding regressions, keep existing ones intact
- Each data input: add brief comment describing it

## Tables Output
- Default: `modelsummary` (R) with appropriate output format
- For LaTeX: use `output = "latex"` or `etable` from `fixest`
- For Word/HTML: use `kableExtra` formatting
- Include standard errors, significance stars, observation counts

## Figures Output  
- Save as both `.pdf` (for LaTeX) and `.png` (for drafts)
- Use consistent color palette across project
- Minimal themes: `theme_minimal()` or custom clean theme
- Label axes clearly, include units

## Server Environment (if applicable)
- Laptop home: `/home/j/`
- Server (Deloach) home: `/home/jsayre/`
- Server Python: use conda env `mpc_env`
- Server: NO sudo, NO apt install

## Git Practices
- Commits: brief, no authorship info
- Branch naming: `feature/description` or `fix/description`
- Before pushing: ensure code runs without errors

## Replication Package Checklist
When preparing for replication:
1. Use `rix` for R environment management (Nix-based)
2. Include `generate_env.R` with package specifications
3. Create `Makefile` with full pipeline
4. Document all data sources in README
5. Verify: `nix-build` then `nix-shell` should reproduce environment

## Quarto Papers
- Use `hchulkim/econ-paper-template` for AEA-style formatting
- Render command: `quarto render paper.qmd --to aea-pdf`
- Keep `bibliography.bib` updated
- Use cross-references: `@fig-name`, `@tbl-name`, `@eq-name`
