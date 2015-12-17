using ISICArchive
using Base.Test

# Basic tests that see if calls suceed.
# i.e. these test will detect drastic api changes

dataset_list = get(DatasetListRequest(limit = 4))
@test length(dataset_list) == 4

info = get(DatasetMetadataRequest(id = "5627f42b9fc3c132be08d84f"))
info = get(DatasetMetadataRequest(dataset_list[1]))

image_list = get(ImageListRequest(datasetId = "5627f42b9fc3c132be08d84f", limit = 5))
@test length(image_list) == 5
image_list = get(ImageListRequest(info, limit = 5))
@test length(image_list) == 5
image_list = get(ImageListRequest(dataset_list[1], limit = 5))
@test length(image_list) == 5

img_info = get(ImageMetadataRequest(id = "5592ac579fc3c13155a57a80"))
img_info = get(ImageMetadataRequest(image_list[1]))

img = get(ImageThumbnailRequest(id = "5592ac579fc3c13155a57a80"))
img = get(ImageThumbnailRequest(img_info))
img = get(ImageThumbnailRequest(image_list[1]))

# download of high-quality will not be tested
