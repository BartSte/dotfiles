#!/bin/bash

echo "Looking for .py file in $1"
echo "Saving pdfs to $2"
echo

REPOSITORY=$1

while read source_file
do
  filename=$(basename $source_file)
  dir=$(dirname $source_file)

  # For each file found, generate a HTML file in /tmp
  pygmentize -l python -f html -O full,style=default,linenos=1 $source_file > /tmp/${filename}.html

  # Convert the HTML file to a PDF file
  # Save the PDF file into the selected folder (specified by cmdline argument 2)
  # The folder structure in the selected folder is the same as in the original folder
  rel_path=$(realpath --relative-to=$REPOSITORY $source_file)

  # The name of the generated PDF include the path to the original .py file, relative to the original folder (specified by cmdline argument 1)
  # / in the path is replaced by .
  save_name=${rel_path////'.'}

  child_dir=$(dirname $rel_path)

  # Create child directory if does not exist
  mkdir -p "$2/${child_dir}"

  # Convert html file to pdf
  # Do not print background color
  # Set the header of the file to be the file name
  # We enclose the output file path in quote so that it can handle space in the path name
  wkhtmltopdf --no-background -q --header-center ${save_name} /tmp/${filename}.html "$2/${child_dir}/${save_name}.pdf"

  echo "Generated PDF for $save_name"

done < <(find $REPOSITORY -type f -iname '*.py')
