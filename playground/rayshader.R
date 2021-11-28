library(rayshader)
library(stars)

dem = read_stars('https://raw.githubusercontent.com/tsamsonov/r-geo-course/master/data/dem_fergana.tif')

elev = dem[[1]]

dim(elev) <- unname(dim(elev))
dim(elev)

elev %>%
  sphere_shade(texture = "desert") %>%
  add_water(detect_water(elev), color = "desert") %>%
  add_shadow(ray_shade(elev, zscale = 3), 0.5) %>%
  add_shadow(ambient_shade(elev), 0) %>%
  plot_3d(elev, zscale = 100, fov = 0, theta = 135, zoom = 0.75, phi = 45, windowsize = c(1000, 800))

Sys.sleep(0.2)
render_snapshot()

raster_to_matrix()