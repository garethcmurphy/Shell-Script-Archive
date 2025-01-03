#!/bin/bash
base=$1
convert "$base" -resize '29x29'     -unsharp 1x4 "Icon-Small.png"
convert "$base" -resize '40x40'     -unsharp 1x4 "Icon-Small-40.png"
convert "$base" -resize '50x50'     -unsharp 1x4 "Icon-Small-50.png"
convert "$base" -resize '57x57'     -unsharp 1x4 "Icon.png"
convert "$base" -resize '58x58'     -unsharp 1x4 "Icon-Small@2x.png"
convert "$base" -resize '60x60'     -unsharp 1x4 "Icon-60.png"
convert "$base" -resize '72x72'     -unsharp 1x4 "Icon-72.png"
convert "$base" -resize '76x76'     -unsharp 1x4 "Icon-76.png"
convert "$base" -resize '80x80'     -unsharp 1x4 "Icon-Small-40@2x.png"
convert "$base" -resize '100x100'   -unsharp 1x4 "Icon-Small-50@2x.png"
convert "$base" -resize '114x114'   -unsharp 1x4 "Icon@2x.png"
convert "$base" -resize '120x120'   -unsharp 1x4 "Icon-60@2x.png"
convert "$base" -resize '144x144'   -unsharp 1x4 "Icon-72@2x.png"
convert "$base" -resize '152x152'   -unsharp 1x4 "Icon-76@2x.png"
convert "$base" -resize '180x180'   -unsharp 1x4 "Icon-60@3x.png"
convert "$base" -resize '512x512'   -unsharp 1x4 "iTunesArtwork"
convert "$base" -resize '1024x1024' -unsharp 1x4 "iTunesArtwork@2x"

convert "$base" -resize '36x36'     -unsharp 1x4 "Icon-ldpi.png"
convert "$base" -resize '48x48'     -unsharp 1x4 "Icon-mdpi.png"
convert "$base" -resize '72x72'     -unsharp 1x4 "Icon-hdpi.png"
convert "$base" -resize '96x96'     -unsharp 1x4 "Icon-xhdpi.png"
convert "$base" -resize '144x144'   -unsharp 1x4 "Icon-xxhdpi.png"
convert "$base" -resize '192x192'   -unsharp 1x4 "Icon-xxxhdpi.png"
