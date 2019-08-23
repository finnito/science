#!/bin/bash

cd content

modulesToBuild=(
    "10sci/5-fire-and-fuels"
    "10scie/6-geology"
    "11sci/4-mechanics"
    "11sci/5-genetics"
    "12phy/2-mechanics"
    "12phy/3-electricity"
)

for i in "${modulesToBuild[@]}"; do

    # Navigate to the directory.
    echo "Navigating to $i"
    ls
    cd $i

    # Build the HTML slides and
    # PDFs for all markdown docs.
    cd markdown
    for filename in *.md; do
        [ -f "$i" ] || break
        file=${filename##*/}
        name=${file%%.*}
        echo "Building $name.html"
        pandoc -s --mathjax -i -t revealjs "$name.md" -o "$name.html"
        echo "Building $name.pdf"
        pandoc "$name.md" -o "$name.pdf" --pdf-engine=pdflatex
    done

    # Put the HTML slides and
    # PDFs into the right place.
    echo "Moving slides & PDFs"
    mv *.html ../slides/
    mv *.pdf ../pdfs/

    # Create a ZIP of the PDFs
    # available for download.
    cd ../
    echo "Creating .zip"
    topic=${PWD##*/}
    cd pdfs
    zip "$topic".zip *
    mv *.zip ../
    cd ../
done
