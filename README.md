# claude-code-config
This is my Claude Code config created from Claude Chat.

## Structure

```
project-folder/
├── CLAUDE.md                           # Main instructions file
└── skills/
    ├── econometrics-r/SKILL.md         # R: data.table, fixest, DiD, spatial
    ├── econometrics-julia/SKILL.md     # Julia: structural estimation, optimization
    ├── quarto-papers/SKILL.md          # Your AEA template workflow
    ├── replication-package/            # rix/nix reproducibility
    │   ├── SKILL.md
    │   └── references/readme-template.md
    └── project-init/                   # New project scaffolding
        ├── SKILL.md
        └── scripts/init_project.sh
```

## Key Features
`CLAUDE.md` includes your original style preferences plus:

* Aligned variable assignment formatting
* Publication-quality `matplotlib` settings (pgf/LaTeX)
* Julia optimization tips (views, preallocations, broadcasting)
* Server environment handling (Deloach)

### Skills cover:
* **R econometrics:** Panel regressions with `fixest`, Sun-Abraham/Callaway-Sant'Anna DiD, spatial models with `spdep`, causal forests with `grf`
* **Julia:** Structural estimation (MLE, GMM, MSM), performance optimization, parallel computing, numerical methods
* **Quarto papers:** Full integration with your `econ-paper-template`, cross-references, citations
* **Replication:** `rix`/`nix` environment setup, Makefile pipelines, DCAS-compliant README template
* **Project init:** Bash script to scaffold new projects with your preferred structure

## Usage
1.  Download the zip and extract to your projects root
2.  For Claude Code: place `CLAUDE.md` in your project root and the `skills/` folder where accessible
3.  Run `bash skills/project-init/scripts/init_project.sh "my-new-project"` to create new projects
