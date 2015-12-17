using ISICArchive
using Base.Test

# Basic tests that see if calls suceed.
# i.e. these test will detect drastic api changes

dataset_list = get(DatasetList(limit = 4))
@test length(dataset_list) == 4

info = get(Dataset(id = "5627f42b9fc3c132be08d84f"))
info = get(Dataset(dataset_list[1]))

image_list = get(ImageList(datasetId = "5627f42b9fc3c132be08d84f", limit = 5))
@test length(image_list) == 5
image_list = get(ImageList(info, limit = 5))
@test length(image_list) == 5
image_list = get(ImageList(dataset_list[1], limit = 5))
@test length(image_list) == 5

img_info = get(ImageMetadata(id = "5592ac579fc3c13155a57a80"))
img_info = get(ImageMetadata(image_list[1]))

img = get(ImageThumbnail(id = "5592ac579fc3c13155a57a80"))
img = get(ImageThumbnail(img_info))
img = get(ImageThumbnail(image_list[1]))

# download of high-quality will not be tested
