
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction to Nonprofits <a href='https://nonprofitf22.classes.andrewheiss.com/'><img src='files/favicon-512.png' align="right" height="139" /></a>

[PMAP 3210 • Fall 2022](https://nonprofitf22.classes.andrewheiss.com/)  
[Andrew Heiss](https://www.andrewheiss.com/) • Andrew Young School of
Policy Studies • Georgia State University

------------------------------------------------------------------------

**[Quarto](https://quarto.org/) +
[{targets}](https://docs.ropensci.org/targets/) +
[{renv}](https://rstudio.github.io/renv/) +
[{xaringan}](https://github.com/yihui/xaringan) = magic! 🪄**

------------------------------------------------------------------------

## How to build the site

1.  Install
    [RStudio](https://www.rstudio.com/products/rstudio/download/#download)
    version 2022.07.1 or later since it has a
    [Quarto](https://quarto.org/) installation embedded in it.
    Otherwise, download and install [Quarto](https://quarto.org/)
    separately.
2.  Open `nonprofitf22.Rproj` to open an [RStudio
    Project](https://r4ds.had.co.nz/workflow-projects.html).
3.  If it’s not installed already, R *should* try to install the [{renv}
    package](https://rstudio.github.io/renv/) when you open the RStudio
    Project for the first time. If you don’t see a message about package
    installation, install it yourself by running
    `install.packages("renv")` in the R console.
4.  Run `renv::restore()` in the R console to install all the required
    packages for this project.
5.  Run `targets::tar_make()` in the R console to build everything.
6.  🎉 All done! 🎉 The complete website will be in a folder named
    `_site/`.

## {targets} pipeline

I use the [{targets} package](https://docs.ropensci.org/targets/) to
build this site and all its supporting files. The complete pipeline is
defined in [`_targets.R`](_targets.R) and can be run in the R console
with:

``` r
targets::tar_make()
```

The pipeline does several major tasks:

-   **Render xaringan slides to HTML and PDF**: Quarto supports
    HTML-based slideshows through
    [reveal.js](https://quarto.org/docs/presentations/revealjs/).
    However, I created all my slides using
    [{xaringan}](https://github.com/yihui/xaringan), which is based on
    [remark.js](https://remarkjs.com/) and doesn’t work with Quarto.
    Since I don’t have time to recreate my fancy template in reveal.js
    right now, I want to keep using {xaringan}.

    The pipeline [dynamically generates
    targets](https://books.ropensci.org/targets/dynamic.html) for all
    the `.Rmd` files in [`/slides/`](/slides/) and renders them using R
    Markdown rather than Quarto.

    The pipeline then uses
    [{renderthis}](https://jhelvy.github.io/renderthis/) to convert each
    set of HTML slides into PDFs.

-   **Build Quarto website**: This project is a [Quarto
    website](https://quarto.org/docs/websites/), which compiles and
    stitches together all the `.qmd` files in this project based on the
    settings in [`_quarto.yml`](_quarto.yml). See the [Quarto website
    documentation](https://quarto.org/docs/websites/) for more details.

-   **Upload resulting `_site/` folder to my remote server**: Quarto
    places the compiled website in a folder named `/_site/`. The
    pipeline uses `rsync` to upload this folder to my personal remote
    server. This target will only run if the `UPLOAD_WEBSITES`
    environment variable is set to `TRUE`, and it will only work if you
    have an SSH key set up on my personal server, which only I do.

The complete pipeline looks like this:

<small>(This uses [`mermaid.js`
syntax](https://mermaid-js.github.io/mermaid/) and should display as a
graph on GitHub. You can also view it by pasting the code into
<https://mermaid.live>.)</small>

``` mermaid
graph LR
  subgraph Graph
    x9c20b8c56debbe9a(["deploy_script"]):::skipped --> x78f3e0b711425f1c(["deploy_site"]):::queued
    x7aa56383a054e8ba(["site"]):::queued --> x78f3e0b711425f1c(["deploy_site"]):::queued
    x4a210bdf90796bca(["xaringan_files_files"]):::built --> xf4774655f169db90["xaringan_files"]:::queued
    x4d31f5a49d5ae49f(["schedule_ical_file"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    x063edd335cc1b36f(["schedule_page_data"]):::queued --> x7aa56383a054e8ba(["site"]):::queued
    xccbb2c85646c611a["xaringan_pdfs"]:::queued --> x7aa56383a054e8ba(["site"]):::queued
    x60c212b45249134a["xaringan_slides"]:::queued --> x7aa56383a054e8ba(["site"]):::queued
    x0751853b619def05["xaringan_html_files"]:::queued --> xccbb2c85646c611a["xaringan_pdfs"]:::queued
    xdf832f8e1f99baf2(["schedule_file"]):::queued --> x063edd335cc1b36f(["schedule_page_data"]):::queued
    xf4774655f169db90["xaringan_files"]:::queued --> x60c212b45249134a["xaringan_slides"]:::queued
    xdf832f8e1f99baf2(["schedule_file"]):::queued --> x35552a73efe9c59f(["schedule_ical_data"]):::queued
    x7a0d40becb063bda(["xaringan_html_files_files"]):::queued --> x0751853b619def05["xaringan_html_files"]:::queued
    x35552a73efe9c59f(["schedule_ical_data"]):::queued --> x4d31f5a49d5ae49f(["schedule_ical_file"]):::queued
    x60c212b45249134a["xaringan_slides"]:::queued --> x7a0d40becb063bda(["xaringan_html_files_files"]):::queued
    x6e52cb0f1668cc22(["readme"]):::started --> x6e52cb0f1668cc22(["readme"]):::started
  end
```

## Licenses

**Text and figures:** All prose and images are licensed under Creative
Commons ([CC-BY-NC
4.0](https://creativecommons.org/licenses/by-nc/4.0/))

**Code:** All code is licensed under the [MIT License](LICENSE.md).
