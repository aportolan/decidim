# Croatian (hr) translations & customizations for Decidim

This branch adds Croatian localization and a few host-app customizations on top
of upstream Decidim `v0.31.6`.

## Contents

### 1. Croatian translations (per-module)

Each Decidim module's `config/locales/hr.yml` has been populated with the full
Croatian translation (the upstream files were empty stubs — Croatian was never
upstreamed officially).

| Location | Description |
|---|---|
| `decidim-<module>/config/locales/hr.yml` | Croatian translation for each module (core, admin, proposals, budgets, meetings, initiatives, conferences, assemblies, participatory_processes, accountability, debates, verifications, system, design, elections, forms, comments, sortitions, surveys, templates, collaborative_texts, demographics, dev, api, pages, blogs) |
| `decidim-core/config/locales/hr-extras.yml` | Forward-compatible keys (newer than 0.31.6: assemblies access modes, admin members, pabulib budgeting rules, etc.) |

Total: **8,702 Croatian keys** across the modules, plus the extras.

These were reconstructed by splitting the merged production locale
(`decidim_social_hr_translations/config/locales/hr.yml`, 608 KB) back into
per-module files, using each module's `en.yml` as the structural template.

### 2. Host-app customizations

`host-app-customizations/initializers/*.rb` — fixes that belong in the **host
Rails app** (the deployment app that mounts the Decidim gems), not in the gems
themselves:

- `active_storage_s3_checksum_fix.rb` — Cloudflare R2 compatibility for Active Storage direct uploads
- `api_force_auth_exempt.rb` — allow `/api` access when org-level force-auth is enabled
- `decidim_download_help_fallback_fix.rb` — fallback for download-your-data help definitions
- `decidim_env_to_str.rb` — `Decidim::Env#to_str` workaround for OmniAuth providers via ENV
- `omniauth_nickname_fix.rb` — fix empty nickname from Google/other OAuth providers

Copy these into the host app's `config/initializers/` when deploying.

## Recovery context

The original local edit (a `decidim/` module spread of `hr.yml` files) was lost
in a failed drive copy. This branch is the durable reconstruction, derived from
the recoverable canonical source:
- the live server's merged `hr.yml` (all Croatian text), and
- each module's upstream `en.yml` (structure).