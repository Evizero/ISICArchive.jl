# ISICArchive.jl

[![Project Status: Inactive - The project has reached a stable, usable state but is no longer being actively developed; support/maintenance will be provided as time allows.](http://www.repostatus.org/badges/latest/inactive.svg)](http://www.repostatus.org/#inactive)
[![License](http://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](LICENSE.md)

[Julia](http://julialang.org/) package to interact with the [ISIC Archive](https://isic-archive.com/) [REST API]((https://isic-archive.com/api/v1)).

[![Build Status](https://travis-ci.org/Evizero/ISICArchive.jl.svg?branch=master)](https://travis-ci.org/Evizero/ISICArchive.jl)

## Installation

You can clone the package from Github

```Julia
Pkg.clone("git@github.com:Evizero/ISICArchive.jl.git")
using ISICArchive
```

## Getting Started

The following [API calls](https://isic-archive.com/api/v1) are supported

### dataset

#### /dataset

List of available lesion datasets.

```Julia
dataset_list = get(DatasetListRequest(limit = 5))
```

```
5-element Array{ISICArchive.ListEntry,1}:
 ISIC_MSK-1_1: id = 5627f42b9fc3c132be08d84f, updated = 2015-10-21T20:33:21
 ISIC_MSK-2_1: id = 5627f5f69fc3c132be08d852, updated = 2015-10-21T20:33:29
 ISIC_SONIC_1: id = 5627eefe9fc3c132be08d84c, updated = 2015-10-21T20:01:02
 ISIC_UDA-1_1: id = 54b6e869bae4785ee2be8652, updated = 2014-11-10T02:39:56
 ISIC_UDA-2_1: id = 54ea816fbae47871b5e00c80, updated = 2015-03-06T14:54:30
```

#### /dataset/{id}

Details of a lesion image dataset.

```Julia
# info = get(DatasetMetadataRequest(id = "5627f42b9fc3c132be08d84f"))
info = get(DatasetMetadataRequest(dataset_list[1]))
```

```
ISICArchive.DatasetMetadata
  .name: ISIC_MSK-1_1
  .id: 5627f42b9fc3c132be08d84f
  .modelType: folder
  .creatorId: 54cb974fbae47819d8e4c727
  .created: 2015-06-30T14:48:42
  .updated: 2015-10-21T20:33:21

Moles and melanomas.
Biopsy-confirmed melanocytic lesions, both malignant and benign.
```

### image

#### /image

List of available images in a lesion datasets.

```Julia
# image_list = get(ImageListRequest(datasetId = "5627f42b9fc3c132be08d84f", limit = 5))
# image_list = get(ImageListRequest(info, limit = 5))
image_list = get(ImageListRequest(dataset_list[1], limit = 5))
```

```
5-element Array{ISICArchive.ListEntry,1}:
 ISIC_0011408: id = 5592ac579fc3c13155a57a80, updated = 2015-11-06T15:08:47
 ISIC_0011409: id = 5592ac599fc3c13155a57a85, updated = 2015-09-03T12:24:51
 ISIC_0011420: id = 5592ac779fc3c13155a57abc, updated = 2015-09-03T12:31:02
 ISIC_0011426: id = 5592ac899fc3c13155a57ada, updated = 2015-09-03T12:33:28
 ISIC_0011427: id = 5592ac8c9fc3c13155a57adf, updated = 2015-08-28T13:45:31
```

#### /image/{id}

Details of an image.

```Julia
# img_info = get(ImageMetadataRequest(id = "5592ac579fc3c13155a57a80"))
img_info = get(ImageMetadataRequest(image_list[1]))
```

```
ISICArchive.ImageMetadata
  .name: ISIC_0011408
  .id: 5592ac579fc3c13155a57a80
  .modelType: item
  .creatorId: 54cb974fbae47819d8e4c727
  .created: 2015-06-30T14:48:55
  .updated: 2015-11-06T15:08:47
  .class: benign
  .description:

...
```

#### /image/{id}/thumbnail

Download a thumbnail of an image

```Julia
# img = get(ImageThumbnailRequest(id = "5592ac579fc3c13155a57a80"))
# img = get(ImageThumbnailRequest(img_info))
img = get(ImageThumbnailRequest(image_list[1]))
```

```
RGB Images.Image with:
  data: 255x170 Array{ColorTypes.RGB{FixedPointNumbers.UFixed{UInt8,8}},2}
  properties:
    colorspace: sRGB
    spatialorder:  x y
```

#### /image/{id}/download

Download the high-quality version of an image

```Julia
# img = get(ImageDownloadRequest(id = "5592ac579fc3c13155a57a80"))
# img = get(ImageDownloadRequest(img_info))
img = get(ImageDownloadRequest(image_list[1]))
```

```
RGB Images.Image with:
  data: 6668x4439 Array{ColorTypes.RGB{FixedPointNumbers.UFixed{UInt8,8}},2}
  properties:
    colorspace: sRGB
    spatialorder:  x y
```

## License

This Julia code of `ISICArchive.jl` is free to use under the terms of the MIT license.

Please note and respect that the content of [ISIC Archive](https://isic-archive.com/) is protected under is own license.
