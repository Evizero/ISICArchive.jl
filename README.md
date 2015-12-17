# ISICArchive.jl

Julia package to access the API of the [ISIC Archive](https://isic-archive.com/).

[![Build Status](https://travis-ci.org/Evizero/ISICArchive.jl.svg?branch=master)](https://travis-ci.org/Evizero/ISICArchive.jl)

## Installation

You can clone the package from Github

```Julia
Pkg.clone("git@github.com:Evizero/ISICArchive.jl.git")
using ISICArchive
```

## Getting Started

### dataset

#### /dataset

Query the list of available lesion datasets.

```Julia
dataset_list = get(DatasetList(limit = 5))
```

```
5-element Array{ISICArchive.ListEntry,1}:
 ISIC_MSK-1_1: id = 5627f42b9fc3c132be08d84f, updated = 2015-10-21T20:33:21
 ISIC_MSK-2_1: id = 5627f5f69fc3c132be08d852, updated = 2015-10-21T20:33:29
 ISIC_SONIC_1: id = 5627eefe9fc3c132be08d84c, updated = 2015-10-21T20:01:02
 ISIC_UDA-1_1: id = 54b6e869bae4785ee2be8652, updated = 2014-11-10T02:39:56
 ISIC_UDA-2_1: id = 54ea816fbae47871b5e00c80, updated = 2015-03-06T14:54:30
```

#### /dataset

Query the details of a lesion image dataset.

```Julia
# info = get(Dataset(id = "5627f42b9fc3c132be08d84f"))
info = get(Dataset(dataset_list[1]))
```

```
ISICArchive.DatasetInfo
  .name: ISIC_MSK-1_1
  .id: 5627f42b9fc3c132be08d84f
  .modelType: folder
  .creatorId: 54cb974fbae47819d8e4c727
  .created: 2015-06-30T14:48:42
  .updated: 2015-10-21T20:33:21

Moles and melanomas.
Biopsy-confirmed melanocytic lesions, both malignant and benign.
```

## License

This Julia code of `ISICArchive.jl` is free to use under the terms of the MIT license.

Please note and respect that the content of [ISIC Archive](https://isic-archive.com/) is protected under is own license.
