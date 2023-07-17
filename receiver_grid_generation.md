WARNING: An illegal reflective access operation has occurred
WARNING: Illegal reflective access by org.codehaus.groovy.vmplugin.v7.Java7$1 (file:/home/gguillaume/Documents/Scripts/Carto_GeoClimate_NoiseModelling/NoiseModelling_without_gui/lib/groovy-2.5.5.jar) to constructor java.lang.invoke.MethodHandles$Lookup(java.lang.Class,int)
WARNING: Please consider reporting this to the maintainers of org.codehaus.groovy.vmplugin.v7.Java7$1
WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
WARNING: All illegal access operations will be denied in a future release
[main] INFO org.noise_planet.noisemodelling - Start : Delaunay grid
[main] INFO org.noise_planet.noisemodelling - inputs {sourcesTableName=ROAD_TRAFFIC, s=NoiseModelling_without_gui/noisemodelling/wps/Receivers/Delaunay_Grid.groovy, maxArea=2500, w=./, tableBuilding=BUILDING, isoSurfaceInBuildings=0, maxPropDist=250, fence=POLYGON ((-2.408218 47.79168, -2.361412 47.79383, -2.364445 47.82388, -2.411278 47.82172, -2.408218 47.79168)), progressVisitor=org.noise_planet.noisemodelling.pathfinder.RootProgressVisitor@5109e8cf, roadWidth=2, height=4}
[main] INFO org.noise_planet.noisemodelling - Delaunay initialize
[main] INFO org.noise_planet.noisemodelling - Compute cell 1 of 4
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - Begin processing of cell 1 / 4
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - Begin delaunay
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - End delaunay
[main] INFO org.noise_planet.noisemodelling.pathfinder.RootProgressVisitor - 25,00 %
[main] INFO org.noise_planet.noisemodelling - Compute cell 2 of 4
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - Begin processing of cell 2 / 4
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - Begin delaunay
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - End delaunay
[main] INFO org.noise_planet.noisemodelling - Compute cell 3 of 4
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - Begin processing of cell 3 / 4
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - Begin delaunay
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - End delaunay
[main] INFO org.noise_planet.noisemodelling.pathfinder.RootProgressVisitor - 75,00 %
[main] INFO org.noise_planet.noisemodelling - Compute cell 4 of 4
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - Begin processing of cell 4 / 4
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - Begin delaunay
[main] INFO org.noise_planet.noisemodelling.jdbc.TriangleNoiseMap - End delaunay
[main] INFO org.noise_planet.noisemodelling - Create spatial index on RECEIVERS table
[main] INFO org.noise_planet.noisemodelling - Result : Process done. RECEIVERS (18098 receivers) and TRIANGLES tables created. 
[main] INFO org.noise_planet.noisemodelling - End : Delaunay grid
[main] INFO org.noise_planet - Process done. RECEIVERS (18098 receivers) and TRIANGLES tables created. 
