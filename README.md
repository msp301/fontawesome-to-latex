# fontawesome-to-latex
Generate LaTeX definitions from Font Awesome icon metadata

# Getting Started

1. Download the latest Font Awesome release
2. Extract the archive somewhere
3. Point `fontawesome-to-latex` to the Font Awesome `icons.json` metadata file and specify and output file to write the LaTeX mappings to.

```
perl fontawesome-to-latex.pl FONT_AWESOME_DIR/advanced-options/metadata/icons.json fontawesome.sty
```

4. Place `fontawesome.sty` with your LaTeX project.
5. Place Font Awesome 'use-on-desktop' fonts with your LaTeX project.
6. Use in your `.tex`:

```
\usepackage{fontawesome}
\newfontfamily{\FABrands} [Path = path/to/Font-Awesome/]{Font Awesome 5 Brands-Regular-400}
\newfontfamily{\FARegular}[Path = path/to/Font-Awesome/]{Font Awesome 5 Free-Regular-400}
\newfontfamily{\FASolid}  [Path = path/to/Font-Awesome/]{Font Awesome 5 Free-Solid-900}
```

7. `Done {\FASolid \faCheck}`

# How to use awesome fonts?

```
Happy Birthday {\FASolid \faBirthdayCake}
```

Specify a font style via the `\FABrands`, `\FARegular` or `\FASolid` font families listed in your `.tex` file.

Icon commands use the naming prefix `\fa` followed by the Font Awesome icon name in `TitleCase`. For example the Font Awesome icon `birthday-cake` maps to `\faBirthdayCake`.

Numbers are invalid in LaTeX command names so any digits contained in Font Awesome icon names use their word from e.g. `0` -> `Zero` or `99` -> `NineNine`.

Refer to the Font Awesome icon gallery: https://fontawesome.com/icons