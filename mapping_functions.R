# Upload geojson files
upload_geojson <- function(path, name){
  filepath <- paste(path, paste0(name, ".geojson"), sep = .Platform$file.sep)
  data <- sf::st_read(filepath, quiet=TRUE)
  return(data)
}
# Building
map_building <- function(building){
  building <- st_transform(building, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  pal <- colorNumeric("viridis", min(building$HEIGHT_ROOF):max(building$HEIGHT_ROOF), reverse=TRUE)
  map <- leaflet(building) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    # setView(centre_point[1], centre_point[2], zoom=13) %>%
    # addPolygons(data=zone, color='orange', fill=FALSE, opacity=0.5, group=c("Studied area")) %>%
    addPolygons(stroke=FALSE, smoothFactor=0.3, fillOpacity=1, fillColor=~pal(HEIGHT_ROOF), 
                label=~paste0(TYPE, "\n(", NB_LEV, " levels, ", MAIN_USE, ")"), group=c("Buildings")) %>%
    addLegend(pal=pal, values=~HEIGHT_ROOF, opacity=1.0, title='Building height (m)')
  return(map)
}
# Ground nature
map_ground_nature <- function(ground){
  ground <- st_transform(ground, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  nb_ground_natures <- length(unique(ground$LAYER))
  mycolors <- c('lightgreen', 'darkgreen', 'lightblue', 'gray')
  qpal <- colorFactor(mycolors, ground$LAYER, n=nb_ground_natures, ordered = TRUE)
  qpal_colors <- qpal(unique(ground$LAYER)) # hex codes
  qpal_labs <- as.factor(c("low_vegetation", "high_vegetation", "water", "impervious")) #unique(ground$LAYER)
  leaflet(ground) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    # setView(centre_point[1], centre_point[2], zoom=13) %>%
    addPolygons(stroke=FALSE, smoothFactor=0.3, fillOpacity=0.6, fillColor=~qpal(LAYER), 
                label=~paste0(LAYER, "\n(", TYPE, ", G=", G, ")")) %>%
    addLegend(colors=qpal_colors, labels=qpal_labs, values=~LAYER, opacity=1.0, title='Ground nature')
}
# Ground absorption
map_ground_absorption <- function(ground){
  ground <- st_transform(ground, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  nb_G_values <- length(unique(ground$G))
  qpal <- colorFactor(palette = "Purples", domain = ground$G, n = nb_G_values)
  qpal_labs <- as.factor(sort(unique(ground$G))) #unique(ground$LAYER)
  qpal_colors <- qpal(qpal_labs) # hex codes
  leaflet(ground) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    # setView(centre_point[1], centre_point[2], zoom=13) %>%
    addPolygons(stroke=FALSE, smoothFactor=0.3, fillOpacity=0.6, fillColor=~qpal(G), 
                label=~paste0(LAYER, "\n(", TYPE, ", G=", G, ")")) %>%
    addLegend(colors=qpal_colors, labels=qpal_labs, values=~G, opacity=1.0, title='G')
}
# Road surfaces
map_road_surfaces <- function(road_traffic){
  road_traffic <- st_transform(road_traffic, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  road_surfaces = unique(road_traffic$SURFACE)
  nb_surfaces <- as.numeric(length(road_surfaces))
  mycolors <- colorRampPalette(brewer.pal(8, "Set2"))(nb_surfaces)
  qpal <- colorFactor(mycolors, road_traffic$SURFACE, na.color="gray") # the extra code road of the existing pal
  qpal_colors <- qpal(unique(road_surfaces)) # hex codes
  qpal_labs <- sort(unique(road_surfaces))
  if('null' %in% qpal_labs){
    qpal_labs <- revalue(qpal_labs, c("null"="unallocated"))
    qpal_labs <- forcats::fct_relevel(qpal_labs, "unallocated", after=Inf)
    qpal_labs <- qpal_labs[-which(qpal_labs=="unallocated")]
    cfacs <- as.character(qpal_labs)
    new_qpal_labs <- c(cfacs, "unallocated")
    qpal_labs <- factor(new_qpal_labs, levels=levels(qpal_labs))
  }
  leaflet(road_traffic) %>%
    addProviderTiles(providers$CartoDB.Positron)  %>%
    # setView(centre_point[1], centre_point[2], zoom=13) %>%
    addPolylines(stroke=TRUE, fill=FALSE, opacity=1.0, color=~qpal(SURFACE), weight=5) %>%
    addLegend(colors=qpal_colors, labels=qpal_labs, opacity=1, title='Road surfaces', na.label="unallocated")
}
# Road types
map_road_types <- function(road_traffic){
  road_traffic <- st_transform(road_traffic, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  nb_road_types <- length(unique(road_traffic$ROAD_TYPE))
  mycolors <- colorRampPalette(brewer.pal(8, "Set2"))(nb_road_types)
  qpal <- colorFactor(mycolors, road_traffic$ROAD_TYPE, n=nb_road_types)
  qpal_colors <- qpal(unique(road_traffic$ROAD_TYPE)) # hex codes
  qpal_labs <- unique(road_traffic$ROAD_TYPE)
  levels(qpal_labs)<-c(levels(qpal_labs), "unallocated") # Add the extra level to the factor
  qpal_labs[is.na(qpal_labs)] <- "unallocated"
  leaflet(road_traffic) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    # setView(centre_point[1], centre_point[2], zoom=13) %>%
    addPolylines(fill=FALSE, opacity=1.0, color=~qpal(road_traffic$ROAD_TYPE), #weight=0.2*road_traffic$WIDTH, 
                 label=~paste0(ROAD_TYPE, " (surface: ", SURFACE, ")"), group=c("Road types")) %>%
    # addPolygons(data=zone, color='orange', fill=FALSE, opacity=0.5, group=c("Studied area")) %>%
    addLegend(colors=qpal_colors, labels=qpal_labs, values=~ROAD_TYPE, opacity=1.0, title='Road types')
}
# Road traffic
map_daily_traffic <- function(road_traffic){
  road_traffic <- st_transform(road_traffic, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  road_traffic$LV_HV_DAY <- 12 * as.numeric(road_traffic$DAY_LV_HOUR) + 4 * as.numeric(road_traffic$EV_LV_HOUR) + 8 * as.numeric(road_traffic$NIGHT_LV_HOUR)
                           +12 * as.numeric(road_traffic$DAY_HV_HOUR) + 4 * as.numeric(road_traffic$EV_HV_HOUR) + 8 * as.numeric(road_traffic$NIGHT_HV_HOUR)
  nb_wgaen_types <- length(unique(road_traffic$ROAD_TYPE))
  mycolors <- colorRampPalette(brewer.pal(8, "Set2"))(nb_wgaen_types)
  qpal <- colorFactor(mycolors, road_traffic$ROAD_TYPE, n=nb_wgaen_types)
  qpal_colors <- qpal(unique(road_traffic$ROAD_TYPE)) # hex codes
  qpal_labs <- unique(road_traffic$ROAD_TYPE)
  leaflet(road_traffic) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    # setView(centre_point[1], centre_point[2], zoom=13) %>%
    addPolylines(data=road_traffic, fill=FALSE, opacity=1.0, color=~qpal(road_traffic$ROAD_TYPE), weight=2, # weight=0.001*road_traffic$LV_HV_DAY,  
                 label=~paste0(ROAD_TYPE, " (daily traffic: ", LV_HV_DAY, ")"), group=c("Road traffic")) %>%
    addLegend(colors=qpal_colors, labels=qpal_labs, values=~ROAD_TYPE, opacity=1.0, title='Road traffic')
}
# Road pavement identifiers
map_road_pvmt <- function(road_traffic){
  road_traffic <- st_transform(road_traffic, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  road_pavements = unique(road_traffic$PAVEMENT)
  nb_surfaces <- as.numeric(length(road_pavements))
  mycolors <- colorRampPalette(brewer.pal(8, "Set2"))(nb_surfaces)
  qpal <- colorFactor(mycolors, road_traffic$PAVEMENT, na.color="gray") # the extra code building off the existing pal
  qpal_colors <- qpal(unique(road_pavements)) # hex codes
  qpal_labs <- sort(unique(road_pavements))
  leaflet(road_traffic) %>%
    addProviderTiles(providers$CartoDB.Positron) %>%
    # setView(centre_point[1], centre_point[2], zoom=13) %>%
    addPolylines(stroke=TRUE, fill=FALSE, opacity=1.0, color=~qpal(PAVEMENT), weight=5) %>%
    addLegend(colors=qpal_colors, labels=qpal_labs, opacity=1, title='Road pavements', na.label="unallocated")
}
# Random grid of receivers
map_random_grid_receivers <- function(recs_grid){
  recs_grid <- st_transform(recs_grid, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  recs_grid$lat <- st_coordinates(recs_grid)[, 'X']
  recs_grid$lon <- st_coordinates(recs_grid)[, 'Y']
  leaflet(recs_grid) %>% 
    addProviderTiles(providers$CartoDB.Positron) %>% 
    # setView(centre_point[1], centre_point[2], zoom=13) %>% 
    addCircleMarkers(data=recs_grid, radius=4, color="black", stroke=FALSE, fillOpacity=0.75, 
                     popup=paste("<br>Receiver PK:", recs_grid$PK, "<br></br>(", recs_grid$lat, ", ", recs_grid$lon, ")"))
}
# Delaunay grid of receivers
map_delaunay_grid_receivers <- function(recs_grid, tris){
  recs_grid <- st_transform(recs_grid, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  recs_grid$lat <- st_coordinates(recs_grid)[, 'X']
  recs_grid$lon <- st_coordinates(recs_grid)[, 'Y']
  
  tris <- st_transform(tris, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  for(idtri in seq(length(tris$geometry))){
   tris$geometry[[idtri]] <- st_zm(st_polygon(x = tris$geometry[[idtri]], dim = "XYZ"), drop = TRUE)
  }
  
  leaflet(recs_grid) %>% 
    addProviderTiles(providers$CartoDB.Positron) %>% 
    # setView(centre_point[1], centre_point[2], zoom=13) %>% 
    addPolygons(data=tris, weight = 2, fillColor = "yellow", 
                popup=paste("<br>Triangle PK:", tris$PK, "<br></br>(receivers-vertices ", tris$PK_1, ", ", tris$PK_2, ", ", tris$PK_3, ")"), 
                group = "Triangles") %>% 
    addCircleMarkers(data=recs_grid, radius=4, color="black", stroke=FALSE, fillOpacity=0.75, 
                     popup=paste("<br>Receiver PK:", recs_grid$PK, "<br></br>(", recs_grid$lat, ", ", recs_grid$lon, ")"), 
                     group = "Receivers")
}
# Iso-colours for noise levels
iso_noise_colors <- function(){
  return(c('#82A6AD', '#A0BABF', '#B8D6D1', '#CEE4CC', '#E2F2BF', '#F3C683', '#E87E4D', '#CD463E', '#A11A4D', '#75085C', '#430A4A'))
}
# Noise levels over receiver grid
map_noise_lvl_recs_grid <- function(noise_levels_recs_grid){
  noise_levels_recs_grid <- st_transform(noise_levels_recs_grid, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  noise_levels_recs_grid$lat <- st_coordinates(noise_levels_recs_grid)[, 'X']
  noise_levels_recs_grid$lon <- st_coordinates(noise_levels_recs_grid)[, 'Y']
  
  bins <- c(-200, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 200)
  noise_colors <- iso_noise_colors()
  labels <- c('<35', '35-40', '40-45', '45-50', '50-55', '55-60', '60-65', '65-70', '70-75', '75-80', '>80')
  qpal_noise <- colorBin(palette=noise_colors, bins=bins, domain=noise_levels_recs_grid$LAEQ)
  indicator = "LAEQ"
  leaflet(noise_levels_recs_grid) %>% 
    addProviderTiles(providers$CartoDB.Positron) %>% 
    # setView(centre_point[1], centre_point[2], zoom=13) %>% 
    addCircleMarkers(data=noise_levels_recs_grid, radius=4, color=~qpal_noise(LAEQ), stroke=FALSE, fillOpacity=0.75, 
                     popup=paste("<br>Receiver id:", noise_levels_recs_grid$IDRECEIVER, "<br></br>", noise_levels_recs_grid$LAEQ, " dB(A)"), 
                     group=c(paste0(indicator, " at receivers"))) %>% 
    addLegend(colors=noise_colors, labels=labels, values=~LAEQ, opacity=1.0, title='Noise class (dB(A))', position="bottomleft", group=c(paste0(indicator, " at receivers")))
}
# Iso-noise levels
map_noise_lvl_delaunay_grid <- function(noise_levels_delaunay_grid){
  noise_levels_delaunay_grid <- st_transform(noise_levels_delaunay_grid, CRS("+proj=longlat +init=epsg:4326 +ellps=WGS84 +datum=WGS84 +no_defs"))
  # noise_levels_delaunay_grid$lat <- st_coordinates(noise_levels_delaunay_grid)[, 'X']
  # noise_levels_delaunay_grid$lon <- st_coordinates(noise_levels_delaunay_grid)[, 'Y']
  noise_colors <- iso_noise_colors()
  iso_breaks <- c(0, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 200)
  iso_labels <- c('<35', '35-40', '40-45', '45-50', '50-55', '55-60', '60-65', '65-70', '70-75', '75-80', '>80')
  qpal_noise <- colorFactor(palette=noise_colors, domain=seq(0, 10), n=length(noise_colors))
  qpal_noise_colors <- qpal_noise(seq(0, 10)) # hex codes
  indicator = "LAEQ"
  leaflet(noise_levels_delaunay_grid) %>% 
    addProviderTiles(providers$CartoDB.Positron) %>% 
    # setView(centre_point[1], centre_point[2], zoom=13) %>% 
    addPolygons(data=noise_levels_delaunay_grid, stroke=FALSE, smoothFactor=0.3, fillOpacity=1, fillColor=~qpal_noise(ISOLVL), 
                popup=~paste0("<br>Polygon Id:", CELL_ID, "<br></br>ISOLVL:", ISOLVL, "<br></br>ISOLABEL:", ISOLABEL), 
                               group=c(paste0(indicator, " noise map based on OSM data"))) %>% 
    addLegend(colors=qpal_noise_colors, labels=iso_labels, values=~ISOLVL, opacity=1.0, title='Noise class (dB(A))', position="bottomleft")
}