ICON_SRC="$1"
TEXT="$2"

cd "$ICON_SRC"

watermarked_dir="watermarked"
[ -d $watermarked_dir ] || mkdir $watermarked_dir

for image in *png
do
 if [ -s $image ] ; then
    image_height=$(identify -format %w $image)
    watermark_height=$(echo $image_height/3 | bc)
    watermark_width=$(echo $image_height | bc)

    mv "$image" "temp-$image"

    convert -background '#0008' -fill white -gravity center \
       -font ArialUnicode \
       -size ${watermark_width}x${watermark_height} "caption:${TEXT}" \
       "temp-$image" +swap -gravity SouthEast \
       -composite "$image"

    rm "temp-$image"

    echo "Processed $image"
  fi
done
